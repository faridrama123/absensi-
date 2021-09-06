import 'dart:convert';

import 'package:absensi/api/erp.glomed.service.dart';
import 'package:absensi/api/service.dart';
import 'package:absensi/models/listabsen/return.dart';
import 'package:absensi/models/menu/cls_absen_hari_ini.dart';
import 'package:absensi/pages/general_widget.dart/widget_error.dart';
import 'package:absensi/pages/general_widget.dart/widget_loading_page.dart';
import 'package:absensi/style/colors.dart';
import 'package:absensi/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuApplication extends StatefulWidget {
  @override
  _MenuApplicationState createState() => _MenuApplicationState();
}

class _MenuApplicationState extends State<MenuApplication> {
  Future getData() async {}

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                child: Center(
                  child: Text(
                    "Leave Application",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff171111),
                      fontSize: 20,
                      fontFamily: "Sansation Light",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
                child: Text("Title",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 30, right: 20),
                child: TextFormField(
                  //    controller: ctrlMaritalStatus,
                  style: GoogleFonts.ibmPlexSans(
                      textStyle:
                          TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: GoogleFonts.ibmPlexSans(
                        textStyle:
                            TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
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
                      Icons.title,
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
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 10),
                child: Text("Mulai",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                child: TextFormField(
                  //    controller: ctrlMaritalStatus,
                  style: GoogleFonts.ibmPlexSans(
                      textStyle:
                          TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
                  decoration: InputDecoration(
                    hintText: "mm/dd/yyyy",
                    hintStyle: GoogleFonts.ibmPlexSans(
                        textStyle:
                            TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
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
                      Icons.date_range,
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
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
                child: Text("Akhir",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                child: TextFormField(
                  //    controller: ctrlMaritalStatus,
                  style: GoogleFonts.ibmPlexSans(
                      textStyle:
                          TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
                  decoration: InputDecoration(
                    hintText: "mm/dd/yyyy",
                    hintStyle: GoogleFonts.ibmPlexSans(
                        textStyle:
                            TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
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
                      Icons.date_range,
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
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
                child: Text("Keterangan",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 30, right: 20),
                child: TextFormField(
                  maxLines: 7,
                  //    controller: ctrlMaritalStatus,
                  style: GoogleFonts.ibmPlexSans(
                      textStyle:
                          TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
                  decoration: InputDecoration(
                    hintText: "",
                    hintStyle: GoogleFonts.ibmPlexSans(
                        textStyle:
                            TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
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
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: ColorsTheme.primary1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "AJUKAN",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
