class OfferModel {
  final String image;
  final String name;

  OfferModel({
    required this.image,
    required this.name,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
    );
  }

  static List<OfferModel> listFromJson(List<dynamic> json) {
    return json.map((item) => OfferModel.fromJson(item)).toList();
  }
} 