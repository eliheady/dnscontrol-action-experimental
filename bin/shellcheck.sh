#!/bin/sh

# extract each bash `run` step from action.yml and run it through `bash -n` for
# validity and shellcheck for safety. requires `yq` and `shellcheck` in $PATH

IFS="
"

for n in $(yq '.runs.steps[].name' < action.yml )
do
  set +e
  tmpscript=$(mktemp)
  yq ".runs.steps[] | select(.name == \"$n\") | .run" < action.yml > "$tmpscript"
  bash -n "$tmpscript" || echo "the script in $n did not pass the validity check"
  shellcheck --shell bash -e SC2086 "$tmpscript" || echo "the script in $n did not pass shellcheck"
  rm $tmpscript
  set -e
done