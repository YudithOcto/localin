import 'package:equatable/equatable.dart';

class TransactionDiscountResponseModel with EquatableMixin {
  bool isError;
  String message;
  PriceData priceData;

  TransactionDiscountResponseModel(
      {this.isError, this.message, this.priceData});

  factory TransactionDiscountResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionDiscountResponseModel(
        isError: false,
        message: json['message'],
        priceData:
            json['data'] == null ? null : PriceData.fromJson(json['data']));
  }

  TransactionDiscountResponseModel.jsonError(String value)
      : isError = true,
        message = value,
        priceData = null;

  @override
  List<Object> get props => [isError, message, priceData];
}

class PriceData with EquatableMixin {
  int basePrice;
  int baseTax;
  int baseService;
  int couponDiscount;
  int pointDiscount;
  int price;
  int userPrice;

  PriceData(
      {this.basePrice,
      this.baseService,
      this.baseTax,
      this.couponDiscount,
      this.price,
      this.pointDiscount,
      this.userPrice});

  factory PriceData.fromJson(Map<String, dynamic> json) => PriceData(
        basePrice: json['dasar_harga'] ?? 0,
        baseTax: json['dasar_ppn'] ?? 0,
        baseService: json['dasar_service'] ?? 0,
        couponDiscount: json['diskon_kupon'] ?? 0,
        pointDiscount: json['diskon_poin'] ?? 0,
        price: json['harga'] ?? 0,
        userPrice: json['harga_user'] ?? 0,
      );

  @override
  List<Object> get props => [
        baseTax,
        baseTax,
        basePrice,
        couponDiscount,
        pointDiscount,
        price,
        userPrice
      ];
}
