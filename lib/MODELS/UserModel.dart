// lib/models/user_model.dart

class User {
  final int id;
  final String? name;
  final String? email;
  final int? phone;
  final String? userType;
  final int? status;
  final String? dob;
  final String? institute;
  final int? finalMarks;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? image;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? logCountry;

  User({
    required this.id,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.status,
    this.dob,
    this.institute,
    this.finalMarks,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.image,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.logCountry,
  });

  // Factory constructor to create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] is int ? json['phone'] : int.tryParse(json['phone']?.toString() ?? ''),
      userType: json['user_type'] as String?,
      status: json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? ''),
      dob: json['dob'] as String?,
      institute: json['institute'] as String?,
      finalMarks: json['final_marks'] is int ? json['final_marks'] : int.tryParse(json['final_marks']?.toString() ?? ''),
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      image: json['image'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      logCountry: json['log_country'] as String?,
    );
  }

  // Convert User object back to JSON (useful if you need to send data to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'status': status,
      'dob': dob,
      'institute': institute,
      'final_marks': finalMarks,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'image': image,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'log_country': logCountry,
    };
  }
}
