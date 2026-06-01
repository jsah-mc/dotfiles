#!/usr/bin/env bash
set -euo pipefail

if quickshell list -c jsah --json 2>/dev/null | jq -e 'length > 0' >/dev/null 2>&1; then
    quickshell ipc -c jsah call launcher toggle >/dev/null 2>&1 || true
else
    quickshell --daemonize --config jsah >/dev/null 2>&1 &
fi
