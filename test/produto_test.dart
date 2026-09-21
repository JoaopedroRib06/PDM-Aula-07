import 'package:flutter_test/flutter_test.dart';
import 'package:app_catalogo_mobile/models/produto.dart';

void main() {
  group('Testes do Modelo Produto (Dart OO e Regras de Negócio)', () {
    const sampleJson = {
      "nome_produto": "Smartphone Galaxy S24",
      "categoria": "Mobile",
      "preco": 4599.90,
      "quantidade_estoque": 12,
      "disponivel": true,
      "tags": ["android", "5g", "snapdragon"]
    };

    test('Deve desserializar corretamente via factory Produto.fromJson', () {
      final produto = Produto.fromJson(sampleJson);

      expect(produto.nomeProduto, equals('Smartphone Galaxy S24'));
      expect(produto.categoria, equals('Mobile'));
      expect(produto.preco, equals(4599.90));
      expect(produto.quantidadeEstoque, equals(12));
      expect(produto.disponivel, isTrue);
      expect(produto.tags, equals(['android', '5g', 'snapdragon']));
      expect(produto.temEstoqueCritico, isFalse);
    });

    test('Regra de negócio: temEstoqueCritico deve retornar true quando estoque < 5', () {
      final produtoCritico = Produto.fromJson({
        ...sampleJson,
        "quantidade_estoque": 4,
      });

      expect(produtoCritico.quantidadeEstoque, equals(4));
      expect(produtoCritico.temEstoqueCritico, isTrue);

      final produtoNoLimite = produtoCritico.copyWith(quantidadeEstoque: 5);
      expect(produtoNoLimite.temEstoqueCritico, isFalse);

      final produtoZero = produtoCritico.copyWith(quantidadeEstoque: 0);
      expect(produtoZero.temEstoqueCritico, isTrue);
    });

    test('Conversão numérica segura: deve aceitar inteiros como double para preco', () {
      final jsonComPrecoInteiro = {
        ...sampleJson,
        "preco": 4500,
        "quantidade_estoque": 2,
      };

      final produto = Produto.fromJson(jsonComPrecoInteiro);
      expect(produto.preco, equals(4500.0));
      expect(produto.temEstoqueCritico, isTrue);
    });

    test('Formatação monetária deve exibir em padrão BRL', () {
      final produto = Produto.fromJson(sampleJson);
      expect(produto.precoFormatado, equals('R\$ 4.599,90'));
    });
  });
}
