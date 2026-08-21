#!/usr/bin/env bash
set -euo pipefail

export PATH="/home/eduardo/projetos/bin/flutter/flutter/bin:$PATH"
export ANDROID_HOME="${ANDROID_HOME:-/home/eduardo/Android/Sdk}"
export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"

source "$HOME/projetos/personal/keystores/signing.env"
export KEYSTORE_PATH="$ROLETA_KEYSTORE"
export KEYSTORE_PASSWORD="$ROLETA_PASSWORD"
export KEY_ALIAS="$ROLETA_ALIAS"
export KEY_PASSWORD="$ROLETA_PASSWORD"

flutter config --jdk-dir="$JAVA_HOME" >/dev/null

echo "==> pub get"
flutter pub get

echo "==> analyze"
flutter analyze

echo "==> test"
flutter test

echo "==> build APK (release)"
flutter build apk --release

echo "==> build AAB (release)"
flutter build appbundle --release

echo ""
echo "APK: build/app/outputs/flutter-apk/app-release.apk"
echo "AAB: build/app/outputs/bundle/release/app-release.aab"
