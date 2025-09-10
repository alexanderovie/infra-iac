#!/usr/bin/env bash
set -euo pipefail

# 🚀 Script simple para auto-merge PRs
# Uso: ./scripts/auto-merge-pr.sh [PR_NUMBER]

PR_NUMBER="${1:-}"

if [ -z "$PR_NUMBER" ]; then
  echo "❌ Uso: ./scripts/auto-merge-pr.sh [PR_NUMBER]"
  echo "📋 PRs abiertos:"
  gh pr list --state open --json number,title,author --jq '.[] | "\(.number) - \(.title) (by \(.author.login))"'
  exit 1
fi

echo "=== AUTO-MERGING PR #$PR_NUMBER ==="

# Verificar que el PR existe y está listo
PR_STATUS=$(gh pr view "$PR_NUMBER" --json state,mergeable,author --jq '.state + "|" + (.mergeable | tostring) + "|" + .author.login')

IFS='|' read -r state mergeable author <<< "$PR_STATUS"

if [ "$state" != "OPEN" ]; then
  echo "❌ PR #$PR_NUMBER no está abierto (estado: $state)"
  exit 1
fi

if [ "$mergeable" != "MERGEABLE" ]; then
  echo "❌ PR #$PR_NUMBER no se puede mergear (mergeable: $mergeable)"
  exit 1
fi

if [ "$author" != "alexanderovie" ] && [ "$author" != "app/dependabot" ]; then
  echo "❌ PR #$PR_NUMBER no es tuyo ni de dependabot (autor: $author)"
  exit 1
fi

echo "✅ PR #$PR_NUMBER listo para mergear"

# Hacer merge
echo "→ Merging PR #$PR_NUMBER..."
gh pr merge "$PR_NUMBER" --squash --delete-branch

echo "🎉 PR #$PR_NUMBER merged exitosamente!"
