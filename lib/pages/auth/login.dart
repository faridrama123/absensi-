import 'dart:convert';

import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/api/service.dart';
import 'package:flutter_application_1/models/auth/cls_post_login.dart';
import 'package:flutter_application_1/models/login/return.dart';
import 'package:flutter_application_1/models/return_check.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_progress.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter_application_1/provider/provider.login.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController ctrlemail = new TextEditingController();
  TextEditingController ctrlPassword = new TextEditingController();

  DevService _devService = DevService();

  Future submitLogin(BuildContext context, ReturnLogin returnLogin) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) => WidgetProgressSubmit());
    //ModelPostLogin dataSubmit = new ModelPostLogin();
    //  dataSubmit.username = ctrlemail.text;
    //  dataSubmit.password = ctrlPassword.text;
    // getClient().postLogin(dataSubmit).then((res) async {
    //   Navigator.pop(context);
    //   if (res.statusJson!) {

    if (returnLogin.dataUser != null) {
      var firstname = returnLogin.dataUser?.firstName ?? "";
      var lastname = returnLogin.dataUser?.lastName ?? "";

      pref.setString("PREF_TOKEN", returnLogin.token!);
      pref.setString("PREF_ID_USER", returnLogin.dataUser!.userId!);
      pref.setString("PREF_USERNAME", returnLogin.dataUser!.username!);
      pref.setString("PREF_EMAIL", returnLogin.dataUser!.email!);
      pref.setString("PREF_NIP", returnLogin.dataUser?.staffId ?? "");
      pref.setString("PREF_NIK", returnLogin.dataUser?.nik ?? "");
      pref.setString("PREF_NAMA", firstname + " " + lastname);
      pref.setString("PREF_JK", "unknown");
      pref.setString(
          "PREF_TEMPAT_LAHIR", returnLogin.dataUser?.birthPlace ?? "");
      pref.setString(
          "PREF_TANGGAL_LAHIR", returnLogin.dataUser?.birthDay ?? "");
      pref.setString("PREF_ALAMAT", returnLogin.dataUser?.address ?? "");
      pref.setString("PREF_RT", "unknown");
      pref.setString("PREF_RW", "unknown");
      pref.setString("PREF_DESA", "unknown");
      pref.setString("PREF_KECAMATAN", "unknown");
      pref.setString("PREF_KOTA", "unknown");
      pref.setString("PREF_PROVINSI", "unknown");
      pref.setString("PREF_DEPARTEMEN", returnLogin.dataUser?.division ?? "");
      pref.setString("PREF_POSISI", returnLogin.dataUser?.position ?? "");
      pref.setString("PREF_FACE", returnLogin.dataUser?.facedata ?? "");
      pref.setString(
          "PREF_JARAK", returnLogin.dataUser?.radius.toString() ?? "");
      pref.setString(
          "PREF_LATITUDE", returnLogin.dataUser?.latitude.toString() ?? "");

      pref.setString(
          "PREF_LONGITUDE", returnLogin.dataUser?.longitude.toString() ?? "");

      pref.setString(
          "PREF_FACE_IOS", returnLogin.dataUser?.faceIos.toString() ?? "");

      pref.setString("PREF_FACE_ANDROID",
          returnLogin.dataUser?.faceAndroid.toString() ?? "");

      navigateToHome();
      print(returnLogin.token!);
    } else {
      WidgetSnackbar(
          context: context, message: returnLogin.remarks, warna: "merah");
    }
  }

  // Future submitLogin(BuildContext context) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) => WidgetProgressSubmit());
  //   ModelPostLogin dataSubmit = new ModelPostLogin();
  //   dataSubmit.username = ctrlemail.text;
  //   dataSubmit.password = ctrlPassword.text;
  //   getClient().postLogin(dataSubmit).then((res) async {
  //     Navigator.pop(context);
  //     if (res.statusJson!) {
  //       pref.setString("PREF_TOKEN", res.token!);
  //       pref.setString("PREF_ID_USER", res.dataUser!.id!);
  //       pref.setString("PREF_USERNAME", res.dataUser!.username!);
  //       pref.setString("PREF_EMAIL", res.dataUser!.email!);
  //       pref.setString("PREF_NIP", res.dataUser!.nik!);
  //       pref.setString("PREF_NIK", res.dataUser!.nik!);
  //       pref.setString("PREF_NAMA", res.dataUser!.nama!);
  //       pref.setString("PREF_JK", res.dataUser!.jenisKelamin!);
  //       pref.setString("PREF_TEMPAT_LAHIR", res.dataUser!.tempatLahir!);
  //       pref.setString("PREF_TANGGAL_LAHIR", res.dataUser!.tempatLahir!);
  //       pref.setString("PREF_ALAMAT", res.dataUser!.alamat!);
  //       pref.setString("PREF_RT", res.dataUser!.rt!);
  //       pref.setString("PREF_RW", res.dataUser!.rw!);
  //       pref.setString("PREF_DESA", res.dataUser!.desa!);
  //       pref.setString("PREF_KECAMATAN", res.dataUser!.kecamatan!);
  //       pref.setString("PREF_KOTA", res.dataUser!.kota!);
  //       pref.setString("PREF_PROVINSI", res.dataUser!.provinsi!);
  //       pref.setString("PREF_DEPARTEMEN", res.dataUser!.departemen!);
  //       pref.setString("PREF_POSISI", res.dataUser!.posisi!);
  //       pref.setString("PREF_FACE", res.dataUser!.facedata!);
  //       navigateToHome();
  //       print(res.token!);
  //     } else {
  //       WidgetSnackbar(context: context, message: res.remarks, warna: "merah");
  //     }
  //   }).catchError((Object obj) {
  //     print(obj.toString());
  //     Navigator.pop(context);
  //     WidgetSnackbar(
  //         context: context,
  //         message: "Failed connect to server!",
  //         warna: "merah");
  //   });
  // }

  checkMandatory() {
    if (ctrlemail.text.isEmpty) {
      return "Silakan isi Email";
    } else if (ctrlPassword.text.isEmpty) {
      return "Silakan isi Password";
    } else {
      return "";
    }
  }

  clearPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainMenu()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    clearPref();
  }

  @override
  Widget build(BuildContext context) {
    //var pLogin = Provider.of<ProviderLogin>(context);

    SizeConfig().init(context);
    return Scaffold(
      body: Container(
          color: Colors.white,
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      "assets/ilustration/login.png",
                      fit: BoxFit.cover,
                      width: SizeConfig.screenWidth * 0.7,
                    ),
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        "SpeedERP For Employee",
                        style: TextStyle(
                            fontFamily: 'BalsamiqSans',
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.075,
                  ),

                  //email FIELD
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.background2,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.screenLeftRight1),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: ctrlemail,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Email'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.01,
                  ),
                  //PASSWORD FIELD
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsTheme.background2,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: SizeConfig.screenLeftRight1),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lock),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: ctrlPassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.screenHeight * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight3,
                        right: SizeConfig.screenLeftRight3),
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: SizedBox(
                        height: SizeConfig.screenHeight * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            String check = checkMandatory();
                            if (check == "") {
                              //  submitLogin(context);
                              //  print("login");

                              _devService
                                  .login(ctrlemail.text, ctrlPassword.text)
                                  .then((value) {
                                var res =
                                    ReturnCheck.fromJson(json.decode(value));

                                if (res.statusJson == true) {
                                  var data =
                                      ReturnLogin.fromJson(json.decode(value));

                                  submitLogin(context, data);
                                } else {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  WidgetSnackbar(
                                      context: context,
                                      message: res.remarks,
                                      warna: "merah");
                                }
                              });

                              //  print(pLogin.returnLogin);
                              //  submitLogin(context, pLogin.returnLogin);
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              WidgetSnackbar(
                                  context: context,
                                  message: check,
                                  warna: "merah");
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: ColorsTheme.primary1,
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
