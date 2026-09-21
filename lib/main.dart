import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/produto.dart';

void main() {
  runApp(const CatalogoApp());
}

/// Aplicativo principal com configuração de Material Design 3 minimalista
class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FC),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          color: Colors.white,
        ),
      ),
      home: const CatalogoHomePage(),
    );
  }
}

class CatalogoHomePage extends StatefulWidget {
  const CatalogoHomePage({super.key});

  @override
  State<CatalogoHomePage> createState() => _CatalogoHomePageState();
}

class _CatalogoHomePageState extends State<CatalogoHomePage> {
  /// JSON simulado conforme especificação do roteiro prático
  static const String jsonSimulado = '''
{
  "nome_produto": "Smartphone Galaxy S24",
  "categoria": "Mobile",
  "preco": 4599.90,
  "quantidade_estoque": 12,
  "disponivel": true,
  "tags": ["android", "5g", "snapdragon"]
}
''';

  late Produto _produto;

  @override
  void initState() {
    super.initState();
    _carregarProdutoInicial();
  }

  /// Carrega o modelo de produto a partir do JSON utilizando a factory Produto.fromJson
  void _carregarProdutoInicial() {
    final Map<String, dynamic> mapaJson = jsonDecode(jsonSimulado);
    setState(() {
      _produto = Produto.fromJson(mapaJson);
    });
  }

  /// Recarrega os dados originais do JSON com feedback via SnackBar
  void _recarregarDados() {
    _carregarProdutoInicial();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados originais do JSON restaurados com sucesso!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Simula a saída de uma unidade de estoque (ação funcional do FAB)
  void _simularSaidaEstoque() {
    if (_produto.quantidadeEstoque <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Estoque esgotado para este produto.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      final novoEstoque = _produto.quantidadeEstoque - 1;
      _produto = _produto.copyWith(
        quantidadeEstoque: novoEstoque,
        disponivel: novoEstoque > 0,
      );
    });

    if (_produto.temEstoqueCritico) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Alerta: Estoque atingiu nível crítico (${_produto.quantidadeEstoque} restantes)!',
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Incrementa uma unidade de estoque para testes rápidos de UI
  void _adicionarUnidadeEstoque() {
    setState(() {
      final novoEstoque = _produto.quantidadeEstoque + 1;
      _produto = _produto.copyWith(
        quantidadeEstoque: novoEstoque,
        disponivel: true,
      );
    });
  }

  /// Modal com visualização do JSON original e da desserialização
  void _exibirModalJson() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estrutura JSON Simulado',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: SelectableText(
                  jsonSimulado.trim(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Desserializado via Produto.fromJson() em Dart OO com tipagem estrita e Null Safety.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code_outlined),
            tooltip: 'Visualizar JSON de Origem',
            onPressed: _exibirModalJson,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Restaurar Dados do JSON',
            onPressed: _recarregarDados,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeaderInfo(colorScheme),
                  const SizedBox(height: 16),
                  _buildProdutoCard(context),
                  const SizedBox(height: 16),
                  _buildAcoesRapidas(context),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _simularSaidaEstoque,
        icon: const Icon(Icons.shopping_cart_checkout_outlined),
        label: const Text('Simular Saída (-1)'),
        tooltip: 'Dar saída em 1 unidade de estoque',
      ),
    );
  }

  /// Cabeçalho informativo simples e minimalista
  Widget _buildHeaderInfo(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.devices_other_outlined, color: colorScheme.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Produto mapeado a partir de endpoint JSON simulado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Card ergonômico com grid de 8dp (padding: EdgeInsets.all(16.0))
  Widget _buildProdutoCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Grid padronizado de 8dp solicitado
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Linha superior: Categoria e Status de Disponibilidade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: const Icon(Icons.category_outlined, size: 14),
                  label: Text(_produto.categoria),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.white,
                  labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _produto.disponivel
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _produto.disponivel
                          ? const Color(0xFFC8E6C9)
                          : const Color(0xFFFFCDD2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _produto.disponivel
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        size: 14,
                        color: _produto.disponivel
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _produto.disponivel ? 'Disponível' : 'Indisponível',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _produto.disponivel
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nome do Produto
            Text(
              _produto.nomeProduto,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            // Preço Formatado
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  _produto.precoFormatado,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'à vista',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),

            // Feedback Visual Dinâmico: Alerta de estoque crítico ou indicador regular
            _buildFeedbackEstoque(context),
            const SizedBox(height: 16),

            // Seção de Tags em widgets Chip
            Text(
              'Tags / Recursos:',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _produto.tags.map((tag) {
                return Chip(
                  avatar: const Icon(Icons.tag, size: 14),
                  label: Text(tag),
                  side: BorderSide(color: Colors.grey.shade200),
                  backgroundColor: const Color(0xFFF8FAFC),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de Feedback Visual Dinâmico:
  /// Destaque de estoque crítico com ícone de alerta e cor vermelha suave caso quantidade < 5.
  Widget _buildFeedbackEstoque(BuildContext context) {
    final theme = Theme.of(context);

    if (_produto.temEstoqueCritico) {
      // Feedback dinâmico para Estoque Crítico (< 5 unidades)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE), // Vermelho suave (Red 50)
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFCDD2), width: 1), // Borda suave
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFC62828), // Ícone de alerta em tom vermelho
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aviso de Estoque Crítico',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB71C1C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Restam apenas ${_produto.quantidadeEstoque} unidade(s) em estoque. Reposição recomendada.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFC62828),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Exibição normal com estoque adequado (>= 5 unidades)
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: theme.colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Estoque regular: ${_produto.quantidadeEstoque} unidades disponíveis',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  /// Painel de ações rápidas e funcionais para testes interativos
  Widget _buildAcoesRapidas(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Ajuste rápido de estoque para teste:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          IconButton.outlined(
            tooltip: 'Diminuir estoque (-1)',
            icon: const Icon(Icons.remove, size: 18),
            onPressed: _produto.quantidadeEstoque > 0 ? _simularSaidaEstoque : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${_produto.quantidadeEstoque}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          IconButton.outlined(
            tooltip: 'Aumentar estoque (+1)',
            icon: const Icon(Icons.add, size: 18),
            onPressed: _adicionarUnidadeEstoque,
          ),
        ],
      ),
    );
  }
}
