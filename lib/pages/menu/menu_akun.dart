import 'dart:convert';

import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/models/profil/return.dart';
import 'package:flutter_application_1/pages/auth/login.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
import 'package:flutter_application_1/pages/menu/menu_payroll.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MenuAkun extends StatefulWidget {
  @override
  _MenuAkunState createState() => _MenuAkunState();
}

class _MenuAkunState extends State<MenuAkun> {
  String staffId = "";
  String nama = "";
  String alamat = "";
  String imageProfil = "";
  String version = "";
  String nik = "";
  String maritalStatus = "";
  String birthday = "";
  String gender = "";
  String blood = "";
  String phone = "";
  String email = "";
  String address = "";
  String bankName = "";
  String nobankName = "";

  String division = "";
  String position = "";
  String section = "";

  late ThemeData themeData;

  TextEditingController ctrlMaritalStatus = new TextEditingController();
  TextEditingController ctrlBirthday = new TextEditingController();
  TextEditingController ctrlGender = new TextEditingController();
  TextEditingController ctrlBlood = new TextEditingController();
  TextEditingController ctrlPhone = new TextEditingController();
  TextEditingController ctrlEmail = new TextEditingController();
  TextEditingController ctrlAddress = new TextEditingController();

  TextEditingController ctrlNama = new TextEditingController();
  TextEditingController ctrlAlamat = new TextEditingController();
  TextEditingController ctrlPayroll = new TextEditingController();

  TextEditingController ctrlBankName = new TextEditingController();
  TextEditingController ctrlNoBank = new TextEditingController();

  TextEditingController ctrDivison = new TextEditingController();
  TextEditingController ctrlPosition = new TextEditingController();
  TextEditingController ctrlSection = new TextEditingController();

  DevService _devService = DevService();

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final PackageInfo info = await PackageInfo.fromPlatform();
    var accesToken = pref.getString("PREF_TOKEN")!;
    print(accesToken);

    _devService.profil(accesToken).then((value) async {
      var res = ReturnProfil.fromJson(json.decode(value));
      print(res.profile);
      if (res.status_json == true) {
        setState(() {
          version = info.version;

          staffId = res.profile?.staff_id ?? "";
          var lastname = res.profile?.last_name ?? "";
          var firstname = res.profile?.first_name ?? "";
          nama = firstname + " " + lastname;
          alamat = res.profile?.address ?? " ";
          nik = res.profile?.nik ?? " ";
          imageProfil = res.profile?.foto_profile ?? " ";
          print(imageProfil);

          maritalStatus = res.profile?.marital_status ?? "";
          birthday = res.profile?.birth_day ?? "";
          gender = res.profile?.gender ?? "";
          blood = res.profile?.blood ?? "";
          phone = res.profile?.phone ?? "";
          email = res.profile?.email ?? "";
          address = res.profile?.address ?? "";
          bankName = res.profile?.bank_name ?? "";
          nobankName = res.profile?.bank_accountno ?? "";

          division = res.profile?.division ?? "";
          position = res.profile?.position ?? "";
          section = res.profile?.section ?? "";

          ctrDivison.text = division;
          ctrlPosition.text = position;
          ctrlSection.text = section;

          ctrlMaritalStatus.text = maritalStatus;
          ctrlBirthday.text = birthday;
          ctrlGender.text = gender;
          ctrlBlood.text = blood;
          ctrlPhone.text = phone;
          ctrlEmail.text = email;
          ctrlAddress.text = address;

          ctrlBankName.text = bankName;
          ctrlNoBank.text = nobankName;

          //  print("maritalStatus " + maritalStatus + ctrlMaritalStatus.text);

          // ctrlNip.text = staffId;
          // ctrlNama.text = nama;
          // ctrlAlamat.text = alamat;
        });
      }
    });
  }

  // getData() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   final PackageInfo info = await PackageInfo.fromPlatform();
  //   setState(() {
  //     version = info.version;
  //     nip = pref.getString("PREF_NIP")!;
  //     nama = pref.getString("PREF_NAMA")!;
  //     alamat = pref.getString("PREF_ALAMAT")!;
  //     ctrlNip.text = nip;
  //     ctrlNama.text = nama;
  //     ctrlAlamat.text = alamat;
  //   });
  // }

  dialogLogout() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Konfirmasi')),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  //USERNAME FIELD
                  Text("Anda yakin akan keluar aplikasi ?")
                ]),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.screenLeftRight1, bottom: 8),
                    child: Container(
                      width: Get.width * 0.3,
                      child: SizedBox(
                        height: Get.height * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: ColorsTheme.primary1)),
                          color: Colors.white,
                          child: Text(
                            "TIDAK",
                            style: TextStyle(
                                color: ColorsTheme.primary1,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.screenLeftRight1, bottom: 8),
                    child: Container(
                      width: Get.width * 0.3,
                      child: SizedBox(
                        height: Get.height * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            goToLogin();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: ColorsTheme.primary1,
                          child: Text(
                            "YA",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.fontSize4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget textField(TextEditingController ctrl, String hintText,
      TextInputType textInputType, bool obscureText) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.screenLeftRight0,
          right: SizeConfig.screenLeftRight0,
          bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsTheme.background2,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: SizeConfig.screenLeftRight1),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  keyboardType: textInputType,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: hintText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  updateProfileDialog(String value) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return AlertDialog(
              title: Center(child: Text(value)),
              content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 12,
                    ),
                    // textField(ctrlNip, "NIP", TextInputType.text, false),
                    // textField(ctrlNama, "Nama", TextInputType.text, false),
                    // textField(ctrlAlamat, "Alamat", TextInputType.text, false),
                  ]),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.screenLeftRight1,
                      right: SizeConfig.screenLeftRight1,
                      bottom: 8),
                  child: Container(
                    width: Get.width,
                    child: SizedBox(
                      height: Get.height * 0.045,
                      child: RaisedButton(
                        onPressed: () {
                          String check = checkMandatory();
                          if (check == "") {
                            submitRegister();
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
                          "SUBMIT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.fontSize4),
                        ),
                      ),
                    ),
                  ),
                )
              ]);
        });
  }

  goToLogin() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginPage();
        },
      ),
      (_) => false,
    );
  }

  void _showPopupMenu() async {
    String? selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(50, 50, 0, 0),
      items: [
        // PopupMenuItem<String>(
        //   child: Text('Edit Profile'),
        //   value: "Edit Profile",
        // ),
        PopupMenuItem<String>(
          child: Text('Logout'),
          value: "Logout",
        ),
      ],
      elevation: 8.0,
    );
    if (selected == "Edit Profile") {
      //  updateProfileDialog(selected!);
    } else if (selected == "Logout") {
      dialogLogout();
    }
  }

  Future submitRegister() async {}

  checkMandatory() {
    return "";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Container(
                height: Get.height * 0.4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xffbefffb), Color(0x00fce9a8)],
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.screenLeftRight1 + 10,
                  right: SizeConfig.screenLeftRight1 + 10,
                  top: Get.height * 0.05),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      " Akun",
                      style: TextStyle(
                          fontFamily: 'BalsamiqSans',
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showPopupMenu();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.widgets,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.3),
              child: Container(
                // height: Get.height * 0.4,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: Get.height * 0.20,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5, left: 20),
                      child: Text("Personal information",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, letterSpacing: 0)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlMaritalStatus,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Marital Status",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.supervised_user_circle,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlBirthday,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Birthday",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.date_range_sharp,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlGender,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Gender",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.transgender,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlBlood,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Blood",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.bloodtype,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlPhone,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Phone",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlEmail,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.email,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlAddress,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Address",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.home,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 5, left: 20, top: 20),
                      child: Text("Bank Account",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, letterSpacing: 0)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        //    controller: ctrlMaritalStatus,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Bank BCA",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.account_balance,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlBankName,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.person,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlNoBank,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Account No",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5, left: 20, top: 20),
                      child: Text("Employment Detail",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, letterSpacing: 0)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrDivison,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Divisions",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.military_tech,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlPosition,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Position",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.meeting_room,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        controller: ctrlSection,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Section",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.work,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 30, right: 20),
                      child: TextFormField(
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 15, color: Color(0xff4a4c4f))),
                        decoration: InputDecoration(
                          hintText: "Basic Salary",
                          hintStyle: GoogleFonts.ibmPlexSans(
                              textStyle: TextStyle(
                                  fontSize: 15, color: Color(0xff4a4c4f))),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Color(0xfffafaff),
                          prefixIcon: Icon(
                            Icons.money,
                            size: 22,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.all(0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   padding: EdgeInsets.all(15),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xfffafaff),
                    //   ),
                    //   margin: EdgeInsets.only(
                    //       bottom: 5, left: 20, top: 20, right: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text("Leave Application",
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w600,
                    //               letterSpacing: 0)),
                    //       Icon(Icons.arrow_right_rounded)
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   padding: EdgeInsets.all(15),
                    //   decoration: BoxDecoration(
                    //     color: Color(0xfffafaff),
                    //   ),
                    //   margin: EdgeInsets.only(
                    //       bottom: 5, left: 20, top: 10, right: 20),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text("Document",
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w600,
                    //               letterSpacing: 0)),
                    //       Icon(Icons.arrow_right_rounded)
                    //     ],
                    //   ),
                    // ),

                    // Container(
                    //   margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                    //   child: TextFormField(
                    //     //    controller: ctrlMaritalStatus,
                    //     style: GoogleFonts.ibmPlexSans(
                    //         textStyle: TextStyle(
                    //             fontSize: 15, color: Color(0xff4a4c4f))),
                    //     decoration: InputDecoration(
                    //       hintText: "Leave Application",
                    //       hintStyle: GoogleFonts.ibmPlexSans(
                    //           textStyle: TextStyle(
                    //               fontSize: 15, color: Color(0xff4a4c4f))),
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(8.0),
                    //           ),
                    //           borderSide: BorderSide.none),
                    //       enabledBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(8.0),
                    //           ),
                    //           borderSide: BorderSide.none),
                    //       focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(8.0),
                    //           ),
                    //           borderSide: BorderSide.none),
                    //       filled: true,
                    //       fillColor: Color(0xfffafaff),
                    //       isDense: true,
                    //       contentPadding: EdgeInsets.all(15),
                    //     ),
                    //     keyboardType: TextInputType.emailAddress,
                    //     textCapitalization: TextCapitalization.sentences,
                    //   ),
                    // ),

                    //   card(context, Icons.email, "NIP", staffId),
                    //    card(context, Icons.email, "Nama", nama),
                    // card(context, Icons.email, "Alamat", alamat),
                    // GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (BuildContext context) => MenuPayroll(),
                    //         ),
                    //       );
                    //     },
                    //     child: card(context, Icons.email, "Payroll",
                    //         'Lihat daftar gaji')),
                    SizedBox(
                      height: Get.height * 0.075,
                    ),
                    GestureDetector(
                      onTap: () {
                        dialogLogout();
                      },
                      child: Center(
                        child: Text(
                          "KELUAR",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorsTheme.text1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.025,
                    ),
                    Center(
                      child: Text(
                        version == null ? "" : "Version " + version,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsTheme.primary1),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.screenLeftRight1,
                  right: SizeConfig.screenLeftRight1,
                  top: Get.height * 0.2),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: <Widget>[
                    if (imageProfil != "")
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        height: Get.height * 0.175,
                        width: Get.width * 0.375,
                        child: CircleAvatar(
                          radius: Get.width * 0.2,
                          backgroundImage: NetworkImage(imageProfil),
                          // fit: BoxFit.,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    if (imageProfil == "")
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        height: Get.height * 0.175,
                        width: Get.width * 0.375,
                        child:

                            // CircleAvatar(
                            //   radius: Get.width * 0.2,
                            //   backgroundImage: NetworkImage(imageProfil),
                            //   // fit: BoxFit.,

                            //   backgroundColor: Colors.transparent,
                            // ),

                            CircleAvatar(
                          radius: Get.width * 0.2,
                          backgroundImage:
                              AssetImage("assets/images/profil.png"),
                          // fit: BoxFit.,

                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(nama.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0)),
                    SizedBox(
                      height: 5,
                    ),
                    Text("ID Staff : " + staffId.toUpperCase(),
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xff4a4c4f)))),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "NIK : " + nik.toUpperCase(),
                      style: GoogleFonts.ibmPlexSans(
                          textStyle: TextStyle(
                              fontSize: 12, color: Color(0xff4a4c4f))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget card(BuildContext context, IconData icon, String key, String value) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
    child: Card(
      elevation: 2,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
        child: Container(
          // height: 100,
          width: Get.width,
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(color: ColorsTheme.primary1, width: 5))),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  key,
                  style: TextStyle(
                      fontFamily: 'BalsamiqSans',
                      fontSize: 16,
                      color: Colors.blueGrey),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  value,
                  style: TextStyle(
                      fontFamily: 'BalsamiqSans',
                      fontSize: 18,
                      color: ColorsTheme.text1),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
