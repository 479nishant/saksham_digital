// lib/models/testimonial.dart

class Testimonial {
  final int id;
  final String name;
  final String designation;
  final String feedback;
  final String image;
  final DateTime createdAt;

  Testimonial({
    required this.id,
    required this.name,
    required this.designation,
    required this.feedback,
    required this.image,
    required this.createdAt,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] as int,
      name: json['name'] as String,
      designation: json['designation'] as String,
      feedback: json['feedback'] as String,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'feedback': feedback,
      'image': image,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TestimonialsResponse {
  final String status;
  final List<Testimonial> data;

  TestimonialsResponse({
    required this.status,
    required this.data,
  });

  factory TestimonialsResponse.fromJson(Map<String, dynamic> json) {
    var list = (json['data'] as List)
        .map((e) => Testimonial.fromJson(e as Map<String, dynamic>))
        .toList();
    return TestimonialsResponse(
      status: json['status'] as String,
      data: list,
    );
  }
}
