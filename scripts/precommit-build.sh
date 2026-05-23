#!/usr/bin/env bash
set -euo pipefail

# .tsp 변경이 staged에 있을 때만 동작
staged_tsp="$(git diff --cached --name-only --diff-filter=ACMR | grep -E '\.tsp$' || true)"
if [ -z "$staged_tsp" ]; then
  exit 0
fi

echo "[pre-commit] .tsp 변경 감지 → pnpm build 실행"
pnpm build

# 컴파일 후 openapi.yaml이 변경됐다면 staged에 자동 추가
if ! git diff --quiet -- openapi.yaml; then
  echo "[pre-commit] openapi.yaml 갱신됨 → git add"
  git add openapi.yaml
fi
