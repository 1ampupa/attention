import 'package:attention/core/enums/gender.dart';
import 'package:attention/core/user/user_metrics.dart';
import 'package:attention/core/user/user_profile.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final UserProfile profile;
  final UserMetrics metrics;

  User({
    String? id,
    UserProfile? profile,
    UserMetrics? metrics,
    String? firstName,
    String? lastName,
    String? displayName,
    DateTime? dateOfBirth,
    Gender? gender,
  }) : id = id ?? const Uuid().v4(),
       profile =
           profile ??
           UserProfile(
              firstName: firstName,
              lastName: lastName,
              displayName: displayName,
              dateOfBirth: dateOfBirth,
              gender: gender,
           ), // put value inside will override the existing one, be careful!
       metrics = metrics ?? UserMetrics();
  
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "profile": profile.toJson(),
      "metrics": metrics.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      profile: UserProfile.fromJson(
        Map<String, dynamic>.from(json['profile'] as Map),
      ),
      metrics: UserMetrics.fromJson(
        Map<String, dynamic>.from(json['metrics'] as Map),
      )
    );
  }
}
