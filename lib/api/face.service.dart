import 'package:flutter_application_1/models/return_check.dart';
import 'package:flutter_application_1/models/return_face_data.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';

class FaceService {
  Future<dynamic> postFace(String path, String iduser) async {
    var postUri = Uri.parse("http://quickport.arundaya.id:8081/post-face");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('facedata', path);

    request.files.add(multipartFile);
    request.fields['iduser'] = iduser;

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);

    return ReturnFaceData.fromJson(json.decode(response.body));
  }

  Future<dynamic> checkFace(String path, String iduser) async {
    var postUri = Uri.parse("http://quickport.arundaya.id:8081/check-face");

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('facedata', path);

    request.files.add(multipartFile);
    request.fields['iduser'] = iduser;

    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);

    return ReturnFaceData.fromJson(json.decode(response.body));
  }
}
