import 'dart:convert';

import 'package:flutter_application_1/models/absen/post.dart';
import 'package:flutter_application_1/models/absenhari/return.dart';
import 'package:flutter_application_1/models/cabang/return.dart';
import 'package:flutter_application_1/models/login/post.dart';
import 'package:flutter_application_1/models/login/return.dart';
import 'package:http/http.dart' as http;

class DevService {
  static final String _baseUrl = 'http://erp.glomed21.id/';
  // static final String _baseUrl = 'http://smarterp.speedlab.id/';

  static final String _login = "m/login";
  static final String _absenhariini = "m/absen/harini";
  static final String _listabsen = "m/absen/list";
  static final String _updatefacedata = "m/updatefacedata";
  static final String _absen = "m/absen";
  static final String _profil = "m/profile";
  static final String _myovertime = "m/myovertime";
  static final String _myleave = "m/myleave";
  static final String _overtime = "m/overtime";
  static final String _leave = "m/leave";
  static final String _allcabang = "m/allcabang";

  Future<dynamic> allcabang(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _allcabang),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return ReturnCabang.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to get myovertime');
      throw Exception('Failed to load');
    }
  }

  Future leave(
      String accesToken,
      String idstaff,
      String tanggal,
      String ket,
      String tipe,
      String mulai,
      String akhir,
      String jammulai,
      String jamakhir,
      String pdfbase64) async {
    Map data = {
      "idstaff": idstaff,
      "tanggal": tanggal,
      "ket": ket,
      "tipe": tipe,
      "mulai": mulai,
      "akhir": akhir,
      "jam_mulai": jammulai,
      "jam_akhir": jamakhir,
      "pdf_base64": pdfbase64
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _leave),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("overtime succes " + response.body);
      return response.body;
      //ReturnLogin.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to post absen ');
      throw Exception('Failed to post');
    }
  }

  Future overtime(String accesToken, String idstaff, String tanggal, String ket,
      String tgllembur, String jammulai, String jamakhir) async {
    Map data = {
      "idstaff": idstaff,
      "tanggal": tanggal,
      "ket": ket,
      "tgl_lembur": tgllembur,
      "jam_mulai": jammulai,
      "jam_akhir": jamakhir
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _overtime),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("overtime succes " + response.body);
      return response.body;
      //ReturnLogin.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to post absen ');
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> myovertime(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _myovertime),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return response
          .body; // ReturnListAbsen.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to get myovertime');
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> myleave(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _myleave),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return response
          .body; // ReturnListAbsen.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to get myleave');
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> profil(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _profil),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return response
          .body; // ReturnListAbsen.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to get');
      throw Exception('Failed to load');
    }
  }

  Future absen(String accesToken, PostAbsen postAbsen) async {
    //  Map data = {"facedata": facedata};

    var body = jsonEncode(postAbsen);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _absen),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("absen succes " + response.body);
      return response.body;
      //ReturnLogin.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to post absen ');
      throw Exception('Failed to post');
    }
  }

  Future updatefacedata(String accesToken, List<dynamic> facedata) async {
    Map data = {"facedata": facedata};

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _updatefacedata),
          headers: <String, String>{
            'Authorization': accesToken,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("updatefacedata succes " + response.body);
      return response.body;
      //ReturnLogin.fromJson(json.decode(response.body));
    } else {
      print(response.body);

      print('Failed to post updatefacedata ');
      throw Exception('Failed to post');
    }
  }

  Future<dynamic> listabsen(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _listabsen),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return response
          .body; // ReturnListAbsen.fromJson(json.decode(response.body));
    } else {
      print('Failed to get');
      throw Exception('Failed to load');
    }
  }

  Future<dynamic> absenhariini(String accesToken) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _absenhariini),
      headers: <String, String>{
        'Authorization': accesToken,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return response
          .body; // ReturnAbsenHari.fromJson(json.decode(response.body));
    } else {
      print('Failed to get');
      throw Exception('Failed to load');
    }
  }

  Future login(String username, String password) async {
    Map data = {
      "username": username,
      "password": password,
    };

    var body = jsonEncode(data);

    final response = await http
        .post(
          Uri.parse(_baseUrl + _login),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body,
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      print("Succes Login" + response.body);
      return response.body; // ReturnLogin.fromJson(json.decode(response.body));
    } else {
      print("Failed to post" + response.body);
      print('Failed to post');
      throw Exception('Failed to post');
    }
  }
}
