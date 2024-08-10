enum AddressType { home, work }

class AddressModel {
  final int id;
  final AddressType type;
  final String latitude;
  final String longitude;
  final String address;
  final String phoneNumber;
  late bool isDefault;

  AddressModel({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phoneNumber,
    required this.isDefault,
  });

  @override
  bool operator ==(Object other) => other is AddressModel && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    AddressType type = AddressType.home;
    if (json['type'] != null) {
      type = AddressType.values[int.parse(json['type'].toString()) - 1];
    }
    return AddressModel(
      id: json['id'] ?? 0,
      type: type,
      latitude: json['lat'],
      longitude: json['lang'],
      address: json['address'],
      phoneNumber: json['phoneNumber'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'lat': latitude,
      'lang': longitude,
      'address': address,
      'phoneNumber': phoneNumber,
      'isDefault': isDefault,
    };
  }
}
