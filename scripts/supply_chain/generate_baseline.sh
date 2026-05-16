#!/usr/bin/env bash
set -euo pipefail

mkdir -p artifacts/sbom artifacts/provenance

SBOM_FILE="artifacts/sbom/sbom-$(date '+%Y%m%d').txt"
PROV_FILE="artifacts/provenance/provenance-$(date '+%Y%m%d').txt"

{
  echo "SBOM Baseline"
  echo "generated_at=$(date '+%Y-%m-%d %H:%M:%S %z')"
  echo "repo_files:"
  find . -type f \
    -not -path './.git/*' \
    -not -path './artifacts/*' \
    -print | sed 's#^./##' | sort
} > "$SBOM_FILE"

{
  echo "Provenance Baseline"
  echo "generated_at=$(date '+%Y-%m-%d %H:%M:%S %z')"
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "git_repo=true"
    echo "git_branch=$(git branch --show-current)"
    echo "git_head=$(git rev-parse --verify HEAD 2>/dev/null || echo no_commit)"
  else
    echo "git_repo=false"
  fi
} > "$PROV_FILE"

echo "Generated: $SBOM_FILE"
echo "Generated: $PROV_FILE"
