import 'package:equatable/equatable.dart';
import 'package:localin/model/explore/explore_base_model.dart';
import 'package:localin/model/restaurant/restaurant_search_base_model.dart';

class RestaurantResponseModel with EquatableMixin implements BaseModel {
  RestaurantResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      total = json['data']['paging']['total'] ?? 0;
      restaurantLocation = json['data']['location'] == null
          ? []
          : List<RestaurantLocation>.from(json['data']['location']
              .map((e) => RestaurantLocation.fromJson(e)));
      detail = json['data']['data'] == null
          ? []
          : List<RestaurantDetail>.from(
              json['data']['data'].map((e) => RestaurantDetail.fromJson(e)));
    }
  }

  RestaurantResponseModel.fromSingleJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      total = 0;
      detail = json['data'] == null
          ? RestaurantDetail()
          : RestaurantDetail.fromJson(json['data']);
    }
  }

  RestaurantResponseModel.withError(String value) {
    error = true;
    message = value;
    total = 0;
  }

  @override
  var detail;

  @override
  bool error;

  @override
  String message;

  @override
  int total;

  dynamic restaurantLocation;

  @override
  List<Object> get props => [detail, error, message, total];
}

class RestaurantLocation extends RestaurantSearchBaseModel {
  String localityVerbose;
  int totalRestaurant;

  RestaurantLocation({this.localityVerbose, this.totalRestaurant});

  factory RestaurantLocation.fromJson(Map<String, dynamic> map) {
    return RestaurantLocation(
      localityVerbose: map['locality_verbose'],
      totalRestaurant: map['total'] == null ? 0 : map['total'],
    );
  }
}

class RestaurantDetail extends RestaurantSearchBaseModel {
  int id;
  String name;
  String address;
  String locality;
  String localityVerbose;
  String city;
  int cityId;
  int countryId;
  String latitude;
  String longitude;
  String zipCode;
  String phoneNumbers;
  int averageCostForTwo;
  int priceRange;
  String currency;
  String cuisines;
  String timings;
  String mezzoProvider;
  String userRating;
  String userRatingVotes;
  int hasOnlineDelivery;
  int isDeliveringNow;
  int delivery;
  int takeaway;
  String photosUrl;
  int photosCount;
  String createdAt;
  String updatedAt;
  String radius;
  String categoryName;
  List<RestaurantHighlight> higlights;
  bool isBookMark;

  RestaurantDetail({
    this.id,
    this.name,
    this.address,
    this.locality,
    this.localityVerbose,
    this.city,
    this.cityId,
    this.countryId,
    this.latitude,
    this.longitude,
    this.zipCode,
    this.phoneNumbers,
    this.averageCostForTwo,
    this.priceRange,
    this.currency,
    this.cuisines,
    this.timings,
    this.mezzoProvider,
    this.userRating,
    this.userRatingVotes,
    this.hasOnlineDelivery,
    this.isDeliveringNow,
    this.delivery,
    this.takeaway,
    this.photosUrl,
    this.photosCount,
    this.createdAt,
    this.updatedAt,
    this.radius,
    this.categoryName,
    this.higlights,
    this.isBookMark,
  });

  RestaurantDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    locality = json['locality'];
    localityVerbose = json['locality_verbose'];
    city = json['city'];
    cityId = json['city_id'];
    countryId = json['country_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zipCode = json['zipcode'];
    phoneNumbers = json['phone_numbers'];
    averageCostForTwo = json['average_cost_for_two'];
    priceRange = json['price_range'];
    currency = json['currency'];
    cuisines = json['cuisines'];
    timings = json['timings'];
    mezzoProvider = json['mezzo_provider'];
    userRating = json['user_rating'];
    userRatingVotes = json['user_rating_votes'];
    hasOnlineDelivery = json['has_online_delivery'];
    isDeliveringNow = json['is_delivering_now'];
    delivery = json['delivery'];
    takeaway = json['takeaway'];
    photosUrl = json['photos_url'];
    photosCount = json['photos_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    radius = json['radius'];
    categoryName = json['establis_name'];
    isBookMark = json['is_bookmark'] == null
        ? false
        : json['is_bookmark'] == 1 ? true : false;
    if (json['higlights'] != null) {
      higlights = new List<RestaurantHighlight>();
      json['higlights'].forEach((v) {
        higlights.add(new RestaurantHighlight.fromJson(v));
      });
    }
  }
}

class RestaurantHighlight with EquatableMixin {
  String loopId;
  String text;

  RestaurantHighlight({this.loopId, this.text});

  RestaurantHighlight.fromJson(Map<String, dynamic> json) {
    loopId = json['loop_id'];
    text = json['text'];
  }

  @override
  List<Object> get props => [loopId, text];
}
