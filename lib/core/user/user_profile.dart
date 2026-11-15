import 'package:attention/core/enums/gender.dart';

class UserProfile {

  final String? firstName;
  final String? lastName;
  final String? displayName;
  final DateTime? dateOfBirth;
  final int? userAge;
  final int? accountAge;
  final Gender gender;
  final DateTime createAt;

  UserProfile({
    String? firstName,
    String? lastName,
    String? displayName,
    this.dateOfBirth,
    DateTime? createAt,
    Gender? gender,
  }) :
    firstName = firstName ?? "John",
    lastName = lastName ?? "Doe",
    displayName = displayName ?? "Guest",
    createAt = createAt ?? DateTime.now().toUtc(),
    userAge = dateOfBirth?.difference(DateTime.now()).inDays.abs(),
    accountAge = createAt?.difference(DateTime.now()).inDays.abs(),
    gender = gender ?? Gender.preferNotToSay;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'displayName': displayName,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender.name,
      'createAt': createAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      displayName: json['displayName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
        ? null
        : DateTime.parse(json['dateOfBirth']),
      gender: Gender.values.byName(json['gender']),
      createAt: json['createAt'] == null
        ? null
        : DateTime.parse(json['createAt']),
    );
  }

}