#!/bin/bash
# forge-mark-done — Mark a roadmap item as verified.
# Usage: ./scripts/forge-mark-done.sh <item_id> "<notes>" [<workarounds>]
# Example: ./scripts/forge-mark-done.sh 1.12 "save_manager write/read confirmed in headless Godot"
#
# This calls forge-guardian which:
#   1. Patches roadmap.md with [x] and timestamp
#   2. Updates SESSION.md
#   3. Commits the change

ITEM_ID="${1}"
NOTES="${2:-}"
WORKAROUNDS="${3:-}"
GUARDIAN_URL="${FORGE_GUARDIAN_URL:-http://localhost:7490}"

if [ -z "${ITEM_ID}" ]; then
    echo "Usage: $0 <item_id> [notes] [workarounds]"
    echo "Example: $0 2.05 'PlayerProfile data class created and verified in headless'"
    exit 1
fi

echo "Marking roadmap item ${ITEM_ID} as VERIFIED..."

PAYLOAD=$(python3 -c "
import json, sys
import os
print(json.dumps({
    'workspace': 'embral',
    'roadmap_item_id': sys.argv[1],
    'verified_by': os.getlogin() + '_manual',
    'notes': sys.argv[2],
    'workarounds': sys.argv[3]
}))
" "${ITEM_ID}" "${NOTES}" "${WORKAROUNDS}")

RESPONSE=$(curl -sf -X POST \
    -H "Content-Type: application/json" \
    -d "${PAYLOAD}" \
    "${GUARDIAN_URL}/verify")

if [ $? -ne 0 ]; then
    echo "❌ forge-guardian not reachable at ${GUARDIAN_URL}"
    echo "   Manual roadmap update required."
    exit 1
fi

STATUS=$(echo "${RESPONSE}" | python3 -c "import json,sys; print(json.load(sys.stdin).get('status','unknown'))")
MESSAGE=$(echo "${RESPONSE}" | python3 -c "import json,sys; print(json.load(sys.stdin).get('message',''))")

echo "Result: ${STATUS}"
echo "${MESSAGE}"

if [ "${STATUS}" = "verified" ]; then
    echo "✅ Roadmap updated and committed."
else
    echo "⚠️  Check the response: ${RESPONSE}"
fi
