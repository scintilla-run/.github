set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# The org-control Codespace is a pilot consumer of the shared edge lifecycle.
# `up` may materialize the exact reviewed shared implementation; it never runs
# a moving branch. Bootstrap credentials are scoped only to private network/tool
# operations and are not exported into the long-running supervisors.
codespace-edge-up:
    root="${ORES_CODESPACE_CLUSTER_DIR:-$HOME/.cache/ores/codespaces-cluster}"; rev="$(tr -d '[:space:]' < config/codespaces-cluster.rev)"; token="${ORES_CLI_READ_TOKEN:-}"; [[ "$rev" =~ ^[0-9a-f]{40}$ ]] || { echo >&2 "invalid config/codespaces-cluster.rev"; exit 2; }; require_private_read() { test -n "$token" || { echo >&2 "ORES_CLI_READ_TOKEN is required for private ORESoftware bootstrap access"; exit 78; }; }; mkdir -p "$(dirname "$root")"; if [[ ! -d "$root/.git" ]]; then command -v gh >/dev/null; require_private_read; GH_TOKEN="$token" gh repo clone ORESoftware/codespaces-cluster "$root"; fi; if ! git -C "$root" cat-file -e "$rev^{commit}" 2>/dev/null; then require_private_read; GH_TOKEN="$token" git -C "$root" fetch --prune origin main; fi; git -C "$root" cat-file -e "$rev^{commit}"; git -C "$root" checkout --detach -q "$rev"; test "$(git -C "$root" rev-parse HEAD)" = "$rev"; if ! command -v ores-compose >/dev/null 2>&1 || ! command -v oresc >/dev/null 2>&1; then require_private_read; (cd "$root" && GH_TOKEN="$token" just codespace-edge-bootstrap); else (cd "$root" && just codespace-edge-bootstrap); fi; cd "$root"; just codespace-edge-up

# Status/down deliberately do not fetch, switch branches, or otherwise mutate
# the shared checkout while it may own running processes.
codespace-edge-status:
    root="${ORES_CODESPACE_CLUSTER_DIR:-$HOME/.cache/ores/codespaces-cluster}"; test -f "$root/Justfile" || { echo >&2 "codespaces-cluster checkout is missing; run just codespace-edge-up first"; exit 2; }; cd "$root"; just codespace-edge-status

codespace-edge-down:
    root="${ORES_CODESPACE_CLUSTER_DIR:-$HOME/.cache/ores/codespaces-cluster}"; test -f "$root/Justfile" || { echo >&2 "codespaces-cluster checkout is missing; edge is already locally stopped"; exit 0; }; cd "$root"; just codespace-edge-down

codespace-edge-check:
    command -v just >/dev/null
    command -v gh >/dev/null
    command -v cargo >/dev/null
    command -v cloudflared >/dev/null || { echo >&2 "cloudflared is required"; exit 127; }
    rev="$(tr -d '[:space:]' < config/codespaces-cluster.rev)"; [[ "$rev" =~ ^[0-9a-f]{40}$ ]] || { echo >&2 "invalid config/codespaces-cluster.rev"; exit 2; }
    @echo "Codespace edge wrapper prerequisites are ready"
