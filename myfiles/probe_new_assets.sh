#!/bin/bash
# Probe new Joomla assets for live instances
# Output dir
OUTDIR="/home/kali/myfiles/joomla_test_reports"
TMPDIR="/tmp/joomla_probe_new"
mkdir -p "$TMPDIR"

# Extract unique hostnames from the new assets file
grep -v '^\s*$' /home/kali/myfiles/joomla新资产.txt | grep -v '^主机名$' | grep -v '^#' | \
  sed 's|^https\?://||' | sed 's|/.*$||' | sed 's|:.*$||' | sort -u > "$TMPDIR/all_hosts.txt"

TOTAL=$(wc -l < "$TMPDIR/all_hosts.txt")
echo "Total unique hosts to probe: $TOTAL"

# Probe each host for Joomla indicators
# Save results incrementally
> "$TMPDIR/joomla_found.txt"

# Probe function - check Joomla indicators
check_joomla() {
    local host="$1"
    local result=""
    
    # Skip empty hostnames
    [ -z "$host" ] && return
    
    # HTTP response - check for Joomla generator tag
    response=$(curl -sk --max-time 15 --connect-timeout 10 -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        "https://$host/" 2>/dev/null)
    local curl_exit=$?
    
    # Check for Joomla indicators
    if echo "$response" | grep -qi 'joomla' 2>/dev/null; then
        echo "LIVE_JOOMLA|$host|generator_tag" >> "$TMPDIR/joomla_found.txt"
        return
    fi
    
    # Check /administrator/
    local admin_resp=$(curl -sk --max-time 15 --connect-timeout 10 -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        "https://$host/administrator/" 2>/dev/null)
    if echo "$admin_resp" | grep -qi 'joomla' 2>/dev/null; then
        echo "LIVE_JOOMLA|$host|administrator" >> "$TMPDIR/joomla_found.txt"
        return
    fi
    
    # Check version file
    local version_resp=$(curl -sk --max-time 15 --connect-timeout 10 -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        "https://$host/administrator/manifests/files/joomla.xml" 2>/dev/null)
    if echo "$version_resp" | grep -qi '<extension' 2>/dev/null; then
        echo "LIVE_JOOMLA|$host|joomla_xml" >> "$TMPDIR/joomla_found.txt"
        return
    fi
    
    # Check for Joomla paths
    if echo "$response" | grep -qi 'components/com_\|modules/mod_\|templates/cassiopeia\|templates/protostar\|templates/beez' 2>/dev/null; then
        echo "LIVE_JOOMLA|$host|html_paths" >> "$TMPDIR/joomla_found.txt"
        return
    fi
    
    # Check anyway if HTTP 200
    local http_code=$(curl -sk --max-time 15 --connect-timeout 10 -A "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        -o /dev/null -w "%{http_code}" "https://$host/" 2>/dev/null)
    if [ "$http_code" = "200" ]; then
        echo "LIVE_200|$host|http_200" >> "$TMPDIR/joomla_found.txt"
    fi
}

export -f check_joomla

# Process in batches to avoid overwhelming network
echo "Starting probing..."
COUNTER=0
while IFS= read -r host; do
    check_joomla "$host" &
    COUNTER=$((COUNTER + 1))
    
    # Limit concurrent jobs
    if [ $((COUNTER % 20)) -eq 0 ]; then
        wait
        echo "Probed $COUNTER/$TOTAL hosts..."
    fi
done < "$TMPDIR/all_hosts.txt"

wait
echo "Probing complete. Checked $COUNTER hosts."

# Show results
echo ""
echo "=== RESULTS ==="
echo "Live Joomla instances found:"
grep "LIVE_JOOMLA" "$TMPDIR/joomla_found.txt" 2>/dev/null || echo "(none)"
echo ""
echo "Live HTTP 200 responses (not confirmed Joomla):"
grep "LIVE_200" "$TMPDIR/joomla_found.txt" 2>/dev/null | head -30 || echo "(none)"
echo ""
echo "Total live results:"
wc -l < "$TMPDIR/joomla_found.txt"
