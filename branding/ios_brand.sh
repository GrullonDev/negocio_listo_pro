#!/bin/sh
# Pre-acción del esquema Runner (Xcode): lee BRAND de las --dart-define
# que Flutter pasa en DART_DEFINES (base64, separadas por comas) y escribe
# ios/Flutter/Brand.xcconfig con el nombre visible y el sufijo del bundle ID.
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONF="$ROOT/branding/brands.conf"
OUT="$ROOT/ios/Flutter/Brand.xcconfig"

decode() {
  printf '%s' "$1" | base64 --decode 2>/dev/null || printf '%s' "$1" | base64 -D 2>/dev/null || true
}

BRAND=default
OLD_IFS=$IFS
IFS=','
for entry in $DART_DEFINES; do
  kv=$(decode "$entry")
  case "$kv" in
    BRAND=*) BRAND=${kv#BRAND=} ;;
  esac
done
IFS=$OLD_IFS

LINE=$(grep -v '^#' "$CONF" | grep "^$BRAND|" || true)
if [ -z "$LINE" ]; then
  echo "error: marca desconocida BRAND=$BRAND (ver branding/brands.conf)" >&2
  exit 1
fi

NAME=$(printf '%s' "$LINE" | cut -d'|' -f2)
SUFFIX=$(printf '%s' "$LINE" | cut -d'|' -f3)

cat > "$OUT" <<XC
// Generado por branding/ios_brand.sh — no editar.
BRAND_KEY = $BRAND
BRAND_DISPLAY_NAME = $NAME
BRAND_BUNDLE_SUFFIX = $SUFFIX
XC
echo "Marca iOS: $BRAND ($NAME)"
