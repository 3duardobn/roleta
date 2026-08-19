# Roleta

Um aplicativo Flutter (Android) para sortear palavras. Crie "roletas" (caixas) com nome e uma lista de palavras, edite quando quiser e sorteie uma palavra aleatória — pelo botão ou agitando o celular.

## Funcionalidades

- **Múltiplas roletas**: crie quantas quiser, cada uma com nome e lista própria de palavras.
- **Persistência local**: tudo fica salvo no dispositivo (`shared_preferences`), sem necessidade de conta ou internet.
- **Editar e excluir**: adicione/remova palavras e renomeie a roleta a qualquer momento, com confirmação antes de excluir.
- **Sorteio com efeito de flash**: as palavras alternam rapidamente (acelerando e desacelerando, ~2,3 s) até parar na palavra sorteada.
- **Botão ou gesto**: sortei pelo botão **Sortear** ou agitando o celular (acelerômetro via `sensors_plus`).
- **Tema claro/escuro**: opções Sistema / Claro / Escuro, preferência salva.
- **Idiomas**: português, inglês e espanhol, ou padrão do sistema, escolhido na tela de Configurações.
- **Estatísticas por roleta**: veja quantas vezes cada palavra foi sorteada, na ordem das mais sorteadas.
- **Opções de sorteio**: evite repetir a última palavra sorteada e/ou remova cada palavra sorteada da roleta (sorteio que vai diminuindo, recomeçando ao acabar).
- **Backup em JSON**: exporte suas roletas (compartilhando ou salvando um arquivo `.json`) e restaure-as quando quiser.
- **Sem anúncios, sem rastreamento, sem coleta de dados**: os dados ficam só no dispositivo.

## Requisitos

- Flutter SDK (testado com Flutter 3.41+ / Dart 3.11+)
- Android SDK com licenças aceitas

## Como rodar

```sh
flutter pub get
flutter run
```

Para gerar o APK:

```sh
flutter build apk --debug   # debug
flutter build apk --release # release (assinado com debug key)
```

## Testes

```sh
flutter test
```

Cobre o modelo `Caixa`, o repositório de persistência, o serviço de sorteio e as telas principais (widget tests).

## Estrutura

```
lib/
  main.dart                      # entrada do app + tema
  theme.dart                     # temas claro/escuro
  models/caixa.dart              # modelo de dados
  data/
    caixa_repository.dart        # persistência (shared_preferences)
    settings_repository.dart     # preferências (tema)
  screens/
    home_screen.dart             # lista de roletas
    caixa_form_screen.dart       # criar/editar roleta
    roleta_screen.dart           # tela de sorteio
    settings_screen.dart         # configurações (idioma, licença, contato)
  services/
    sorteio_service.dart         # lógica de sorteio (testável)
    shake_detector.dart          # detecção de "agitar" (sensors_plus)
  l10n/                          # localizações (app_en/app_pt/app_es.arb)
test/                            # testes unitários e de widget
fdroid/                          # metadado para publicação no F-Droid
fastlane/                        # descrições, changelogs e ícone da loja
```

## Publicação no F-Droid

O metadado de build vive em [`fdroid/dev.edbn.roleta.yml`](fdroid/dev.edbn.roleta.yml) — copie-o para o repositório [`fdroiddata`](https://gitlab.com/fdroid/fdroiddata) (em `metadata/`) e abra um Merge Request. Depois de aceito, novas tags `v*` são publicadas automaticamente.

- Versões são definidas em `pubspec.yaml` (`version: 1.0.0+1`) e builds usam tags `v1.0.0`, `v1.0.1`, ...
- Descrições, changelogs e ícone da loja ficam em [`fastlane/metadata/android/`](fastlane/metadata/android) (pt-BR, en-US e es).
- O build usa apenas o SDK do Flutter (app 100% Dart) — ver seção `Builds` do metadado.

## Créditos

Este app foi **vibe-coded** com a ajuda do [OpenCode](https://opencode.ai) e do modelo **deepseek-v4-flash**.

## Licença

O **código** deste projeto é licenciado sob a **GNU General Public License v3.0** — veja o arquivo [LICENSE](LICENSE).

### Artes (ícones)

As **artes** em [`assets/icons/`](assets/icons) foram dedicadas ao **domínio público** sob a [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) — veja o arquivo [`assets/LICENSE-CC0.txt`](assets/LICENSE-CC0.txt). Você pode usar, modificar e redistribuir as artes livremente, sem pedir permissão e sem atribuição.