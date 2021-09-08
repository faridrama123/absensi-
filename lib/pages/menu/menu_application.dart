import 'dart:convert';

import 'package:absensi/api/erp.glomed.service.dart';
import 'package:absensi/api/service.dart';
import 'package:absensi/models/listabsen/return.dart';
import 'package:absensi/models/menu/cls_absen_hari_ini.dart';
import 'package:absensi/models/myleave/return.dart';
import 'package:absensi/models/return_check.dart';
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
  DevService _devService = DevService();

  late List<Listleave> listleave = [];
  Future getData() async {
    DateTime now = DateTime.now();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;

    _devService.myleave(accesToken).then((value) async {
      var res = ReturnMyLeave.fromJson(json.decode(value));

      if (res.statusJson == true) {
        print("my leave" + res.listleave.length.toString());

        setState(() {
          listleave = res.listleave;
          print(listleave.length);
        });
      }
    });
  }

  TextEditingController timestart = TextEditingController();
  TextEditingController timeend = TextEditingController();
  TextEditingController tanggalMulai = TextEditingController();
  TextEditingController tanggalAkhir = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  TextEditingController tipe = TextEditingController();

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
              SizedBox(
                height: 30,
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
                  controller: tipe,
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
                child: Text("Tanggal Mulai",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                child: TextFormField(
                  controller: tanggalMulai,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020, 1),
                      lastDate: DateTime(2021, 12),
                    ).then((pickedDate) {
                      print(pickedDate);

                      tanggalMulai.text =
                          convertDateTimeDisplay(pickedDate.toString());
                    });
                  },
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
                child: Text("Tanggal Akhir",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 30, right: 20),
                child: TextFormField(
                  controller: tanggalAkhir,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020, 1),
                      lastDate: DateTime(2021, 12),
                    ).then((pickedDate) {
                      print(pickedDate);

                      tanggalAkhir.text =
                          convertDateTimeDisplay(pickedDate.toString());
                    });
                  },
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
                child: Text("Jam Mulai",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
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
                child: Text("Jam Akhir",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              Container(
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
                height: 15,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    var accesToken = pref.getString("PREF_TOKEN")!;
                    var idstaff = pref.getString("PREF_NIP")!;

                    _devService
                        .leave(
                            accesToken,
                            idstaff,
                            tanggalMulai.text,
                            keterangan.text,
                            tipe.text,
                            tanggalMulai.text,
                            tanggalAkhir.text,
                            timestart.text,
                            timeend.text)
                        .then((value) async {
                      var res = ReturnCheck.fromJson(json.decode(value));

                      if (res.statusJson == true) {
                        getData();
                      }
                    });
                  },
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
              Container(
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
                child: Text("History Leave",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                    itemCount: listleave.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                              leading: Text(listleave[index].tanggal +
                                  "\n" +
                                  listleave[index].tipe),
                              trailing: (listleave[index].status.toString() ==
                                          "null" ||
                                      listleave[index].status.toString() == "0")
                                  ? Text(
                                      'pending',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 15),
                                    )
                                  : Text(
                                      'diterima',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 15),
                                    ),
                              title: Column(
                                children: [
                                  Text(
                                    "Mulai : " + listleave[index].mulai,
                                    style: GoogleFonts.ibmPlexSans(
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff4a4c4f))),
                                  ),
                                  Text(
                                    "Akhir : " + listleave[index].akhir,
                                    style: GoogleFonts.ibmPlexSans(
                                        textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff4a4c4f))),
                                  ),
                                ],
                              )),
                          Divider(color: Colors.grey)
                        ],
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
