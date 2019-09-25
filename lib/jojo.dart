import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import 'config.dart';

const API_BASE_URL = 'https://codeforces.com/api/';

class JoJo {
  JoJo({final String option}) {
    switch (option) {
      case "of":
        _getOnlineFriends();
        break;
    }
  }

  void _getOnlineFriends() async {
    final http.Response response = await http.get(
        '${API_BASE_URL}user.friends?onlyOnline=true&apiKey=${API_KEY}&time=${DateTime.now().millisecondsSinceEpoch ~/ 1000}&apiSig=123456${sha512.convert(utf8.encode("123456/user.friends?apiKey=${API_KEY}&onlyOnline=true&time=${DateTime.now().millisecondsSinceEpoch ~/ 1000}#${API_SECRET}"))}');
    final Map<String, dynamic> parsedResponse = jsonDecode(response.body);
    const String PROFILE_BASE_URL = 'https://codeforces.com/profile/';
    if (parsedResponse['status'] == 'OK') {
      (parsedResponse['result'] as List)
          .forEach((final onlineFriend) => stderr.writeln('$onlineFriend - $PROFILE_BASE_URL$onlineFriend'));
    } else {
      stderr.writeln(parsedResponse['comment']);
    }
  }
}
