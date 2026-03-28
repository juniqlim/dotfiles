#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

"$ROOT_DIR/tests/unit/setup-launchd_test.sh"
"$ROOT_DIR/tests/unit/run-once-per-day_test.sh"
"$ROOT_DIR/tests/integration/setup-launchd_integration.sh"
