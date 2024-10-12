import 'dart:convert';

import 'package:flutter/material.dart';

enum LoadingWidgetType { wave, sandTimer }

enum SimpleBottomTabsType {
  rawOrDefault,
  topSelection,
  bottomSelection,
  roundedIcon,
  roundedIconAndText,
}

class TopTabItem {
  final String tabTitle;
  final Icon? icon;
  final Widget widget;
  // TabItem({this.tabTitle = '', this.icon, @required this.widget});
  TopTabItem.forTopTabs({this.tabTitle = '', this.icon, required this.widget});
}

class BottomTabItem {
  final String tabTitle;
  final Icon icon;
  final Widget widget;
  BottomTabItem({this.tabTitle = '', required this.icon, required this.widget});
}

class AlertDialogContent {
  final String text;
  final Function(BuildContext otherContext) action;

  AlertDialogContent(this.text, this.action);
}

class DrawerContent {
  final IconData? iconData;
  final String text;
  final Function()? onTapHandler;

  DrawerContent.forAll(
      {required this.iconData, required this.text, required this.onTapHandler});
  DrawerContent.withTextOnly(
      {this.iconData, required this.text, this.onTapHandler});
}

// this is kept to show how to get list directly using parseToGetList
class ModelSample {
  final String name;
  final String description;
  final int price;
  final String image;
  int rating;

  ModelSample(this.name, this.description, this.price, this.image, this.rating);

  factory ModelSample.fromMapOrJson(Map<String, dynamic> json) {
    return ModelSample(
      json['name'],
      json['description'],
      json['price'],
      json['image'],
      json['rating'],
    );
  }

  @override
  String toString() {
    return 'Product{name: $name, description: $description, price: $price, image: $image, rating: $rating}';
  }

  /* static fromMapOrJson(Map<String, dynamic> json) {
    return Product(
      json['name'],
      json['description'],
      json['price'],
      json['image'],
      json['rating'],
    );
  }*/

  static List<ModelSample> parseToGetList(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    //return parsed.map<Contact>((json) => Contact.fromMap(json)).toList();
    return responseBody
        //  .map<ModelSample>((json) => ModelSample.fromMap(json))
        .map<ModelSample>((json) => ModelSample.fromMapOrJson(json))
        .toList();
  }
}

class BaseResponse {
  BaseResponse(
      {this.isSuccess = false,
      this.success = false,
      this.message,
      this.data,
      this.total});

  final bool isSuccess;
  final bool success;
  final String? message;
  dynamic data;
  final int? total;

  factory BaseResponse.fromJson(String str) =>
      BaseResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BaseResponse.fromMap(Map<String, dynamic> json) => BaseResponse(
        isSuccess: json["isSuccess"] ?? false,
        success: json["success"] ?? false,
        message: json["message"],
        data: json["data"],
        total: json["total"],
      );

  Map<String, dynamic> toMap() => {
        "isSuccess": isSuccess,
        "success": success,
        "message": message,
        "total": total,
        "data": data,
      };
}
