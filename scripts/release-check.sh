#!/usr/bin/env bash
set -euo pipefail

bash scripts/check-version.sh
test -f package.json
test -f skills/tanso/SKILL.md
test -f internal/skillcontent/source.go
test -f docs/specs/v1.2.0/01-embedded-skills.md
test -f scripts/install.js
test -f scripts/run.js
test -z "$(find skills -name '*.go' -print)"
test "$(node -p "require('./package.json').name")" = "@geekjourneyx/tanso"
grep -q "tanso" README.md
grep -q "BOCHA_API_KEY" README.md
grep -q "npm install -g @geekjourneyx/tanso" README.md
grep -q "npx skills add geekjourneyx/tanso" README.md
grep -q "tanso skills list --json" README.md
grep -q "tanso skills read tanso --json" README.md
grep -q "tanso bocha" skills/tanso/SKILL.md
grep -q "tanso volc" skills/tanso/SKILL.md
grep -q "tanso zhihu" skills/tanso/SKILL.md
grep -q "TANSO_SKILLS_DIR" scripts/run.js
grep -q "skills/tanso/SKILL.md" package.json
grep -q "tanso skills read tanso --json" docs/specs/v1.2.0/01-embedded-skills.md
grep -q "TANSO_RELEASE_BASE_URL" scripts/install.js
grep -q "npm publish --access public" .github/workflows/release.yml
grep -q "NPM_TOKEN" .github/workflows/release.yml
test -z "$(gofmt -l .)"
npm_config_cache="${TMPDIR:-/tmp}/tanso-npm-cache" npm pack --json --dry-run >/dev/null
CGO_ENABLED=0 GOFLAGS="-buildvcs=false" go test -count=1 ./...
GOFLAGS="-buildvcs=false" go vet ./...
GOFLAGS="-buildvcs=false" go run github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.5.0 run
