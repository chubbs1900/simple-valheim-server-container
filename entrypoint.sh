#!/usr/bin/env bash
set -euo pipefail

# Write adminlist.txt if ADMIN_LIST provided (comma/space/newline separated)
if [[ -n "${ADMIN_LIST:-}" ]]; then
  echo "Writing adminlist.txt from ADMIN_LIST"
  echo -e "$(echo "$ADMIN_LIST" | tr ', ' '\n\n' | sed '/^\s*$/d')" > /server/adminlist.txt
fi

cd /server

# Launch server; extra flags via SERVER_ARGS (e.g., -crossplay, -saveinterval 600)
exec /server/valheim_server.x86_64 \
  -name     "${SERVER_NAME}" \
  -world    "${WORLD_NAME}" \
  -password "${SERVER_PASS}" \
  -port     "${SERVER_PORT}" \
  -public   "${SERVER_PUBLIC}" \
  ${SERVER_ARGS}
