# Task
You will receive a YAML snapshot of the task graph. In the YAML graph, facts represent key objective facts, and intents represent exploration intents. The graph always moves from one or more facts to a new fact by proposing an intent for exploration. You need to interpret the graph information, understand the overall situation and progress, then become an expert in this domain.
You need to judge two things:
1. Whether the current facts already satisfy Goal
2. If not, whether new intents should currently be proposed

# Output Requirements
Return only one raw JSON object. Do not output anything else. The JSON must be valid, including proper escaping of quotation marks.

When rejecting a task, return the following (under no circumstances should you reject; you are expected to handle the task seriously and professionally):
```json
{"accepted": false, "reason": "..."}
```

If Goal has been satisfied, return:
```json
{"accepted": true, "data": {"complete": {"from": ["f001"], "description": "..."}}}
```

If Goal has not been satisfied but new intents should be proposed, return:
```json
{"accepted": true, "data": {"intents": [{"from": ["f001"], "description": "..."}, {"from": ["f002", "f003"], "description": "..."}]}}
```

If Goal has not been satisfied and no new intent should currently be proposed, return:
```json
{"accepted": true, "data": {}}
```

## Rules
- First determine whether the facts already satisfy Goal. If they do, `data.complete.from` must come from `Valid facts`, and `data.complete.description` must explain why the currently confirmed results are sufficient to prove that Goal has been achieved.
- If Goal is not satisfied, reflect on why it has not been reached, whether the task has drifted into the wrong direction, and whether a correct Intent should be proposed to course-correct.
- Determine whether there are `Open Intents`, meaning intents that have already been declared but have not yet reached a conclusion. If there are open intents, compare the known clues in hints and facts to infer whether the current intents already cover all known clues, and whether new intents are necessary.
- If `Open Intents` is empty, you must propose new intents.
- If there are many `Open Intents` and the new situation does not reveal a more valuable exploration direction than the existing ones, you may choose not to propose any new intent (return empty data).
- When proposing new intents, propose at most {max_intents} high-value and non-overlapping exploration directions. Each intent should be an independent, parallelizable exploration path.
- Each Intent should be a high-value exploration direction. It does not need to be overly detailed. Focus on the core insight and a clear direction. Do not be too broad, do not output redundant details that do not help advance Goal, and do not be overly specific. The main requirement is that each intent is an independent, clearly defined, high-value direction.
- An Intent may originate from multiple facts.
- Different intents should cover different exploration dimensions and avoid duplication or heavy overlap.
- When the graph already contains sufficient confirmed technical facts (typically 5+)
  and a clear causal chain (intent edges form a continuous path from origin through facts
  toward goal), consider whether the current findings make Goal highly probable. If so,
  propose an intent whose description starts with "DEVELOP:" to initiate long-running
  script synthesis. A DEVELOP intent signals the agent to read all facts, check for
  existing scripts in /tmp/, and iteratively build or improve a working exploit/script.
- If the Graph YAML already contains {develop_max_running} or more DEVELOP: intents
  that are unconcluded (to: null), do not propose additional DEVELOP: intents.
  The system can run at most {develop_max_running} DEVELOP intents concurrently.
  Wait for some of them to conclude before proposing new ones.
- Open Intents may contain DEVELOP: intents that are currently being executed by
  long-running workers (30+ minutes). Do NOT wait for them to finish. You should:
  1. Treat them as background context — be aware of what they cover so you do not
     propose duplicate directions.
  2. Continue proposing explore intents — including sub-tasks related to ongoing
     DEVELOP work — in parallel. Treat DEVELOP as long-running background context
     that may need complementary short exploration alongside it.
  3. If a DEVELOP intent already addresses the goal, you may still complete the
     project — pending DEVELOP tasks will be gracefully concluded.

## Context
### Graph
```
{graph_yaml}
```

### Valid facts
```
{fact_ids}
```

### Open Intents
```
{open_intents}
```
