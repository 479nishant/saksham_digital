class Applicant {
  final int id;
  final String fullName;
  final String email;
  final String contactNumber;
  final String educationalQualification;
  final String fieldOfInterest;
  final String? linkedinProfile;
  final String resumePath;
  final String briefIntroduction;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Applicant({
    required this.id,
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.educationalQualification,
    required this.fieldOfInterest,
    this.linkedinProfile,
    required this.resumePath,
    required this.briefIntroduction,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      contactNumber: json['contact_number'],
      educationalQualification: json['educational_qualification'],
      fieldOfInterest: json['field_of_interest'],
      linkedinProfile: json['linkedin_profile'],
      resumePath: json['resume_path'],
      briefIntroduction: json['brief_introduction'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'contact_number': contactNumber,
      'educational_qualification': educationalQualification,
      'field_of_interest': fieldOfInterest,
      'linkedin_profile': linkedinProfile,
      'resume_path': resumePath,
      'brief_introduction': briefIntroduction,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Optional: if API returns a list of applicants
class ApplicantsResponse {
  final List<Applicant> applicants;

  ApplicantsResponse({required this.applicants});

  factory ApplicantsResponse.fromJson(List<dynamic> jsonList) {
    List<Applicant> applicants = jsonList.map((json) => Applicant.fromJson(json)).toList();
    return ApplicantsResponse(applicants: applicants);
  }
}
