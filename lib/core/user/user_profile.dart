import 'package:attention/core/enums/gender.dart';

class UserProfile {

  final DateTime createAt;
  final int? age;
  final Gender gender;

  UserProfile({
    this.age,
    Gender? gender,
  }) :
    createAt = DateTime.now().toUtc(),
    gender = gender ?? Gender.preferNotToSay;

}