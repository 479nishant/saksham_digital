class LoginResponse {
  final String message;
  final User user;
  final String token;

  LoginResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "user": user.toJson(),
      "token": token,
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final int status;
  final String? dob;
  final int institute;
  final int finalMarks;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String image;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.status,
    this.dob,
    required this.institute,
    required this.finalMarks,
    this.address,
    this.city,
    this.state,
    this.pincode,
    required this.image,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      userType: json['user_type'] ?? '',
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()) ?? 0,
      dob: json['dob'],
      institute: json['institute'] is int
          ? json['institute']
          : int.tryParse(json['institute'].toString()) ?? 0,
      finalMarks: json['final_marks'] is int
          ? json['final_marks']
          : int.tryParse(json['final_marks'].toString()) ?? 0,
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode']?.toString(),
      image: json['image'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "user_type": userType,
      "status": status,
      "dob": dob,
      "institute": institute,
      "final_marks": finalMarks,
      "address": address,
      "city": city,
      "state": state,
      "pincode": pincode,
      "image": image,
      "email_verified_at": emailVerifiedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}