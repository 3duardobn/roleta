# Roleta

Um aplicativo Flutter (Android) para sortear palavras. Crie "roletas" (caixas) com nome e uma lista de palavras, edite quando quiser e sorteie uma palavra aleatória — pelo botão ou agitando o celular.

## Funcionalidades

- **Múltiplas roletas**: crie quantas quiser, cada uma com nome e lista própria de palavras.
- **Persistência local**: tudo fica salvo no dispositivo (`shared_preferences`), sem necessidade de conta ou internet.
- **Editar e excluir**: adicione/remova palavras e renomeie a roleta a qualquer momento, com confirmação antes de excluir.
- **Sorteio com efeito de flash**: as palavras alternam rapidamente (acelerando e desacelerando, ~2,3 s) até parar na palavra sorteada.
- **Botão ou gesto**: sortei pelo botão **Sortear** ou agitando o celular (acelerômetro via `sensors_plus`).
- **Tema claro/escuro**: opções Sistema / Claro / Escuro, preferência salva.

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
  services/
    sorteio_service.dart         # lógica de sorteio (testável)
    shake_detector.dart          # detecção de "agitar" (sensors_plus)
test/                            # testes unitários e de widget
```

## Licença

Este projeto é licenciado sob a **GNU General Public License v3.0** — veja o arquivo [LICENSE](LICENSE).