import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  Future<dynamic> getRequest(String url, {Map<String, String>? headers}) async {
    try {
      var resp = await http.get(Uri.parse(url), headers: headers);
      return resp.body;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<dynamic> postRequest(String url, Map<String, String> headers,
      Map<String, dynamic> body) async {
    try {
      var resp = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));
      return resp.body;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
