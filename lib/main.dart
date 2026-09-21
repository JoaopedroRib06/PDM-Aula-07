import 'package:flutter/material.dart';
import 'tela_resumo.dart';

void main() {
  runApp(const MeuApp());
}

/// Ponto de entrada do aplicativo com configuração do Material Design 3
class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 7 - Navegação',
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
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          color: Colors.white,
        ),
      ),
      home: const TelaContador(),
    );
  }
}

/// Tela principal interativa de seleção de quantidade (StatefulWidget)
class TelaContador extends StatefulWidget {
  const TelaContador({super.key});

  @override
  State<TelaContador> createState() => _TelaContadorState();
}

class _TelaContadorState extends State<TelaContador> {
  int _quantidade = 1;
  final String _nomeProduto = 'Smartphone Galaxy S24';

  // Desafio Nível 2: Preço unitário do item
  final double _precoUnitario = 150.00;

  /// Incrementa a quantidade reativamente através de setState
  void _incrementar() {
    setState(() {
      _quantidade++;
    });
  }

  /// Decrementa a quantidade até o valor mínimo de 1 via setState
  void _decrementar() {
    if (_quantidade > 1) {
      setState(() {
        _quantidade--;
      });
    }
  }

  /// Desafio Nível 1: Redefine a quantidade para 1 invocando setState
  void _zerarContador() {
    setState(() {
      _quantidade = 1;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contador redefinido para 1 unidade.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Formatação monetária limpa no padrão brasileiro (BRL)
  String _formatarMoeda(double valor) {
    final partes = valor.toStringAsFixed(2).split('.');
    final inteira = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    final decimal = partes[1];
    return 'R\$ $inteira,$decimal';
  }

  /// Navega para a TelaResumo e trata a confirmação de retorno (Desafio Nível 3)
  Future<void> _avancarParaResumo() async {
    // Empilha a TelaResumo passando os dados do estado via construtor
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResumo(
          item: _nomeProduto,
          quantidade: _quantidade,
          precoUnitario: _precoUnitario,
        ),
      ),
    );

    // Desafio Nível 3: Exibir SnackBar se o pedido for confirmado com sucesso
    if (resultado == true && mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido Confirmado com Sucesso!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalEstimado = _quantidade * _precoUnitario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleção de Itens'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge decorativo minimalista de produto
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.smartphone_outlined, size: 16, color: colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Dispositivo Móvel',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nome do Produto
                      Text(
                        _nomeProduto,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Preço unitário e subtotal em tempo real (Nível 2)
                      Text(
                        'Unitário: ${_formatarMoeda(_precoUnitario)}  •  Subtotal: ${_formatarMoeda(totalEstimado)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Controles do Contador Reativo (-, Quantidade, +)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filledTonal(
                            tooltip: 'Diminuir quantidade',
                            onPressed: _quantidade > 1 ? _decrementar : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28.0),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) => ScaleTransition(
                                scale: animation,
                                child: child,
                              ),
                              child: Text(
                                '$_quantidade',
                                key: ValueKey<int>(_quantidade),
                                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            tooltip: 'Aumentar quantidade',
                            onPressed: _incrementar,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Desafio Nível 1: Botão 'Zerar Contador' (OutlinedButton)
                      OutlinedButton.icon(
                        onPressed: _quantidade > 1 ? _zerarContador : null,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Zerar Contador'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 42),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Botão principal: Avançar para Resumo
                      ElevatedButton.icon(
                        onPressed: _avancarParaResumo,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Avançar para Resumo'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
