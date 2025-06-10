class EnquiryDetailsModel {
  final BookingDetails booking;
  final String quotationUrl;
  final List<Activity> activities;
  final List<Hotel> hotels;
  final int noOfRooms;
  final int noOfAdults;
  final int noOfChilds;
  final Map<String, int> additionalBeds;
  final List<String> childYears;
  final List<Vehicle> vehicle;
  final List<Member> members;
  final List<Payment> payments;
  final List<dynamic> specialRequests;

  EnquiryDetailsModel({
    required this.booking,
    required this.quotationUrl,
    required this.activities,
    required this.hotels,
    required this.noOfRooms,
    required this.noOfAdults,
    required this.noOfChilds,
    required this.additionalBeds,
    required this.childYears,
    required this.vehicle,
    required this.members,
    required this.payments,
    required this.specialRequests,
  });

  factory EnquiryDetailsModel.fromJson(Map<String, dynamic> json) {
    return EnquiryDetailsModel(
      booking: BookingDetails.fromJson(json['booking']),
      quotationUrl: json['quotation_url'] ?? '',
      activities: (json['activities'] as List).map((e) => Activity.fromJson(e)).toList(),
      hotels: (json['hotels'] as List).map((e) => Hotel.fromJson(e)).toList(),
      noOfRooms: json['no_of_rooms'] ?? 0,
      noOfAdults: json['no_of_adults'] ?? 0,
      noOfChilds: json['no_of_childs'] ?? 0,
      additionalBeds: Map<String, int>.from(json['additional_beds'] ?? {}),
      childYears: List<String>.from(json['child_years'] ?? []),
      vehicle: (json['vehicle'] as List).map((e) => Vehicle.fromJson(e)).toList(),
      members: (json['members'] as List).map((e) => Member.fromJson(e)).toList(),
      payments: (json['payments'] as List).map((e) => Payment.fromJson(e)).toList(),
      specialRequests: json['special_requests'] ?? [],
    );
  }
}

class BookingDetails {
  final String id;
  final String uniqueEnquiryId;
  final String departureDate;
  final String planName;
  final String companyName;
  final String whatsappNumber;

  BookingDetails({
    required this.id,
    required this.uniqueEnquiryId,
    required this.departureDate,
    required this.planName,
    required this.companyName,
    required this.whatsappNumber,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      id: json['id'] ?? '',
      uniqueEnquiryId: json['unique_enquiry_id'] ?? '',
      departureDate: json['departure_date'] ?? '',
      planName: json['plan_name'] ?? '',
      companyName: json['company_name'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
    );
  }
}

class Activity {
  final String id;
  final String day;
  final String plan;
  final String activity;
  final String destName;

  Activity({
    required this.id,
    required this.day,
    required this.plan,
    required this.activity,
    required this.destName,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] ?? '',
      day: json['day'] ?? '',
      plan: json['plan'] ?? '',
      activity: json['activity'] ?? '',
      destName: json['DestName'] ?? '',
    );
  }
}

class Hotel {
  final String hotelName;
  final String checkIn;
  final String checkOut;
  final String voucher;
  final String city;
  final String email;
  final Package package;
  final String bookingNumber;
  final int noOfRooms;
  final int noOfDays;

  Hotel({
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.voucher,
    required this.city,
    required this.email,
    required this.package,
    required this.bookingNumber,
    required this.noOfRooms,
    required this.noOfDays,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hotelName: json['hotel_name'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      voucher: json['voucher'] ?? '',
      city: json['city'] ?? '',
      email: json['email'] ?? '',
      package: Package.fromJson(json['package'] ?? {}),
      bookingNumber: json['booking_number'] ?? '',
      noOfRooms: int.tryParse(json['no_of_rooms']?.toString() ?? '0') ?? 0,
      noOfDays: int.tryParse(json['no_of_days']?.toString() ?? '0') ?? 0,
    );
  }
}

class Package {
  final String typeName;
  final String description;

  Package({
    required this.typeName,
    required this.description,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      typeName: json['type_name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Vehicle {
  final String typeName;
  final String vehicleImage;
  final String voucher;
  final String pickupFrom;
  final String dropFrom;
  final String pickUpTime;
  final String dropTime;
  final String agentName;
  final String contactNumber;

  Vehicle({
    required this.typeName,
    required this.vehicleImage,
    required this.voucher,
    required this.pickupFrom,
    required this.dropFrom,
    required this.pickUpTime,
    required this.dropTime,
    required this.agentName,
    required this.contactNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      typeName: json['type_name'] ?? '',
      vehicleImage: json['vehicle_image'] ?? '',
      voucher: json['voucher'] ?? '',
      pickupFrom: json['pickup_from'] ?? '',
      dropFrom: json['drop_from'] ?? '',
      pickUpTime: json['pick_up_time'] ?? '',
      dropTime: json['drop_time'] ?? '',
      agentName: json['agent_name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
    );
  }
}

class Member {
  final String name;
  final String contactNumber;
  final String gender;
  final String dob;
  final String mealType;
  final String perPersonCost;

  Member({
    required this.name,
    required this.contactNumber,
    required this.gender,
    required this.dob,
    required this.mealType,
    required this.perPersonCost,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      mealType: json['meal_type'] ?? '',
      perPersonCost: json['per_person_cost'] ?? '',
    );
  }
}

class Payment {
  final String name;
  final String uniquePaymentId;
  final String amount;
  final String paymentComment;
  final String createdDate;
  final String invoice;

  Payment({
    required this.name,
    required this.uniquePaymentId,
    required this.amount,
    required this.paymentComment,
    required this.createdDate,
    required this.invoice,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      name: json['name'] ?? '',
      uniquePaymentId: json['unique_payment_id'] ?? '',
      amount: json['amount'] ?? '',
      paymentComment: json['payment_comment'] ?? '',
      createdDate: json['created_date'] ?? '',
      invoice: json['invoice'] ?? '',
    );
  }
} 