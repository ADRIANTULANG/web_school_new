import 'dart:convert';

import 'package:web_school/values/strings/api/key.dart';

class TwilioApi {
  static String BASE_URL = "api.twilio.com";
  static Map<String, String> headers = {
    "Authorization": "Basic ${base64.encode(utf8.encode("${ApiKey.twilioUsername}:${ApiKey.twilioPassword}"))}",
  };

  static String path = "/";

  static String message = "${path}2010-04-01/Accounts/${ApiKey.twilioUsername}/Messages.json";

}