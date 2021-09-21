import 'dart:convert';

import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/api/facenet.service.dart';
import 'package:flutter_application_1/api/ml_kit_service.dart';
import 'package:flutter_application_1/api/service.dart';
import 'package:flutter_application_1/models/absenhari/return.dart';
import 'package:flutter_application_1/models/database.dart';
import 'package:flutter_application_1/models/listabsen/return.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_error.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_loading_page.dart';
import 'package:flutter_application_1/pages/menu/absen.dart';
import 'package:flutter_application_1/pages/menu/menu_cabang.dart';
import 'package:flutter_application_1/pages/menu/sign-up.dart';
import 'package:flutter_application_1/pages/menu/test.dart';
import 'package:flutter_application_1/provider/provider.cabang.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuHome extends StatefulWidget {
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  bool? loading;
  bool? failed;
  String? remakrs;
  String? nama;
  String? departemen;
  String? posisi;
  String? nip;
  String? hari;
  String? tanggal;
  String? bulantahun;
  ReturnAbsenHariAbsen_in? absenIn;
  ReturnAbsenHariAbsen_out? absenOut;

  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  DevService _devService = DevService();

  late CameraDescription cameraDescription;
  var faceData;
  List<Absen> dataAbsen = [];
  String hariKalender = "0";
  String hadir = "0";
  String sakit = "0";
  String cuti = "0";
  String efektif = "0";
  String harioff = "0";
  String izin = "0";
  String tugas = "0";
  String mangkir = "0";
  String count = "0.0";
  String bulan = "Januari";
  String tahun = "2021";

  Future getData() async {
    startUp();
    setState(() {
      loading = true;
      failed = false;
    });
    DateTime now = DateTime.now();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accesToken = pref.getString("PREF_TOKEN")!;
    faceData = pref.getString("PREF_FACE")!;
    // print("faceData" + faceData.toString());

    print(pref.getString("PREF_TOKEN")!);
    _devService.absenhariini(accesToken).then((value) async {
      var res = ReturnAbsenHari.fromJson(json.decode(value));

      if (res.status_json == true) {
        hari = res.hari;
        tanggal = res.tanggal;
        bulantahun = res.bulantahun;
        absenIn = res.absen_in;
        absenOut = res.absen_out;
        nama = pref.getString("PREF_NAMA")!;
        departemen = pref.getString("PREF_DEPARTEMEN")!;
        posisi = pref.getString("PREF_POSISI")!;
        nip = pref.getString("PREF_NIP")!;

        String latitude = pref.getString("PREF_LATITUDE")!;

        String longitude = pref.getString("PREF_LONGITUDE")!;
        String jarak = pref.getString("PREF_JARAK")!;

        print("latitude " +
            latitude +
            " longitude " +
            longitude +
            " jarak " +
            jarak);

        setState(() {
          loading = false;
          failed = false;
        });
      } else {
        setState(() {
          loading = false;
          failed = true;
          remakrs = res.remarks;
        });
      }
      print(res.hari);
    });

    _devService.listabsen(accesToken).then((value) async {
      var res = ReturnListAbsen.fromJson(json.decode(value));
      if (res.status_json == true) {
        final now = new DateTime.now();
        String day = DateFormat('d').format(now);
        String month = DateFormat('M').format(now);
        String year = DateFormat('y').format(now);

        print(" day : " + day + " month " + month + " year " + year);

        tahun = year;

        if (month == "1") {
          bulan = "Januari";
        }
        if (month == "2") {
          bulan = "Februari";
        }
        if (month == "3") {
          bulan = "Maret";
        }
        if (month == "4") {
          bulan = "April";
        }
        if (month == "5") {
          bulan = "Mei";
        }
        if (month == "6") {
          bulan = "Juni";
        }
        if (month == "7") {
          bulan = "Juli";
        }
        if (month == "8") {
          bulan = "Agustus";
        }
        if (month == "9") {
          bulan = "September";
        }
        if (month == "10") {
          bulan = "Oktober";
        }
        if (month == "11") {
          bulan = "November";
        }
        if (month == "12") {
          bulan = "Desember";
        }

        int hadir_ = 0;

        res.listabsen?.forEach((val) {
          DateTime parseDate = DateTime.parse(val?.tanggal_absen ?? "");
          String formatMonth = DateFormat('M').format(parseDate);

          if (month == formatMonth && val?.datang_pulang == "in") {
            hadir_ = hadir_ + 1;
            print(hadir_);
          }
        });

        setState(() {
          hariKalender = day;
          hadir = hadir_.toString();

          double kehadiran =
              double.parse(hadir) / double.parse(hariKalender) * 100;

          print("kehadiran " + kehadiran.toString());

          count = kehadiran.toString().substring(0, 4);
        });
      }
    });
  }

  void startUp() async {
    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    _mlKitService.initialize();
  }

  Widget online() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 51,
              height: 16,
              child: Text(
                "Online",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xff171111),
                  fontSize: 14,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            SizedBox(width: 7),
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff08cc04),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile() {
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xffd6d2d2),
                    width: 1,
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Container(
                child: Text(
                  "Hi, " + nama!,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xff171111),
                    fontSize: 20,
                    fontFamily: "Sansation Light",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Container(
              child: Text(
                nip!,
                style: TextStyle(
                  color: Color(0xff171111),
                  fontSize: 16,
                  fontFamily: "Sansation Light",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 4),
          //   child: Container(
          //     child: Text(
          //       posisi!,
          //       style: TextStyle(
          //         color: Color(0xff171111),
          //         fontSize: 14,
          //         fontFamily: "Sansation Light",
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 4),
          //   child: Container(
          //     child: Text(
          //       "Dept : " + departemen!,
          //       style: TextStyle(
          //         color: Color(0xff171111),
          //         fontSize: 14,
          //         fontFamily: "Sansation Light",
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget thismonth(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.40),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hariKalender,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Hari Kalender",
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hadir,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Hadir", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Sakit", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Cuti", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  " Efektif",
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Hari Off", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Izin", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Tugas", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          height: 60,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Mangkir", style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: CustomPaint(
                            painter: CirclePainter(),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(count,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black)),
                                Text(" %"),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Card(
                                color: Colors.red,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      bulan + " " + tahun,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cardAbsenHariIni() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.2),
      child: Center(
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              width: Get.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3f000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(
                              hari!.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff171111),
                                fontSize: 14,
                                fontFamily: "Sansation Light",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.50),
                          Text(
                            tanggal!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontFamily: "Sansation Light",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 1.50),
                          SizedBox(
                            width: 81,
                            height: 21,
                            child: Text(
                              bulantahun!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff171111),
                                fontSize: 14,
                                fontFamily: "Sansation Light",
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 80,
                        child: VerticalDivider(color: ColorsTheme.primary1)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "IN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff171111),
                                      fontSize: 30,
                                      fontFamily: "Sansation Light",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                absenIn == null
                                    ? Container()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              absenIn!.tanggal_absen == null
                                                  ? "-"
                                                  : absenIn!.tanggal_absen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 12,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          SizedBox(
                                            child: Text(
                                              absenIn!.jam_absen == null
                                                  ? "-"
                                                  : absenIn!.jam_absen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 14,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "OUT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xff171111),
                                      fontSize: 30,
                                      fontFamily: "Sansation Light",
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                absenOut == null
                                    ? Container()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            child: Text(
                                              absenOut!.tanggal_absen == null
                                                  ? "-"
                                                  : absenOut!.tanggal_absen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 12,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          SizedBox(
                                            child: Text(
                                              absenOut!.jam_absen == null
                                                  ? "-"
                                                  : absenOut!.jam_absen!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color(0xff171111),
                                                fontSize: 14,
                                                fontFamily: "Sansation Light",
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget cardFaceData() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.30),
      child: Center(
        child: Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignUp(
                      cameraDescription: cameraDescription,
                    ),
                  ),
                );
              },
              child: Container(
                width: Get.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: Colors.red,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      "Data wajah anda belum di daftarkan\nDaftarkan Sekarang!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget runningClock() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.5),
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          String jam = DateFormat('HH').format(DateTime.now());
          String menit = DateFormat('mm').format(DateTime.now());
          String detik = DateFormat('ss').format(DateTime.now());

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      jam,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      menit,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      detik,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _modalBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (builder) {
          return Consumer<ProviderCabang>(builder: (context, provider, _) {
            return Container(
              height: Get.height * 0.3,
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.black12,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/wfo.png"),
                                          fit: BoxFit.cover),
                                    )),
                                SizedBox(height: 4),
                                Text(
                                  "WFO",
                                  style: TextStyle(
                                    color: Color(0xff171111),
                                    fontSize: 20,
                                    fontFamily: "Sansation Light",
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            onTap: () async {
                              await provider.fetchHistory;

                              var results = provider.returnCabang;

                              if (results != null) {
                                //    print(results);
                                goToCabangOption();
                              } else {
                                print("data null");
                              }

                              //  goToAbsenForm("WFO");
                            }),
                        // GestureDetector(
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         Container(
                        //             width: 120,
                        //             height: 120,
                        //             decoration: BoxDecoration(
                        //               borderRadius: BorderRadius.circular(10.0),
                        //               color: Colors.black12,
                        //               image: DecorationImage(
                        //                   image:
                        //                       AssetImage("assets/images/wfh.png"),
                        //                   fit: BoxFit.cover),
                        //             )),
                        //         SizedBox(height: 4),
                        //         Text(
                        //           "WFH",
                        //           style: TextStyle(
                        //             color: Color(0xff171111),
                        //             fontSize: 20,
                        //             fontFamily: "Sansation Light",
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //     onTap: () {
                        //       goToAbsenForm("WFH");
                        //     }),
                      ],
                    ),
                  )),
            );
          });
        });
  }

  void goToAbsenForm(String param) {
    Get.to(AbsenForm());
    //  Get.to(MyHomePage123());
  }

  void goToCabangOption() {
    //  Get.to(AbsenForm());

    showMaterialModalBottomSheet(
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PageCabang(
        reverse: false,
      ),
    );
    //  Get.to(MyHomePage123());
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return loading!
        ? WidgetLoadingPage()
        : failed!
            ? WidgetErrorConnection(
                onRetry: () {
                  setState(() {
                    getData();
                  });
                },
                remarks: remakrs)
            : RefreshIndicator(
                onRefresh: () => getData(),
                child: Scaffold(
                  body: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: Get.width * 1,
                          height: 219,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xffbefffb), Color(0x00fce9a8)],
                            ),
                          ),
                        ),
                        online(),
                        profile(),
                        cardAbsenHariIni(),

                        thismonth(context),
                        if (faceData.toString().length < 5) cardFaceData(),
                        //cardFaceData(),

                        // runningClock(),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.8),
                            child: RaisedButton(
                              onPressed: () {
                                _modalBottomSheet();
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: ColorsTheme.primary1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "ABSEN SEKARANG",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
  }
}

/// Draws a circle if placed into a square widget.
class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.grey.withOpacity(0.4)
    ..strokeWidth = 5
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
