import 'dart:convert';
import 'package:http/http.dart'as http;

class ApiHelper {
  static const String baseUrl = 'http://3.93.46.140/'; // Replace with your API base URL
  static Future<dynamic> get({required String endpoint}) async {
    //connecting baseurl+endpoint
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    return _handleResponse(response);
  }
//
//
  static Future<dynamic> post({required String endpoint, Map? data}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }
//
//
  static Future<dynamic> patch({required String endpoint, dynamic data}) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }
//
//
  static Future<dynamic> put({required String endpoint, Map? data}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

//
//

  static Future<dynamic> delete({required endpoint}) async {
    final response = await http.delete(Uri.parse('$baseUrl$endpoint'));
    return _handleResponse(response);
  }
//
//
  static dynamic _handleResponse(http.Response response) {
    print(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success
      print(response.body);
      return jsonDecode(response.body);
    } else {
      // Error
      return null;
    }
  }
}
/*body: It can be a HTML, JSON or XML, etc. This mean is we need to send/recive
        data in that particular format. You can set this in content-type header its
        default value is text/plain.As you set the content-type header to JSON you must
        have to pass a "valid" JSON as the body. But you are passing Map<String, String>
        as the body, which obviously throws an error.So to solve this issue you need to
        change (or encode) your Map<String, String> data to JSON data.Best way to do this
        is to use jsonEncode function.*/
