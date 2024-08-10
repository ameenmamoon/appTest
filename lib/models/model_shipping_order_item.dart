class ShippingOrderItemModel {
  final String? destinationAddress;
  final String? originAddress;
  final String? distanceText;
  final double? distanceValue;
  final String? durationText;
  final double? durationValue;

  ShippingOrderItemModel(
      {this.destinationAddress,
      this.originAddress,
      this.distanceText,
      this.distanceValue,
      this.durationText,
      this.durationValue});

  factory ShippingOrderItemModel.fromJson(Map<String, dynamic> json) {
    return ShippingOrderItemModel(
      destinationAddress: json['destinationAddress'] ?? '',
      originAddress: json['originAddress'] ?? '',
      distanceText: json['distanceText'] ?? '',
      distanceValue: double.parse(json['distanceValue']?.toString() ?? '0'),
      durationText: json['durationText'] ?? '',
      durationValue: double.parse(json['durationValue']?.toString() ?? '0'),
    );
  }
}
