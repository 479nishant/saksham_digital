// lib/models/course_model.dart

class Course {
  final int id;
  final String? courseName;  // updated from "name" to match API
  final String? description;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  Course({
    required this.id,
    this.courseName,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create Course object from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      courseName: json['course_name'] as String?,  // updated key
      description: json['description'] as String?,
      image: json['image'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  // Convert Course object back to JSON (useful if you post data later)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_name': courseName,  // updated key
      'description': description,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
