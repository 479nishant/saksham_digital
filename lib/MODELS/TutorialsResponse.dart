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
  final String video; // <-- Add this field

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
    required this.video, // <-- constructor
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
      video: json['video'] ?? "", // <-- make sure your API provides this
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
      'video': video, // <-- include in JSON
    };
  }
}
