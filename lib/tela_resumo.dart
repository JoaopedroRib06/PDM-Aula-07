import 'package:flutter/material.dart';

/// Tela de Resumo do Pedido (StatelessWidget)
/// Exibe as informações imutáveis recebidas via construtor a partir da TelaContador.
class TelaResumo extends StatelessWidget {
  final String item;
  final int quantidade;
  final double precoUnitario; // Desafio Nível 2: Preço unitário do item

  const TelaResumo({
    super.key,
    required this.item,
    required this.quantidade,
    this.precoUnitario = 150.00,
  });

  /// Desafio Nível 2: Cálculo automático do valor total
  double get precoTotal => quantidade * precoUnitario;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo do Pedido'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícone de confirmação conforme roteiro
                      const Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),

                      // Nome do Item
                      Text(
                        'Item: $item',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Quantidade Selecionada
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Quantidade Selecionada: $quantidade',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Desafio Nível 2: Preço Unitário e Valor Total
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Preço unitário: ${_formatarMoeda(precoUnitario)}',
                              style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Valor Total: ${_formatarMoeda(precoTotal)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Desafio Nível 3: Botão de Confirmação com retorno true via Navigator.pop(context, true)
                      FilledButton.icon(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Confirmar Pedido'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Botão padrão do roteiro: Voltar e Alterar via Navigator.pop(context)
                      ElevatedButton.icon(
                        onPressed: () {
                          // Desempilha a tela atual e retorna à anterior
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Voltar e Alterar'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
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
