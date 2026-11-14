import 'package:attention/core/enums/gender.dart';
import 'package:attention/core/user/user_metrics.dart';
import 'package:attention/core/user/user_profile.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final UserProfile profile;
  final UserMetrics metrics;

  User({
    String? id,
    String? name,
    UserProfile? profile,
    UserMetrics? metrics,
    int? age,
    Gender? gender,
  }) : id = id ?? const Uuid().v4(),
       name = name ?? "User",
       profile =
           profile ??
           UserProfile(
             age: age,
             gender: gender,
           ), // put value inside will override the existing one, be careful!
       metrics = metrics ?? UserMetrics();
}
