class SectorModel {
  final bool status;
  final String message;
  final List<Sector> sectors;

  SectorModel({
    required this.status,
    required this.message,
    required this.sectors,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) {
    return SectorModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      sectors: (json['sectors'] as List?)
              ?.map((sector) => Sector.fromJson(sector))
              .toList() ??
          [],
    );
  }
}

class Sector {
  final String stateName;
  final String stateId;

  Sector({
    required this.stateName,
    required this.stateId,
  });

  factory Sector.fromJson(Map<String, dynamic> json) {
    return Sector(
      stateName: json['StateName'] ?? '',
      stateId: json['StateId'] ?? '',
    );
  }
} 