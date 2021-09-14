import 'dart:convert';

import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/api/service.dart';
import 'package:flutter_application_1/models/listabsen/return.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/models/myovertime/return.dart';
import 'package:flutter_application_1/models/return_check.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_error.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_loading_page.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuLembur extends StatefulWidget {
  @override
  _MenuLemburState createState() => _MenuLemburState();
}

class _MenuLemburState extends State<MenuLembur> {
  DevService _devService = DevService();

  late List<Listovertime> listovertime = [];
  Future getData() async {
    DateTime now = DateTime.now();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;

    _devService.myovertime(accesToken).then((value) async {
      var res = ReturnMyOvertime.fromJson(json.decode(value));

      if (res.statusJson == true) {
        print("my lembur" + res.listovertime.length.toString());

        setState(() {
          listovertime = res.listovertime;
          print(listovertime.length);
        });
      }
    });
  }

  TextEditingController tanggalLembur = TextEditingController();
  TextEditingController timestart = TextEditingController();
  TextEditingController timeend = TextEditingController();
  TextEditingController keterangan = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
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
                    "Overtime Application",
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
              // Container(
              //   margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
              //   child: Text("Title",
              //       style: TextStyle(
              //           fontWeight: FontWeight.w600, letterSpacing: 0)),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 15, left: 30, right: 20),
              //   child: TextFormField(
              //     //    controller: ctrlMaritalStatus,
              //     style: GoogleFonts.ibmPlexSans(
              //         textStyle:
              //             TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
              //     decoration: InputDecoration(
              //       hintText: "Title",
              //       hintStyle: GoogleFonts.ibmPlexSans(
              //           textStyle:
              //               TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
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
              //       prefixIcon: Icon(
              //         Icons.title,
              //         size: 22,
              //       ),
              //       isDense: true,
              //       contentPadding: EdgeInsets.all(0),
              //     ),
              //     keyboardType: TextInputType.emailAddress,
              //     textCapitalization: TextCapitalization.sentences,
              //   ),
              // ),'

              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 10),
                child: Text("Tanggal",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: TextFormField(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020, 1),
                      lastDate: DateTime(2021, 12),
                    ).then((pickedDate) {
                      print(pickedDate);

                      tanggalLembur.text =
                          convertDateTimeDisplay(pickedDate.toString());
                      print(" tanggalLembur.text " + tanggalLembur.text);
                    });
                  },
                  controller: tanggalLembur,
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
                child: Text("Jam In",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                child: TextFormField(
                  controller: timestart, //editing controller of this TextField

                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        timestart.text = pickedTime.format(context).toString();
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },

                  //    controller: ctrlMaritalStatus,
                  style: GoogleFonts.ibmPlexSans(
                      textStyle:
                          TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
                  decoration: InputDecoration(
                    //  hintText: "mm/dd/yyyy",
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
                      Icons.alarm,
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
                child: Text("Jam Out",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                child: TextFormField(
                  controller: timeend, //editing controller of this TextField

                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    if (pickedTime != null) {
                      print(pickedTime.format(context)); //output 10:51 PM

                      setState(() {
                        timeend.text = pickedTime.format(context).toString();
                      });
                    } else {
                      print("Time is not selected");
                    }
                  },

                  //    controller: ctrlMaritalStatus,
                  style: GoogleFonts.ibmPlexSans(
                      textStyle:
                          TextStyle(fontSize: 15, color: Color(0xff4a4c4f))),
                  decoration: InputDecoration(
                    //  hintText: "mm/dd/yyyy",
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
                      Icons.alarm,
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
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 15, left: 30, right: 20),
                child: TextFormField(
                  maxLines: 3,
                  controller: keterangan,
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
                height: 30,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () async {
                    print(timestart.text + "  " + timeend.text);

                    var ts = timestart.text.substring(0, 2);
                    var te = timeend.text.substring(0, 2);

                    var count = int.parse(te) - int.parse(ts);
                    print(count.toString());

                    if (count < 20) {
                      WidgetSnackbar(
                          context: context,
                          message: "Overtime required 2 Hours+ ",
                          warna: "merah");
                    } else {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      var accesToken = pref.getString("PREF_TOKEN")!;
                      var idstaff = pref.getString("PREF_NIP")!;

                      _devService
                          .overtime(
                              accesToken,
                              idstaff,
                              tanggalLembur.text,
                              keterangan.text,
                              tanggalLembur.text,
                              timestart.text,
                              timeend.text)
                          .then((value) async {
                        var res = ReturnCheck.fromJson(json.decode(value));

                        if (res.statusJson == true) {
                          getData();
                        }
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: ColorsTheme.primary1,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Text(
                      "AJUKAN",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Container(
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
                child: Text("  History Overtime",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 250,
                child: ListView.builder(
                    itemCount: listovertime.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 26, right: 20, bottom: 10, top: 5),
                        child: card(listovertime[index]),
                      );
                    }),
              ),

              SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}

Widget card(Listovertime item) {
  // DateTime tempDate =
  //     DateFormat("yyyy-MM-dd hh:mm:ss").parse("2020-08-09 00:00:00");
  // String tanggal = DateFormat('dd').format(tempDate);
  // String hari = DateFormat('EEEE').format(tempDate);
  // String bulantahun = DateFormat('MM/yyyy').format(tempDate);
  // String wfhWfo = item.wfhWfo!.toUpperCase();
  // String datangPulang = item.datangPulang!.toUpperCase();
  // String tanggalAbsen = item.tanggalAbsen!;
  // String jamAbsen = item.jamAbsen!;

  return Center(
    child: Container(
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0x3f000000),
              blurRadius: 4,
              offset: Offset(1, 1),
            ),
          ],
          color: Color(0xfffafaff),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        "TANGGAL           :   " + item.tanggal,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xff4a4c4f))),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: Text(
                        "JAM IN                :  " + item.jamMulai,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xff4a4c4f))),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      child: Text(
                        "JAM OUT            :  " + item.jamAkhir,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ibmPlexSans(
                            textStyle: TextStyle(
                                fontSize: 12, color: Color(0xff4a4c4f))),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    (item.status.toString() == "null" ||
                            item.status.toString() == "0")
                        ? SizedBox(
                            child: Text(
                              "STATUS               :  " + "PENDING",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ibmPlexSans(
                                  textStyle: TextStyle(
                                      fontSize: 12, color: Colors.orange)),
                            ),
                          )
                        : SizedBox(
                            child: Text(
                              "STATUS               :  " + "ACCEPTED",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ibmPlexSans(
                                  textStyle: TextStyle(
                                      fontSize: 12, color: Colors.green)),
                            ),
                          )
                  ],
                ),
              ),
              // Container(
              //     height: 80,
              //     child: VerticalDivider(color: ColorsTheme.primary1)),
            ],
          ),
        )),
  );
}
