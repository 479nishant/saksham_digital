// lib/models/course_model.dart

class Course {
  final int id;
  final String? courseName;  // matches API key "course_name"
  final String? description;
  final String? image;
  final String? logo;        // <-- new field for course logo
  final String? createdAt;
  final String? updatedAt;

  Course({
    required this.id,
    this.courseName,
    this.description,
    this.image,
    this.logo,       // <-- add to constructor
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create Course object from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      courseName: json['course_name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      logo: json['logo'] as String?,   // <-- parse logo from JSON
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  // Convert Course object back to JSON (useful if posting data later)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_name': courseName,
      'description': description,
      'image': image,
      'logo': logo,       // <-- include logo in JSON
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
