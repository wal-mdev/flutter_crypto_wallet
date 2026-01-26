class CoinDetailModel {
  final String id;
  final String symbol;
  final String name;
  final String description;
  final String homepage;
  final String? github;
  final String? whitepaper;

  CoinDetailModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.description,
    required this.homepage,
    this.github,
    this.whitepaper,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    final langDesc = json['description'] as Map<String, dynamic>? ?? {};
    final description =
        langDesc['en'] as String? ?? langDesc['pt'] as String? ?? '';

    final links = json['links'] as Map<String, dynamic>? ?? {};
    final homepageList = links['homepage'] as List? ?? [];
    final homepage =
        (homepageList.isNotEmpty ? homepageList.first : '') as String;

    final whitepaper = links['whitepaper'] as String?;

    final repos = links['repos_url'] as Map<String, dynamic>? ?? {};
    final githubList = repos['github'] as List? ?? [];
    final github = (githubList.isNotEmpty ? githubList.first : null) as String?;

    return CoinDetailModel(
      id: json['id'] as String,
      symbol: (json['symbol'] as String).toUpperCase(),
      name: json['name'] as String,
      description: description,
      homepage: homepage,
      github: github,
      whitepaper: whitepaper,
    );
  }
}
