import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_catalogo_mobile/main.dart';
import 'package:app_catalogo_mobile/tela_resumo.dart';

void main() {
  group('Testes da Aula 07 - Gerenciamento de Estado e Navegação Multitela', () {
    testWidgets('Fluxo completo: incremento, decremento, zerar contador e confirmação', (WidgetTester tester) async {
      await tester.pumpWidget(const MeuApp());

      // 1. Verifica renderização inicial da TelaContador
      expect(find.text('Seleção de Itens'), findsOneWidget);
      expect(find.text('Smartphone Galaxy S24'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      // 2. Incrementa quantidade (+) duas vezes (de 1 para 3)
      final btnAdd = find.byIcon(Icons.add);
      await tester.tap(btnAdd);
      await tester.pumpAndSettle();
      await tester.tap(btnAdd);
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      // 3. Decrementa quantidade (-) uma vez (de 3 para 2)
      final btnRemove = find.byIcon(Icons.remove);
      await tester.tap(btnRemove);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // 4. Testa Desafio Nível 1: Botão 'Zerar Contador'
      final btnZerar = find.text('Zerar Contador');
      expect(btnZerar, findsOneWidget);
      await tester.tap(btnZerar);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // 5. Incrementa para 3 e avança para a TelaResumo
      await tester.tap(btnAdd);
      await tester.pumpAndSettle();
      await tester.tap(btnAdd);
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      final btnAvancar = find.text('Avançar para Resumo');
      expect(btnAvancar, findsOneWidget);
      await tester.tap(btnAvancar);
      await tester.pumpAndSettle();

      // 6. Verifica exibição dos dados na TelaResumo (Nível 2: valor total calculado)
      expect(find.text('Resumo do Pedido'), findsOneWidget);
      expect(find.text('Item: Smartphone Galaxy S24'), findsOneWidget);
      expect(find.text('Quantidade Selecionada: 3'), findsOneWidget);
      expect(find.textContaining('Valor Total: R\$ 450,00'), findsOneWidget);

      // 7. Testa Desafio Nível 3: Confirmação do pedido e retorno com SnackBar
      final btnConfirmar = find.text('Confirmar Pedido');
      expect(btnConfirmar, findsOneWidget);
      await tester.ensureVisible(btnConfirmar);
      await tester.tap(btnConfirmar);
      await tester.pumpAndSettle();

      // De volta à TelaContador, deve exibir o SnackBar de sucesso
      expect(find.text('Pedido Confirmado com Sucesso!'), findsOneWidget);
    });

    testWidgets('Navegação: botão Voltar e Alterar deve retornar sem disparar confirmação', (WidgetTester tester) async {
      await tester.pumpWidget(const MeuApp());

      // Avança para o resumo
      await tester.tap(find.text('Avançar para Resumo'));
      await tester.pumpAndSettle();
      expect(find.byType(TelaResumo), findsOneWidget);

      // Clica em 'Voltar e Alterar'
      final btnVoltar = find.text('Voltar e Alterar');
      await tester.ensureVisible(btnVoltar);
      await tester.tap(btnVoltar);
      await tester.pumpAndSettle();

      // Retorna à TelaContador sem disparar o SnackBar de confirmação
      expect(find.byType(TelaContador), findsOneWidget);
      expect(find.text('Pedido Confirmado com Sucesso!'), findsNothing);
    });
  });
}
