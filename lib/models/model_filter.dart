import 'package:supermarket/configs/config.dart';
import 'package:supermarket/models/model.dart';

class FilterModel {
  String? searchString;
  List<int>? containsList;
  CategoryModel? category;
  BrandModel? brand;
  List<int>? features;
  List<int>? roomsFilter;
  // CountryModel? country;
  int? locationId;
  double? distance;
  CurrencyModel? currency;
  double? minPriceFilter;
  double? maxPriceFilter;
  // String? color;
  SortModel? sortOptions;
  // TimeOfDay? startHour;
  // TimeOfDay? endHour;
  List<ExtendedAttributeModel>? extendedAttributes = [];
  Map<String, dynamic>? byImage;

  FilterModel({
    this.searchString,
    this.containsList,
    this.category,
    this.brand,
    this.features,
    this.roomsFilter,
    this.locationId,
    this.distance,
    this.minPriceFilter,
    this.maxPriceFilter,
    this.currency,
    // this.color,
    this.sortOptions,
    // this.startHour,
    // this.endHour,
    this.extendedAttributes,
    this.byImage,
  });

  factory FilterModel.fromDefault() {
    return FilterModel(
      searchString: null,
      features: [],
      roomsFilter: [],
      sortOptions: null,
      extendedAttributes: [],
      byImage: {},
      // startHour: Application.setting.startHour,
      // endHour: Application.setting.endHour,
    );
  }

  factory FilterModel.fromSource(source) {
    return FilterModel(
      searchString: source.searchString,
      containsList: source.containsList,
      category: source.category,
      brand: source.brand,
      features: List<int>.from(source.features),
      roomsFilter: List<int>.from(source.roomsFilter),
      locationId: source.locationId,
      distance: source.distance,
      minPriceFilter: source.minPriceFilter,
      maxPriceFilter: source.maxPriceFilter,
      currency: source.currency,
      sortOptions: source.sortOptions,
      byImage: source.byImage,
    );
  }

  FilterModel clone() {
    return FilterModel.fromSource(this);
  }

  void clear() {
    searchString = null;
    containsList = null;
    category = null;
    brand = null;
    sortOptions = null;
    distance = null;
    minPriceFilter = null;
    maxPriceFilter = null;
    currency = null;
    extendedAttributes = null;
    byImage = null;
  }

  bool isEmpty() {
    if (searchString != null && searchString!.isNotEmpty) return false;
    if (containsList != null && containsList!.isNotEmpty) return false;
    if (category != null) return false;
    if (brand != null) return false;
    if (features != null && features!.isNotEmpty) return false;
    if (roomsFilter != null && roomsFilter!.isNotEmpty) return false;
    if (locationId != null) return false;
    if (distance != null) return false;
    if (minPriceFilter != null) return false;
    if (maxPriceFilter != null) return false;
    if (currency != null) return false;
    if (sortOptions != null) return false;
    if (extendedAttributes != null && extendedAttributes!.isNotEmpty)
      return false;
    if (byImage != null && byImage!.isNotEmpty) return false;
    return true;
  }
}
