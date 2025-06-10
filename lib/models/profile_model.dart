class ProfileModel {
  final String name;
  final String email;
  final String mobile;

  ProfileModel({
    required this.name,
    required this.email,
    required this.mobile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
} 