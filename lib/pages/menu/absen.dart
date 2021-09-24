import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/api/facenet.service.dart';
import 'package:flutter_application_1/api/ml_kit_service.dart';
import 'package:flutter_application_1/api/service.dart';
import 'package:flutter_application_1/models/absen/post.dart';
import 'package:flutter_application_1/models/absen/return.dart';
import 'package:flutter_application_1/models/database.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_progress.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter_application_1/pages/menu/sign-in.dart';
import 'package:flutter_application_1/pages/menu/sign-up.dart';
import 'package:flutter_application_1/provider/provider.cabang.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:camera/camera.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:provider/provider.dart';
// import 'package:latlong/latlong.dart' as ll;
import 'package:shared_preferences/shared_preferences.dart';

class AbsenForm extends StatefulWidget {
  @override
  _AbsenState createState() => _AbsenState();
}

class _AbsenState extends State<AbsenForm> {
  DevService _devService = DevService();

  bool loading = true;
  bool failed = false;
  bool permissionLocation = false;
  double latitudeOffice = -6.2763419; //latitudeOffice
  double longitudeOffice = 107.0769743; //latitudeOffice
  bool loadingAlamat = true;
  String alamat = "Loading...";
  static LatLng centerPoint = LatLng(-6.175417, 106.827056);
  static double latitudeCurrent = centerPoint.latitude;
  static double longitudeCurrent = centerPoint.longitude;
  static final CameraPosition positionCenterPoint =
      CameraPosition(target: LatLng(latitudeCurrent, longitudeCurrent));
  CameraPosition _position = positionCenterPoint;
  Completer<GoogleMapController> _controller = Completer();
  double jarak = 0;
  double maxJarak = 1;
  String msgJarak =
      "Jarak lokasi anda melebih batas maksimal office, harap absensi diwilayah office";
  String inOut = "IN";
  String isWfh = "WFH";
  String? _timeString;
  Absen dataAbsen = new Absen();

  //
  bool locationInside = false;
  final Set<Polygon> _polygons = HashSet<Polygon>();

  List<LatLng> globalPolygonCoords = [];

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Absensi System',
    );
    var result = await permissionValidator.location();
    if (result) {
      permissionLocation = true;
    } else {
      permissionLocation = false;
    }
    setState(() {
      permissionLocation = permissionLocation;
    });
  }

  getAddressFromLatLng(CameraPosition currentPosition) async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          currentPosition.target.latitude, currentPosition.target.longitude);

      Placemark place = p[0];
      String alamatTemp =
          "${place.thoroughfare} ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";

      if (mounted) {
        setState(() {
          loadingAlamat = false;
          alamat = alamatTemp;
          latitudeCurrent = currentPosition.target.latitude;
          longitudeCurrent = currentPosition.target.longitude;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    CameraPosition currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 17);
    _goPosition(currentPosition);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));

    setState(() {
      centerPoint = LatLng(position.latitude, position.longitude);
      latitudeCurrent = position.latitude;
      longitudeCurrent = position.longitude;
    });

    List<LatLng> polygonCoords = globalPolygonCoords;
    Polygon polygonSet =
        new Polygon(polygonId: PolygonId('PolygonId'), points: polygonCoords);

    _checkLocationInPolygon(currentPosition.target, polygonSet);
  }

  Future<void> _goPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  updateCameraPosition(CameraPosition position) {
    setState(() {
      loadingAlamat = true;
      alamat = "Loading...";
      _position = position;
      latitudeCurrent = position.target.latitude;
      longitudeCurrent = position.target.longitude;
      jarak = _countDistance();
      centerPoint = LatLng(position.target.latitude, position.target.longitude);
    });
  }

  double _countDistance() {
    var distance = ll.Distance();
    return distance.as(
        ll.LengthUnit.Meter,
        ll.LatLng(latitudeOffice, longitudeOffice),
        ll.LatLng(latitudeCurrent, longitudeCurrent));
  }

  backToHome() {
    Navigator.of(context).pop();
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      maxJarak = double.parse(pref.getString("PREF_JARAK")!);

      latitudeOffice = double.parse(pref.getString("PREF_LATITUDE")!);

      /// -6.2694281; //latitudeOffice
      longitudeOffice = double.parse(
          pref.getString("PREF_LONGITUDE")!); //106.8135298; //latitudeOffice
      loading = false;
      failed = true;

      print("latitude " +
          latitudeOffice.toString() +
          " longitude " +
          longitudeOffice.toString() +
          " jarak " +
          jarak.toString());
    });
  }

  getTime() {
    DateTime now = DateTime.now();
    String jam = DateFormat('H').format(now);
    setState(() {
      if (int.parse(jam) > 12) {
        inOut = "OUT";
      } else {
        inOut = "IN";
      }
    });
  }

  displayDialog(BuildContext context, String msg, bool navigate) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Informasi')),
            content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  Center(child: Text(msg))
                ]),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.05, right: Get.width * 0.05, bottom: 8),
                child: Container(
                  width: Get.width * 1,
                  child: SizedBox(
                    height: Get.height * 0.045,
                    child: RaisedButton(
                      onPressed: () {
                        navigate
                            ? Navigator.of(context).pushReplacement(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainMenu(),
                                    fullscreenDialog: true))
                            : Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: ColorsTheme.primary1,
                      child: Text(
                        "TUTUP",
                        style: TextStyle(
                            color: Colors.white, fontSize: Get.width * 0.04),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted)
      setState(() {
        _timeString = formattedDateTime;
      });
  }

  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();
  late CameraDescription cameraDescription;
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

  Future submitAbsen(BuildContext context) async {
    print("locationInside :" + locationInside.toString());
    if (locationInside == false) return false;

    final DateTime now = DateTime.now();
    String tanggal = DateFormat('yyyy-MM-dd').format(now);
    String jam = DateFormat('HH:mm:ss').format(now);
    SharedPreferences pref = await SharedPreferences.getInstance();
    dataAbsen.iduser = pref.getString("PREF_ID_USER")!;
    dataAbsen.tipeAbsen = "1";
    dataAbsen.datangPulang = inOut.toLowerCase();
    dataAbsen.tanggalAbsen = tanggal;
    dataAbsen.jamAbsen = jam;
    dataAbsen.lokasi = alamat;
    dataAbsen.latitude = latitudeCurrent.toString();
    dataAbsen.longitude = longitudeCurrent.toString();
    dataAbsen.wfhWfo = isWfh.toLowerCase();

    String usingFace = pref.getString("PREF_FACE_ANDROID")!;

    print("usingFace : " + usingFace);

    if (usingFace == "true") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SignIn(cameraDescription: cameraDescription, absen: dataAbsen),
        ),
      );
    } else {
      PostAbsen postAbsen = new PostAbsen();
      postAbsen.tipe_absen = dataAbsen.tipeAbsen;

      postAbsen.datang_pulang = dataAbsen.datangPulang;
      postAbsen.wfh_wfo = dataAbsen.wfhWfo;
      postAbsen.tanggal_absen = dataAbsen.tanggalAbsen;

      postAbsen.jam_absen = dataAbsen.jamAbsen;

      postAbsen.lokasi = dataAbsen.lokasi;

      postAbsen.latitude = dataAbsen.latitude;

      postAbsen.longitude = dataAbsen.longitude;
      postAbsen.keterangan = dataAbsen.keterangan;

      _devService
          .absen(pref.getString("PREF_TOKEN")!, postAbsen)
          .then((value) async {
        var res = ReturnAbsen.fromJson(json.decode(value));

        if (res.status_json == true) {
          displayDialog(context, res.remarks!, true);
        } else {
          WidgetSnackbar(
              context: context, message: res.remarks, warna: "merah");
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    _permissionRequest();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    getUserLocation();
    getTime();
    startUp();
  }

  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    var providerCabang = Provider.of<ProviderCabang>(context);

    providerCabang.cabangClick;

    String? polygon = providerCabang
        .returnCabang.listcabang![providerCabang.cabangClick]?.polygon;

    List latlong = polygon!.split('#');

    List<LatLng> hehe = [];

    if (isDone == false) {
      for (var i in latlong) {
        int index = i.indexOf(",");
        String lat = i.substring(0, index).trim();
        String lng = i.substring(index + 1).trim();
        double lati = double.parse(lat);
        double lngi = double.parse(lng);
        // print(lati + lngi);

        hehe.add(LatLng(lati, lngi));

        print(hehe);
        print("index" + index.toString() + latlong.length.toString());
        if (hehe.length == latlong.length) {
          setState(() {
            globalPolygonCoords = hehe;

            isDone = true;
          });
        }
      }
    }

    // print(isWfh);

    Set<Polygon> myPolygon() {
      List<LatLng> polygonCoords = hehe;
      // for (var i in polygonCoords) {

      //   polygonCoords.add(LatLng(i.latitude, i.longitude));
      // }

      //  print(polygonCoords);

      _polygons
          .removeWhere((polygon) => polygon.polygonId.value == 'user_polygon');
      _polygons.add(
        Polygon(
          polygonId: PolygonId('user_polygon'),
          points: polygonCoords,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.4),
        ),
      );
      return _polygons;
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: Get.width * 1,
            height: Get.height * 1,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: centerPoint,
                zoom: 17.5,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              scrollGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              onCameraIdle: () {
                getAddressFromLatLng(_position);
              },
              polygons: myPolygon(),
              onCameraMove: updateCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                new Factory<OneSequenceGestureRecognizer>(
                  () => new EagerGestureRecognizer(),
                ),
              ].toSet(),
            ),
          ),
          // Align(
          //     alignment: Alignment.center,
          //     child: Container(
          //         width: Get.width * 0.12,
          //         child: Image.asset("assets/images/pin.png"))),
          InkWell(
            onTap: () {
              backToHome();
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.05, left: Get.width * 0.03),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      backToHome();
                    },
                    child: CircleAvatar(
                      radius: Get.width * 0.05,
                      backgroundColor: ColorsTheme.background3,
                      child: Icon(
                        Icons.arrow_back,
                        color: ColorsTheme.primary1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  InkWell(
                    onTap: () {
                      getUserLocation();
                    },
                    child: CircleAvatar(
                      radius: Get.width * 0.05,
                      backgroundColor: ColorsTheme.background3,
                      child: Icon(
                        Icons.autorenew,
                        color: ColorsTheme.primary1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        inOut = inOut == "IN" ? "OUT" : "IN";
                      });
                    },
                    child: CircleAvatar(
                      radius: Get.width * 0.05,
                      backgroundColor: inOut == "IN"
                          ? ColorsTheme.primary2
                          : ColorsTheme.background3,
                      child: Text(
                        inOut == "IN" ? "OUT" : "IN",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       isWfh = isWfh == "WFH" ? "WFO" : "WFH";
                  //     });
                  //   },
                  //   child: CircleAvatar(
                  //     radius: Get.width * 0.05,
                  //     backgroundColor: isWfh == "WFH"
                  //         ? ColorsTheme.primary2
                  //         : ColorsTheme.background3,
                  //     child: Text(
                  //       isWfh == "WFH" ? "WFO" : "WFH",
                  //       style: TextStyle(
                  //           fontSize: 12, fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              width: Get.width * 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 16),
                  Text(
                    isWfh + " - " + inOut,
                    style: TextStyle(
                        fontFamily: 'BalsamiqSans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _timeString!,
                    style: TextStyle(
                        fontFamily: 'BalsamiqSans',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Get.width * 0.05, right: Get.width * 0.05),
                    child: Container(
                      child: Text(
                        loadingAlamat ? "Loading..." : alamat,
                        style:
                            TextStyle(fontFamily: 'BalsamiqSans', fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       left: Get.width * 0.025, right: Get.width * 0.025),
                  //   child: Container(
                  //     child: Text(
                  //       "Jarak kantor dari lokasi anda saat ini " +
                  //           jarak.toString() +
                  //           " Meter",
                  //       style: TextStyle(
                  //           fontFamily: 'BalsamiqSans',
                  //           fontSize: 12,
                  //           color: ColorsTheme.merah),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Get.width * 0.025, right: Get.width * 0.025),
                    child: Container(
                      width: Get.width,
                      child: SizedBox(
                        height: Get.height * 0.045,
                        child: RaisedButton(
                          onPressed: () {
                            if (isWfh == "WFH") {
                              if (loadingAlamat) {
                                displayDialog(
                                    context,
                                    "Mohon tunggu sampai loading alamat selesai.",
                                    false);
                              } else {
                                submitAbsen(context);
                              }
                            }

                            //  else {

                            //   if (jarak > maxJarak) {
                            //     displayDialog(
                            //         context,
                            //         msgJarak +
                            //             " dalam " +
                            //             maxJarak.toString() +
                            //             " meter",
                            //         false);
                            //   } else {
                            //     if (loadingAlamat) {
                            //       displayDialog(
                            //           context,
                            //           "Mohon tunggu sampai loading alamat selesai.",
                            //           false);
                            //     } else {
                            //       submitAbsen(context);
                            //     }
                            //   }
                            // }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: ColorsTheme.primary1,
                          child: Text(
                            "ABSEN SEKARANG",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.width * 0.03),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _checkLocationInPolygon(LatLng position, Polygon polygon) {
    bool trueFalse;
    var vertexPosition = polygon.points.firstWhere((point) => point == position,
        orElse: () => LatLng(-0.0, 0.0));
    if (vertexPosition != null) {
      trueFalse = true;
    }

    // Check if the point is inside the polygon or on the boundary
    int intersections = 0;
    var verticesCount = polygon.points.length;

    for (int i = 1; i < verticesCount; i++) {
      LatLng vertex1 = polygon.points[i - 1];
      LatLng vertex2 = polygon.points[i];

      // Check if point is on an horizontal polygon boundary
      if (vertex1.latitude == vertex2.latitude &&
          vertex1.latitude == position.latitude &&
          position.longitude > min(vertex1.longitude, vertex2.longitude) &&
          position.longitude < max(vertex1.longitude, vertex2.longitude)) {
        return true;
      }

      if (position.latitude > min(vertex1.latitude, vertex2.latitude) &&
          position.latitude <= max(vertex1.latitude, vertex2.latitude) &&
          position.longitude <= max(vertex1.longitude, vertex2.longitude) &&
          vertex1.latitude != vertex2.latitude) {
        var xinters = (position.latitude - vertex1.latitude) *
                (vertex2.longitude - vertex1.longitude) /
                (vertex2.latitude - vertex1.latitude) +
            vertex1.longitude;
        if (xinters == position.longitude) {
          // Check if point is on the polygon boundary (other than horizontal)
          return true;
        }
        if (vertex1.longitude == vertex2.longitude ||
            position.longitude <= xinters) {
          intersections++;
        }
      }
    }
    trueFalse = intersections % 2 != 0;

    setState(() {
      locationInside = trueFalse;
    });
  }
}
