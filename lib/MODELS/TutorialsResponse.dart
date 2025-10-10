// tutorial_model.dart

class TutorialsResponse {
  final List<Tutorial> tutorials;
  final List<CourseMenu> courseMenu;

  TutorialsResponse({
    required this.tutorials,
    required this.courseMenu,
  });

  factory TutorialsResponse.fromJson(Map<String, dynamic> json) {
    return TutorialsResponse(
      tutorials: (json['tutorials'] as List)
          .map((e) => Tutorial.fromJson(e))
          .toList(),
      courseMenu: (json['course_menu'] as List)
          .map((e) => CourseMenu.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutorials': tutorials.map((e) => e.toJson()).toList(),
      'course_menu': courseMenu.map((e) => e.toJson()).toList(),
    };
  }
}

class Tutorial {
  final int id;
  final String title;
  final String sort;
  final String image;
  final String pageName;
  final double ratingStar;
  final int ratingCount;
  final String educatorName;
  final String status;
  final int deleted;
  final int insertedId;
  final String createdAt;
  final String updatedAt;
  final int activeTopicsCount;

  Tutorial({
    required this.id,
    required this.title,
    required this.sort,
    required this.image,
    required this.pageName,
    required this.ratingStar,
    required this.ratingCount,
    required this.educatorName,
    required this.status,
    required this.deleted,
    required this.insertedId,
    required this.createdAt,
    required this.updatedAt,
    required this.activeTopicsCount,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    return Tutorial(
      id: json['id'],
      title: json['title'],
      sort: json['sort'],
      image: json['image'],
      pageName: json['page_name'],
      ratingStar: (json['rating_star'] is int)
          ? (json['rating_star'] as int).toDouble()
          : (json['rating_star'] as num).toDouble(),
      ratingCount: json['rating_count'],
      educatorName: json['educator_name'],
      status: json['status'],
      deleted: json['deleted'],
      insertedId: json['inserted_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      activeTopicsCount: json['active_topics_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sort': sort,
      'image': image,
      'page_name': pageName,
      'rating_star': ratingStar,
      'rating_count': ratingCount,
      'educator_name': educatorName,
      'status': status,
      'deleted': deleted,
      'inserted_id': insertedId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'active_topics_count': activeTopicsCount,
    };
  }
}

class CourseMenu {
  final String courseName;
  final int id;
  final String pageName;

  CourseMenu({
    required this.courseName,
    required this.id,
    required this.pageName,
  });

  factory CourseMenu.fromJson(Map<String, dynamic> json) {
    return CourseMenu(
      courseName: json['course_name'],
      id: json['id'],
      pageName: json['page_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course_name': courseName,
      'id': id,
      'page_name': pageName,
    };
  }
}
