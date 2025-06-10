class BookingModel {
  final String img;
  final String enquiryId;
  final String uniqueEnquiryId;
  final String departureDate;
  final String planId;
  final String planName;
  final String isBookingDone;

  BookingModel({
    required this.img,
    required this.enquiryId,
    required this.uniqueEnquiryId,
    required this.departureDate,
    required this.planId,
    required this.planName,
    required this.isBookingDone,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      img: json['img'] ?? '',
      enquiryId: json['enquiry_id'] ?? '',
      uniqueEnquiryId: json['unique_enquiry_id'] ?? '',
      departureDate: json['departure_date'] ?? '',
      planId: json['plan_id'] ?? '',
      planName: json['plan_name'] ?? '',
      isBookingDone: json['is_booking_done'] ?? '',
    );
  }

  static List<BookingModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => BookingModel.fromJson(json)).toList();
  }
} 