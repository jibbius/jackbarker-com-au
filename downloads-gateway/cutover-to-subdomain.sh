#!/usr/bin/env bash
#
# Step-2 cutover: move the downloads behind the password gate.
#
# Run this ONLY AFTER downloads.jackbarker.com.au is deployed and serving
# (see README.md). What it does:
#   1. Verifies the gated subdomain is live  (returns 401 = gate active).
#   2. Removes the OPEN copies of the artifacts from the root site.
#   3. Repoints /downloads/ at the gated subdomain.
#   4. Commits. Push is opt-in: pass --push, or push yourself afterwards.
#
# Idempotent and safe to re-run. The step-1 guard means it refuses to strip
# the root-site downloads until the replacement is actually online, so there
# is no window with no working download.
#
# Usage:
#   ./cutover-to-subdomain.sh          # guard + remove + repoint + commit
#   ./cutover-to-subdomain.sh --push   # ... and push gh-pages (publishes)

set -euo pipefail

PUSH=0
[ "${1:-}" = "--push" ] && PUSH=1

# Resolve the website repo root from this script's own location, so it works
# regardless of the current directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO"

SUBDOMAIN="https://downloads.jackbarker.com.au"

echo "==> 1/4  Checking the gated subdomain is live ..."
root_code="$(curl -s -o /dev/null -w '%{http_code}' "$SUBDOMAIN/" || true)"
vsix_code="$(curl -s -o /dev/null -w '%{http_code}' "$SUBDOMAIN/architect-language-tools.vsix" || true)"

if [ "$root_code" != "401" ] || [ "$vsix_code" != "401" ]; then
  echo "ABORT: expected HTTP 401 (gate active) from $SUBDOMAIN"
  echo "       got:  / -> $root_code ,  /architect-language-tools.vsix -> $vsix_code"
  echo "       Deploy the subdomain first (see README.md), then re-run."
  echo "       (A 200 with no credentials means it is NOT gated — do not proceed.)"
  exit 1
fi
echo "    OK — subdomain returns 401 on both the page and the .vsix (gate is active)."

echo "==> 2/4  Removing the open artifact copies from the root site ..."
for f in architect-language-tools.vsix architect-language-tools.zip; do
  if git ls-files --error-unmatch "$f" >/dev/null 2>&1; then
    git rm --quiet "$f"
    echo "    removed $f"
  else
    echo "    $f already gone — skipping"
  fi
done

echo "==> 3/4  Repointing /downloads/ at the gated subdomain ..."
cat > _pages/downloads.md <<'MD'
---
layout: page
title: Downloads
permalink: /downloads/
desc: Download files hosted on this site
adverts: disable
---

<div class="container" markdown="1">

### Available Downloads

The Architect Language Tools downloads have moved to a password-protected page:

- **[Architect Language Tools — Downloads](https://downloads.jackbarker.com.au/)**

Access requires a password — please get in touch if you need it.

</div>
MD
git add _pages/downloads.md

echo "==> 4/4  Committing ..."
if git diff --cached --quiet; then
  echo "    nothing staged — already cut over. Done."
  exit 0
fi
git commit -m "Move downloads behind password gate (downloads.jackbarker.com.au)" \
           -m "Remove the open .vsix/.zip copies from the root site and repoint /downloads/ at the gated subdomain."

if [ "$PUSH" = "1" ]; then
  echo "==> Pushing gh-pages ..."
  git push origin gh-pages
  echo "    pushed. The old root-site URLs will 404 after the Pages rebuild."
else
  echo
  echo "Committed but NOT pushed. When ready to publish, run:"
  echo "    git -C \"$REPO\" push origin gh-pages"
fi
