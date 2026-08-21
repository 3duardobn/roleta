# AGENTS.md — Roleta

App Flutter Android "Roleta" (`dev.edbn.roleta`).

## Build

- `./build.sh` — build completo: pub get, analyze, test, APK e AAB (release).
- Flutter SDK: `/home/eduardo/projetos/bin/flutter/flutter/bin`; Java 17
  (`/usr/lib/jvm/java-17-openjdk-amd64`); `ANDROID_HOME=/home/eduardo/Android/Sdk`.

## Assinatura (local e CI)

- A keystore NÃO vive neste repo — fica centralizada em
  `~/projetos/personal/keystores/roleta.jks` (alias `roleta`), compartilhada
  com os outros apps do dev (LifeCalendar, libras_dicionario). Ver
  `~/projetos/personal/keystores/README.md`.
- Local: `build.sh` importa `signing.env` e exporta `KEYSTORE_PATH`,
  `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`; sem elas o Gradle usa a
  debug key.
- CI: `.github/workflows/build.yml` dispara em tags `v*` ou manual, assina com
  os secrets `KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`,
  `KEY_PASSWORD` (já configurados no repo com ESTA keystore) e publica release
  no GitHub com APK + AAB.
- Backup criptografado das chaves em `~/Backups`/`~/Koofr` (`*.age`, senha no
  Bitwarden). Perder jks/senha = impossível atualizar o app publicado.

## Releases

- Bump de versão no `pubspec.yaml` → commit → `git tag vX.Y.Z && git push origin vX.Y.Z`.
- Nunca reaproveite artefatos antigos; o Play rejeita assinatura de debug.

## Convenções

- Sem comentários no código (a menos que pedido).
- Arquitetura por camadas: `core/`, `domain/`, `data/`, `presentation/`.
