#!/usr/bin/env bash

set -euo pipefail

# Resolve to full paths
CONFIG_ABS_PATH="$(readlink -f "${INPUT_DNSCONFIG_FILE}")"
CREDS_ABS_PATH="$(readlink -f "${INPUT_CREDS_FILE}")"
if [ "${INPUT_OUTPUT_FILE}" != "" ]; then
  OUTPUTFILE_ABS_PATH="$(readlink -f "${INPUT_OUTPUT_FILE}")"
fi

WORKING_DIR="$(dirname "${CONFIG_ABS_PATH}")"
cd "$WORKING_DIR" || exit

ARGS=(
  "$@"
  --config "$CONFIG_ABS_PATH"
)

if [ "$1" != "check" ]; then
  ARGS+=(--creds "$CREDS_ABS_PATH")
fi

VERSION="$(dnscontrol version)"

echo "Running dnscontrol $VERSION with args: ${ARGS[*]}"

OUTPUT="$(dnscontrol "${ARGS[@]}")"
EXIT_CODE="$?"

if [ "$EXIT_CODE" != "0" ]; then
  echo "$OUTPUT"
fi

# Set output
# https://github.com/orgs/community/discussions/26288#discussioncomment-3876281
DELIMITER="DNSCONTROL-$RANDOM"
{
  echo "output<<$DELIMITER"
  echo "$OUTPUT"
  echo "$DELIMITER"
} >>"$GITHUB_OUTPUT"


# write to output file and add filename to GITHUB_OUTPUT
if [ -n "$OUTPUTFILE_ABS_PATH" ]; then
  cat > "$OUTPUTFILE_ABS_PATH" <<EOF
$OUTPUT
EOF
DELIMITER="DNSCONTROL-$RANDOM"
{
  echo "output-file<<$DELIMITER"
  echo "$OUTPUTFILE_ABS_PATH"
  echo "$DELIMITER"
} >>"$GITHUB_OUTPUT"
fi

exit $EXIT_CODE
