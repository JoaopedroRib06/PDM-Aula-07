# App de Checkout e Navegação no Flutter — Aula 07 (PDM I)

Projeto prático desenvolvido para a disciplina de **Programação para Dispositivos Móveis I** (Prof. Diego Menegassi) — Semestre 2026/2.

---

## 🎯 Objetivos de Aprendizagem

- **StatelessWidget vs StatefulWidget**: diferenciação na prática do ciclo de vida e renderização de componentes estáticos e reativos.
- **Gerenciamento de Estado Local (`setState`)**: manipulação reativa da interface a partir da interação do usuário.
- **Controle de Rotas (`Navigator`)**: empilhamento e desempilhamento de telas utilizando `Navigator.push` e `Navigator.pop`.
- **Comunicação entre Telas**: transferência de parâmetros/argumentos via construtor e retorno assíncrono de valores.
- **Versionamento Semântico no GitHub**: boas práticas de commits atômicos e organizados.

---

## 🏗️ Estrutura e Arquitetura do App

O projeto adota uma arquitetura limpa de arquivo duplo:

| Componente | Tipo de Widget | Papel na Aplicação | Comunicação |
| :--- | :--- | :--- | :--- |
| `TelaContador` (`lib/main.dart`) | `StatefulWidget` | Tela principal interativa de seleção de quantidade com controle reativo. | Chama `Navigator.push` enviando dados pelo construtor e recebe confirmação. |
| `TelaResumo` (`lib/tela_resumo.dart`) | `StatelessWidget` | Exibe a confirmação do pedido, detalhes do item e valor total calculado. | Chama `Navigator.pop(context)` para alterar ou `Navigator.pop(context, true)` para confirmar. |

---

## 🏆 Desafios Práticos de Laboratório Implementados

Todos os 3 níveis de desafio foram plenamente desenvolvidos com design minimalista em **Material Design 3**:

- ✅ **Nível 1 (Básico)**: Botão `Zerar Contador` (`OutlinedButton`) na `TelaContador` que redefine `_quantidade = 1` invocando `setState()`.
- ✅ **Nível 2 (Intermediário)**: Preço unitário configurado (`R$ 150,00`) com cálculo reativo do valor total (`_quantidade * precoUnitario`), exibido tanto na tela principal quanto na tela de resumo.
- ✅ **Nível 3 (Avançado)**: Retorno de confirmação via `Navigator.pop(context, true)` na `TelaResumo`, disparando um `SnackBar` na `TelaContador` com a mensagem `"Pedido Confirmado com Sucesso!"`.

---

## 🚀 Como Executar

1. Instale as dependências:
   ```bash
   flutter pub get
   ```

2. Execute os testes unitários e de widget:
   ```bash
   flutter test
   ```

3. Inicie o app no navegador Chrome:
   ```bash
   flutter run -d chrome
   ```

4. Ou no Windows Desktop:
   ```bash
   flutter run -d windows
   ```

---

## 🌿 Histórico de Commits Semânticos

1. `feat: cria TelaResumo stateless para exibicao do pedido`
2. `feat: implementa contador com setState e integracao com Navigator`
3. `chore: atualiza testes automatizados e documentacao da aula 07`
