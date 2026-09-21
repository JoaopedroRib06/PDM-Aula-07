# App Catálogo Mobile — Programação para Dispositivos Móveis I

Aplicativo desenvolvido em **Flutter** e **Dart**, com foco em **Orientação a Objetos**, **Material Design 3**, arquitetura limpa, design **minimalista e funcional**, e boas práticas de versionamento com **Git/GitHub**.

---

## 📱 Visão Geral da Solução

O projeto implementa a especificação completa da atividade prática **"Do JSON ao App com Versionamento"** (Aulas 1 a 4):
1. **Modelagem Dart OO Robusta**: Estrutura fortemente tipada, imutável e com Null Safety para o modelo `Produto`.
2. **Desserialização Segura (`fromJson`)**: Conversão segura de tipos numéricos (`num` -> `double` e `int`) a partir de dados JSON.
3. **Regra de Negócio Encapsulada**: Getter `temEstoqueCritico` que alerta automaticamente quando o estoque for menor que 5 unidades.
4. **Interface Material 3 Ergonômica e Minimalista**:
   - Tema baseado em `ColorScheme.fromSeed(seedColor: Colors.indigo)` e `useMaterial3: true`.
   - Grid padronizado de 8dp (`padding: EdgeInsets.all(16.0)`).
   - Card ergonômico com tipografia limpa, hierarquia visual moderna e tags em widgets `Chip`.
   - **Feedback Visual Dinâmico**: Destaque automático para estoque crítico em tom vermelho suave (`Colors.red.shade50`) com ícone de advertência (`Icons.warning_amber_rounded`).
   - **Recursos Funcionais**:
     - Botão de recarga na AppBar para restaurar o JSON original a qualquer instante.
     - Botão no AppBar para inspeção direta do código JSON de origem.
     - `FloatingActionButton` funcional para simular saídas de estoque (-1) e testar o feedback dinâmico.
     - Ajuste interativo rápido de estoque diretamente no painel.

---

## 🗂️ Estrutura do Projeto

```text
lib/
├── models/
│   └── produto.dart       # Classe Produto com tipagem estrita, getters e fromJson
└── main.dart              # Tela do catálogo em Material 3 minimalista e funcional

test/
├── produto_test.dart      # Testes unitários para regras de negócio e desserialização
└── widget_test.dart       # Teste de integração de widgets e feedback visual dinâmico

screenshots/               # Capturas de tela do app em funcionamento
```

---

## 📊 Estrutura de Dados (JSON Simulado)

```json
{
  "nome_produto": "Smartphone Galaxy S24",
  "categoria": "Mobile",
  "preco": 4599.90,
  "quantidade_estoque": 12,
  "disponivel": true,
  "tags": ["android", "5g", "snapdragon"]
}
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK 3.x instalado e configurado no PATH
- Dart SDK 3.x

### Passo a passo
1. Clone ou acesse a pasta do projeto:
   ```bash
   cd PDM-flutter
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Execute os testes unitários e de widget:
   ```bash
   flutter test
   ```

4. Execute o aplicativo:
   - **No navegador (Chrome/Edge)**:
     ```bash
     flutter run -d chrome
     ```
   - **No Windows Desktop**:
     ```bash
     flutter run -d windows
     ```
   - **No Smartphone/Emulador Android**:
     ```bash
     flutter run -d <device-id>
     ```

---

## 🌿 Histórico de Commits Semânticos

O versionamento segue estritamente o roteiro pedagógico da disciplina:
1. `feat: cria modelo de dados Produto com tipagem e getters`
2. `feat: implementa interface de catalogo com Scaffold e Cards Material 3`
3. `chore: adiciona configurações do projeto, testes e capturas de tela`
