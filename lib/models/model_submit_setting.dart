import 'package:supermarket/models/model.dart';
import 'model_feature.dart';

class SubmitSettingModel {
  final List<CountryModel> countries; //
  final List<CurrencyModel> currencies; //
  final List<UnitModel> units; //
  // final List<PropertyModel> properties; //
  // final List<GroupModel> groups; //
  final List<CategoryModel> categories; //
  final List<FeatureModel> features; //
  final List<LocationModel> locations; //

  SubmitSettingModel({
    required this.countries,
    required this.currencies,
    required this.units,
    // required this.properties,
    // required this.groups,
    required this.categories,
    required this.features,
    required this.locations,
  });

  factory SubmitSettingModel.fromDefault() {
    return SubmitSettingModel(
      countries: [],
      currencies: [],
      units: [],
      // properties: [],
      // groups: [],
      categories: [],
      features: [],
      locations: [],
    );
  }

  factory SubmitSettingModel.fromJson(Map<String, dynamic> json) {
    return SubmitSettingModel(
      countries:
          List.from(json['countries'] ?? json['Countries'] ?? []).map((e) {
        return CountryModel.fromJson(e);
      }).toList(),
      currencies:
          List.from(json['currencies'] ?? json['Currencies'] ?? []).map((e) {
        return CurrencyModel.fromJson(e);
      }).toList(),
      units: List.from(json['units'] ?? json['Units'] ?? []).map((e) {
        return UnitModel.fromJson(e);
      }).toList(),
      // properties: List.from(json['properties'] ?? []).map((e) {
      //   return PropertyModel.fromJson(e);
      // }).toList(),
      // groups: List.from(json['groups'] ?? []).map((e) {
      //   return GroupModel.fromJson(e);
      // }).toList(),
      categories:
          List.from(json['categories'] ?? json['Categories'] ?? []).map((e) {
        return CategoryModel.fromJson(e);
      }).toList(),
      features: List.from(json['features'] ?? json['Features'] ?? []).map((e) {
        return FeatureModel.fromJson(e);
      }).toList(),
      locations:
          List.from(json['locations'] ?? json['Locations'] ?? []).map((e) {
        return LocationModel.fromJson(e);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countries': countries.map((e) => e.toJson()).toList(),
      'currencies': currencies.map((e) => e.toJson()).toList(),
      'units': units.map((e) => e.toJson()).toList(),
      // 'properties': properties.map((e) => e.toJson()).toList(),
      // 'groups': groups.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'features': features.map((e) => e.toJson()).toList(),
      'locations': locations.map((e) => e.toJson()).toList(),
    };
  }
}
