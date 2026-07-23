#!/bin/sh
# regenerate ~/.ssh/allowed_signers from current pub keys for git commit signing
set -e

(
  for f in ~/.ssh/*.pub; do
    echo "$(git config --get user.email) namespaces=\"git\" $(cat "$f")"
  done
) > ~/.ssh/allowed_signers
