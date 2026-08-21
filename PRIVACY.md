# Política de Privacidade — Roleta

**Última atualização: 21 de agosto de 2026**

*URL canônica: https://edbn.dev/privacidade/roleta/*

O aplicativo **Roleta** (`dev.edbn.roleta`) é um app gratuito e de código aberto (GPL-3.0) para sortear palavras.

## Dados que coletamos

**Nenhum.** O aplicativo:

- Não exige cadastro nem conta de usuário.
- Não coleta, armazena nem transmite dados pessoais.
- Não contém anúncios, analytics, rastreadores ou SDKs de terceiros de coleta de dados.
- Funciona 100% offline — não possui conexão com a internet.

## Dados armazenados no dispositivo

O aplicativo salva localmente no seu aparelho, usando o mecanismo de
preferências do Android (`SharedPreferences`):

- **Suas roletas** — nomes e listas de palavras criadas por você;
- **Estatísticas de sorteio** — contagem de vezes que cada palavra foi sorteada;
- **Tema escolhido** (claro/escuro);
- **Idioma preferido**.

Esses dados ficam **exclusivamente no seu dispositivo**, não são transmitidos
para servidores, não são compartilhados com terceiros e podem ser apagados a
qualquer momento desinstalando o aplicativo ou limpando os dados dele nas
configurações do Android.

O backup em JSON é gerado localmente e exportado apenas quando **você** aciona
a exportação (compartilhando ou salvando um arquivo). Nada é enviado sem sua
ação explícita.

## Permissões

O aplicativo **não solicita nenhuma permissão** do Android. O sensor de
acelerômetro (usado para sortear agitando o celular) não exige permissão. A
permissão de Internet existe apenas em builds de desenvolvimento, nunca na
versão publicada.

## Crianças

O aplicativo não coleta dados de nenhum usuário, incluindo crianças.

## Alterações

Alterações nesta política serão publicadas nesta página.

## Contato

Dúvidas: abra uma issue em <https://github.com/3duardobn/roleta> ou escreva
para `eduardo@edbn.dev`.
