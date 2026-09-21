import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_catalogo_mobile/main.dart';

void main() {
  testWidgets('Valida renderização e fluxo do catálogo com Material 3', (WidgetTester tester) async {
    await tester.pumpWidget(const CatalogoApp());

    // 1. Verifica presença do título e elementos iniciais
    expect(find.text('Catálogo de Produtos'), findsOneWidget);
    expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
    expect(find.text('R\$ 4.599,90'), findsOneWidget);
    expect(find.text('Disponível'), findsOneWidget);

    // 2. Verifica renderização das tags em Chips
    expect(find.text('android'), findsOneWidget);
    expect(find.text('5g'), findsOneWidget);
    expect(find.text('snapdragon'), findsOneWidget);

    // 3. Verifica feedback de estoque normal (inicial = 12)
    expect(find.textContaining('Estoque regular: 12'), findsOneWidget);
    expect(find.text('Aviso de Estoque Crítico'), findsNothing);

    // 4. Clica no FAB 8 vezes para reduzir estoque de 12 para 4 (< 5, estoque crítico)
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    for (int i = 0; i < 8; i++) {
      await tester.tap(fab);
      await tester.pump();
    }

    // 5. Verifica feedback visual dinâmico de estoque crítico acionado
    expect(find.text('Aviso de Estoque Crítico'), findsOneWidget);
    expect(find.textContaining('Restam apenas 4 unidade(s)'), findsOneWidget);

    // 6. Testa restauração dos dados originais pelo botão de recarregar na AppBar
    final reloadBtn = find.byTooltip('Restaurar Dados do JSON');
    expect(reloadBtn, findsOneWidget);
    await tester.tap(reloadBtn);
    await tester.pump();

    // 7. Confirma que retornou ao estado original com estoque = 12
    expect(find.textContaining('Estoque regular: 12'), findsOneWidget);
    expect(find.text('Aviso de Estoque Crítico'), findsNothing);
  });
}
