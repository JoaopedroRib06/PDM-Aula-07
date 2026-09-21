/// Modelo de dados de Produto aplicando conceitos rigorosos de Dart OO,
/// imutabilidade, Null Safety e regras de negócio encapsuladas.
class Produto {
  final String nomeProduto;
  final String categoria;
  final double preco;
  final int quantidadeEstoque;
  final bool disponivel;
  final List<String> tags;

  /// Construtor com parâmetros nomeados obrigatórios (required)
  const Produto({
    required this.nomeProduto,
    required this.categoria,
    required this.preco,
    required this.quantidadeEstoque,
    required this.disponivel,
    required this.tags,
  });

  /// Regra de Negócio Encapsulada:
  /// Retorna true caso a quantidade em estoque seja inferior a 5 unidades.
  bool get temEstoqueCritico => quantidadeEstoque < 5;

  /// Desserialização segura a partir de Map/JSON com conversão robusta de tipos numéricos
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nomeProduto: json['nome_produto'] as String,
      categoria: json['categoria'] as String,
      preco: (json['preco'] as num).toDouble(),
      quantidadeEstoque: (json['quantidade_estoque'] as num).toInt(),
      disponivel: json['disponivel'] as bool,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? const []),
    );
  }

  /// Serialização para Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'nome_produto': nomeProduto,
      'categoria': categoria,
      'preco': preco,
      'quantidade_estoque': quantidadeEstoque,
      'disponivel': disponivel,
      'tags': tags,
    };
  }

  /// Método utilitário funcional para permitir imutabilidade com modificações parciais
  Produto copyWith({
    String? nomeProduto,
    String? categoria,
    double? preco,
    int? quantidadeEstoque,
    bool? disponivel,
    List<String>? tags,
  }) {
    return Produto(
      nomeProduto: nomeProduto ?? this.nomeProduto,
      categoria: categoria ?? this.categoria,
      preco: preco ?? this.preco,
      quantidadeEstoque: quantidadeEstoque ?? this.quantidadeEstoque,
      disponivel: disponivel ?? this.disponivel,
      tags: tags ?? this.tags,
    );
  }

  /// Getter auxiliar para formatação monetária padrão brasileiro
  String get precoFormatado {
    // Formata o número com 2 casas decimais e separador brasileiro
    final partes = preco.toStringAsFixed(2).split('.');
    final inteira = partes[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    final decimal = partes[1];
    return 'R\$ $inteira,$decimal';
  }
}
