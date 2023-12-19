import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<Map> uploadFile({
  required File file,
  required String filename,
}) async {
  ///MultiPart request
  var request = http.MultipartRequest(
    'POST',
    Uri.parse("http://10.0.2.2:3000/api/pemilik/upload"),
  );
  Map<String, String> headers = {
    // "Authorization": "Bearer $token",
    "Content-type": "multipart/form-data"
  };
  request.files.add(
    http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: filename,
      contentType: MediaType('image', 'jpeg'),
    ),
  );
  request.headers.addAll(headers);
  final res = await request.send();
  var response = await http.Response.fromStream(res);

  return response.bodyBytes.isEmpty
      ? throw Exception('File upload failed')
      : {'status': response.statusCode, 'body': json.decode(response.body)};
}
