import '../MODELS/TutorialsResponse.dart';
import 'Tutorial.dart';

class TutorialsResponse {
  final List<Tutorial> tutorials;

  TutorialsResponse({required this.tutorials});

  factory TutorialsResponse.fromJson(Map<String, dynamic> json) {
    return TutorialsResponse(
      tutorials: (json['tutorials'] as List)
          .map((e) => Tutorial.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutorials': tutorials.map((e) => e.toJson()).toList(),
    };
  }
}
