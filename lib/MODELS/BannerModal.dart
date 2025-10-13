import 'dart:convert';

BannerResponse bannerResponseFromJson(String str) =>
    BannerResponse.fromJson(json.decode(str));

String bannerResponseToJson(BannerResponse data) => json.encode(data.toJson());

class BannerResponse {
  BannerResponse({
    required this.data,
  });

  List<BannerData> data;

  factory BannerResponse.fromJson(Map<String, dynamic> json) => BannerResponse(
    data: List<BannerData>.from(
        json["data"].map((x) => BannerData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BannerData {
  BannerData({
    required this.id,
    this.title,
    required this.image,
  });

  int id;
  String? title;
  String image;

  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    id: json["id"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
  };
}
