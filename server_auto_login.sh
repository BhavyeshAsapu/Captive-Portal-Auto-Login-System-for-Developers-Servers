#!/usr/bin/env bash

set -u

CHECK_URL="${CHECK_URL:-http://clients3.google.com/generate_204}"
CAPTIVE_LOGIN_URL="${CAPTIVE_LOGIN_URL:-https://captiveportal.kluniversity.in:8090/httpclient.html}"
CAPTIVE_MATCH_DOMAIN="${CAPTIVE_MATCH_DOMAIN:-captiveportal.kluniversity.in}"
CAPTIVE_USER_FIELD="${CAPTIVE_USER_FIELD:-username}"
CAPTIVE_PASS_FIELD="${CAPTIVE_PASS_FIELD:-password}"
CHECK_INTERVAL="${CHECK_INTERVAL:-120}"
POST_LOGIN_WAIT="${POST_LOGIN_WAIT:-8}"
CURL_TIMEOUT="${CURL_TIMEOUT:-10}"
MAX_REDIRECTS="${MAX_REDIRECTS:-8}"
CAPTIVE_RUN_ONCE="${CAPTIVE_RUN_ONCE:-false}"

CAPTIVE_USERNAME="${CAPTIVE_USERNAME:-}"
CAPTIVE_PASSWORD="${CAPTIVE_PASSWORD:-}"

if [ -z "$CAPTIVE_USERNAME" ] || [ -z "$CAPTIVE_PASSWORD" ]; then
  cat <<'EOF'
Missing required credentials.

Export these variables before running:
  export CAPTIVE_USERNAME='your_username'
  export CAPTIVE_PASSWORD='your_password'

Optional variables:
  CAPTIVE_LOGIN_URL   (default: https://captiveportal.kluniversity.in:8090/httpclient.html)
  CAPTIVE_MATCH_DOMAIN (default: captiveportal.kluniversity.in)
  CAPTIVE_USER_FIELD  (default: username)
  CAPTIVE_PASS_FIELD  (default: password)
  CHECK_URL           (default: http://clients3.google.com/generate_204)
  CHECK_INTERVAL      (default: 120 seconds)
  POST_LOGIN_WAIT     (default: 8 seconds)
  MAX_REDIRECTS       (default: 8)
  CAPTIVE_RUN_ONCE    (true/false, default: false)
  CAPTIVE_INSECURE_TLS (true/false, default: false)
EOF
  exit 1
fi

case "$CHECK_URL" in
  http://*|https://*) ;;
  *)
    echo "Invalid CHECK_URL. Use only http:// or https:// URLs"
    exit 1
    ;;
esac

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1"
}

host_matches_domain() {
  local url_host url_domain match_domain
  url_host="${1#*://}"
  url_host="${url_host%%/*}"
  url_host="${url_host%%:*}"

  url_domain="$(echo "$url_host" | tr '[:upper:]' '[:lower:]')"
  match_domain="$(echo "$CAPTIVE_MATCH_DOMAIN" | tr '[:upper:]' '[:lower:]')"

  [ "$url_domain" = "$match_domain" ] && return 0
  case "$url_domain" in
    *."$match_domain") return 0 ;;
  esac
  return 1
}

is_authenticated() {
  local result status_code final_url
  result="$(curl -sS -L --max-redirs "$MAX_REDIRECTS" --proto '=http,https' --max-time "$CURL_TIMEOUT" -o /dev/null -w '%{http_code} %{url_effective}' "$CHECK_URL" 2>/dev/null || true)"
  [ -n "$result" ] || return 1

  status_code="${result%% *}"
  final_url="${result#* }"

  if [ "$status_code" = "204" ]; then
    return 0
  fi

  if [ -n "$CAPTIVE_MATCH_DOMAIN" ] && host_matches_domain "$final_url"; then
    return 1
  fi

  return 1
}

login_captive_portal() {
  local curl_args=(
    -sS
    -L
    --max-redirs "$MAX_REDIRECTS"
    --proto '=http,https'
    --max-time "$CURL_TIMEOUT"
    -X POST "$CAPTIVE_LOGIN_URL"
  )

  if [ "${CAPTIVE_INSECURE_TLS:-false}" = "true" ]; then
    curl_args+=(-k)
  fi

  curl "${curl_args[@]}" -K - -o /dev/null <<EOF || true
data-urlencode = "${CAPTIVE_USER_FIELD}=${CAPTIVE_USERNAME}"
data-urlencode = "${CAPTIVE_PASS_FIELD}=${CAPTIVE_PASSWORD}"
EOF
}

log "Starting captive portal auto-login monitor"

while true; do
  if is_authenticated; then
    log "Internet authenticated"
  else
    log "Captive portal login required. Submitting credentials..."
    login_captive_portal
    sleep "$POST_LOGIN_WAIT"
    if is_authenticated; then
      log "Authentication verified after login attempt"
    else
      log "Still unauthenticated. Will retry in next cycle"
    fi
  fi

  if [ "$CAPTIVE_RUN_ONCE" = "true" ]; then
    break
  fi

  sleep "$CHECK_INTERVAL"
done
