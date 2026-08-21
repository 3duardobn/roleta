#!/usr/bin/env bash
set -euo pipefail

MODO="${1:-release}"
if [[ "$MODO" != "release" && "$MODO" != "debug" ]]; then
  echo "Uso: $0 [release|debug]" >&2
  echo "Padrão: release" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_PROPERTIES="$ROOT/android/local.properties"

FLUTTER="$(command -v flutter || true)"
if [[ -z "$FLUTTER" ]]; then
  FLUTTER_SDK="$(sed -n 's/^flutter\.sdk=//p' "$LOCAL_PROPERTIES" 2>/dev/null | tr -d '\r')"
  if [[ -n "$FLUTTER_SDK" && -x "$FLUTTER_SDK/bin/flutter" ]]; then
    FLUTTER="$FLUTTER_SDK/bin/flutter"
  fi
fi
if [[ -z "$FLUTTER" ]]; then
  echo "Erro: flutter não encontrado. Adicione ao PATH ou rode via android/local.properties." >&2
  exit 1
fi

ADB="$(command -v adb || true)"
if [[ -z "$ADB" ]]; then
  SDK_DIR="$(sed -n 's/^sdk\.dir=//p' "$LOCAL_PROPERTIES" 2>/dev/null | tr -d '\r')"
  for candidato in "${ANDROID_HOME:-}" "${ANDROID_SDK_ROOT:-}" "$SDK_DIR"; do
    if [[ -n "$candidato" && -x "$candidato/platform-tools/adb" ]]; then
      ADB="$candidato/platform-tools/adb"
      break
    fi
  done
fi
if [[ -z "$ADB" ]]; then
  echo "Erro: adb não encontrado. Instale as platform-tools ou defina ANDROID_HOME." >&2
  exit 1
fi

echo ">>> Build apk --$MODO"
"$FLUTTER" build apk --"$MODO"

APK="$ROOT/build/app/outputs/flutter-apk/app-$MODO.apk"
if [[ ! -f "$APK" ]]; then
  echo "Erro: APK não encontrado em $APK" >&2
  exit 1
fi

echo ">>> Dispositivos conectados:"
"$ADB" devices | sed -n '2,$p' | grep -w 'device' || {
  echo "Erro: nenhum dispositivo pronto (conecte o celular e confirme a depuração USB)." >&2
  exit 1
}

while read -r id _status; do
  [[ -z "$id" ]] && continue
  echo ">>> Instalando em $id ..."
  "$ADB" -s "$id" install -r "$APK"
  echo ">>> Instalado em $id"
done < <("$ADB" devices | sed -n '2,$p' | grep -w 'device')

echo ">>> Pronto! APK: $APK"