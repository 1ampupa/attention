import 'dart:convert';
import 'dart:io';

import 'package:attention/core/user/user.dart';
import 'package:path_provider/path_provider.dart';

class UserStorage {
  static Future<File> get _userFile async {
    final directory = await getApplicationSupportDirectory();

    return File('${directory.path}/user.json');
  }

  static Future<void> save(User user) async {
    final file = await _userFile;

    final jsonString = const JsonEncoder.withIndent('  ')
        .convert(user.toJson());

    await file.writeAsString(jsonString, flush: true);
  }

  static Future<User?> load() async {
    final file = await _userFile;

    if (!await file.exists()) return null;

    final jsonString = await file.readAsString();
    final jsonData = jsonDecode(jsonString);

    return User.fromJson(
      Map<String, dynamic>.from(jsonData as Map),
    );
  }

  static Future<void> delete() async {
    final file = await _userFile;

    if (await file.exists()) {
      await file.delete();
    }
  }
}
