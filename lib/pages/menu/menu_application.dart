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
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as Io;

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

  // String? _fileName;
  // List<PlatformFile>? _paths;
  // String? _directoryPath;
  // String? _extension;
  // bool _loadingPath = false;
  // bool _multiPick = false;
  // FileType _pickingType = FileType.custom;
  // TextEditingController _controller = TextEditingController();

  // void _openFileExplorer() async {
  //   setState(() => _loadingPath = true);
  //   try {
  //     _directoryPath = null;
  //     _paths = (await FilePicker.platform.pickFiles(
  //       type: _pickingType,
  //       allowMultiple: _multiPick,
  //       onFileLoading: (FilePickerStatus status) => print(status),
  //       allowedExtensions: ['pdf'],
  //     ))
  //         ?.files;

  //     final path = _paths!.map((e) => e.path).toList()[0].toString();
  //     final bytes = Io.File(path).readAsBytesSync();

  //     String img64 = base64Encode(bytes);
  //     print(img64.substring(0, 100));
  //   } on PlatformException catch (e) {
  //     print("Unsupported operation" + e.toString());
  //   } catch (ex) {
  //     print(ex);
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _loadingPath = false;
  //     _fileName =
  //         _paths != null ? _paths!.map((e) => e.name).toString() : '...';
  //   });
  // }

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
                child: Text("Jam Akhir",
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
                height: 15,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5, left: 35, top: 20),
                child: Text("File tambahan",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, letterSpacing: 0)),
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
                      return Padding(
                        padding: const EdgeInsets.only(left: 25, right: 15),
                        child: card(listleave[index]),
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

Widget card(Listleave item) {
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
    child: Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
            padding: const EdgeInsets.all(14.0),
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
                          "TITLE                               :   " +
                              item.tipe,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff171111),
                            fontSize: 11,
                            fontFamily: "Sansation Light",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: Text(
                          "TANGGAL MULAI          :   " + item.mulai,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff171111),
                            fontSize: 11,
                            fontFamily: "Sansation Light",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: Text(
                          "TANGGAL AKHIR          :   " + item.akhir,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff171111),
                            fontSize: 11,
                            fontFamily: "Sansation Light",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: Text(
                          "JAM IN                            :  " +
                              item.jamMulai,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff171111),
                            fontSize: 11,
                            fontFamily: "Sansation Light",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: Text(
                          "JAM OUT                        :  " + item.jamAkhir,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff171111),
                            fontSize: 11,
                            fontFamily: "Sansation Light",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text(
                      //   "KET                      :  " + item.ket,
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Color(0xff171111),
                      //     fontSize: 14,
                      //     fontFamily: "Sansation Light",
                      //     fontWeight: FontWeight.w300,
                      //   ),
                      // ),

                      SizedBox(
                        height: 5,
                      ),
                      (item.status.toString() == "null" ||
                              item.status.toString() == "0")
                          ? SizedBox(
                              child: Text(
                                "STATUS                          :  " +
                                    "PENDING",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 11,
                                  fontFamily: "Sansation Light",
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          : SizedBox(
                              child: Text(
                                "STATUS              :  " + "ACCEPTED",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 11,
                                  fontFamily: "Sansation Light",
                                  fontWeight: FontWeight.w400,
                                ),
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
    ),
  );
}
