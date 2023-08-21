import 'dart:core';

class Promotion {
  var promotionID;
  var promotionName;
  var promotionCost;
  var promotionDescription;
  var moreDescription;
  var promotionPopularity;
  var promotionImage;
  var machineService;
  var promotionDuration;

  Promotion(
      {this.promotionID,
      this.promotionName,
      this.promotionCost,
      this.promotionDescription,
      this.moreDescription,
      this.promotionPopularity,
      this.machineService,
      this.promotionDuration,
      this.promotionImage});

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
        promotionID: json['promotionID'] ?? '',
        promotionName: json['promotionName'] ?? '',
        promotionImage: json['promotionImage'] ?? 'Blank',
        promotionDescription: json['promotionDescription'] ?? '',
        moreDescription: json['moreDescription'] ?? '',
        promotionCost: json['promotionCost'] ?? '',
        promotionDuration: json['promotionDuration'] ?? '',
        machineService: json['promotionService'] ?? '',
        promotionPopularity: json['promotionPopularity'] ?? '');
  }
}
