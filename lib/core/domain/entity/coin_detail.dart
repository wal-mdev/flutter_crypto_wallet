import 'package:equatable/equatable.dart';

class CoinDetail extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String description;
  final String homepage;
  final String? github;
  final String? whitepaper;

  const CoinDetail({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.homepage,
    this.github,
    this.whitepaper,
  });

  @override
  List<Object?> get props => [
    id,
    symbol,
    name,
    description,
    homepage,
    github,
    whitepaper,
  ];
}
