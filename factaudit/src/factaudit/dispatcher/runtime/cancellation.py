from __future__ import annotations

import threading

from factaudit.dispatcher.runtime.process import ManagedProcess


class TaskCancellation:
    def __init__(self) -> None:
        self._lock = threading.Lock()
        self._process: ManagedProcess | None = None
        self._reason: str | None = None
        self._force_conclude: bool = False

    def attach_process(self, process: ManagedProcess | None) -> None:
        with self._lock:
            self._process = process
            reason = self._reason
        if process is not None and reason is not None:
            process.cancel(reason)

    def cancel(self, reason: str, force_conclude: bool = False) -> bool:
        with self._lock:
            already_cancelled = self._reason is not None
            if not already_cancelled:
                self._reason = reason
                self._force_conclude = force_conclude
            process = self._process
        if process is not None:
            process.cancel(reason)
        return not already_cancelled

    @property
    def is_cancelled(self) -> bool:
        return self.reason is not None

    @property
    def reason(self) -> str | None:
        with self._lock:
            return self._reason

    @property
    def force_conclude(self) -> bool:
        with self._lock:
            return self._force_conclude
