#!/bin/sh
# For production.

set -e

echo 'Entry Point'

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
