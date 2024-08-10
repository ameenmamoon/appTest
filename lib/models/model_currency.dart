class CurrencyModel {
  final int id;
  final String code;
  final String payCode;
  final String name;
  final bool isDefault;
  final double exchange;
  final double minExchange;
  final double maxExchange;
  final String? icon = null;
  final List<int> countries;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.payCode,
    required this.name,
    required this.isDefault,
    required this.exchange,
    required this.minExchange,
    required this.maxExchange,
    required this.countries,
  });

  @override
  bool operator ==(Object other) => other is CurrencyModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] ?? json['Id'] ?? 0,
      code: json['code'] ?? json['Code'] ?? '',
      payCode: json['payCode'] ?? json['PayCode'] ?? '',
      name: json['name'] ?? json['Name'] ?? '',
      isDefault: json['isDefault'] ?? json['IsDefault'] ?? false,
      exchange: double.tryParse(json['exchange']?.toString() ??
              json['Exchange']?.toString() ??
              '') ??
          0.0,
      minExchange: double.tryParse(json['minExchange']?.toString() ??
              json['MinExchange']?.toString() ??
              '') ??
          0,
      maxExchange: double.tryParse(json['maxExchange']?.toString() ??
              json['MaxExchange']?.toString() ??
              '') ??
          0,
      countries: List.from(json['countries'] ?? json['Countries'] ?? [])
          .map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'payCode': payCode,
      'name': name,
      'isDefault': isDefault,
      'exchange': exchange,
      'minExchange': minExchange,
      'maxExchange': maxExchange,
      'countries': countries,
    };
  }
}
