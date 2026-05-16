#!/usr/bin/env bash
set -euo pipefail

high_risk_prefixes=(
  "auth/"
  "billing/"
  "infra/"
  "config/production/"
  "data/delete/"
)

manual_approval="${MANUAL_APPROVAL:-false}"

changed_files=""
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  changed_files="$(git diff --name-only HEAD || true)"
else
  changed_files="$(find . -type f | sed 's#^./##' || true)"
fi

has_high_risk="false"
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  for p in "${high_risk_prefixes[@]}"; do
    if [[ "$f" == "$p"* ]]; then
      has_high_risk="true"
      echo "High-risk change detected: $f"
    fi
  done
done <<< "$changed_files"

if [[ "$has_high_risk" == "true" && "$manual_approval" != "true" ]]; then
  echo "Policy failed: high-risk changes require MANUAL_APPROVAL=true"
  exit 1
fi

echo "Policy checks passed"
