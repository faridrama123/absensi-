// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_application_1/api/camera.service.dart';
import 'package:flutter_application_1/api/erp.glomed.service.dart';
import 'package:flutter_application_1/api/face.service.dart';
import 'package:flutter_application_1/api/facenet.service.dart';
import 'package:flutter_application_1/api/ml_kit_service.dart';
import 'package:flutter_application_1/models/absen/post.dart';
import 'package:flutter_application_1/models/absen/return.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/models/return_check.dart';
import 'package:flutter_application_1/models/return_face_data.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter_application_1/pages/widgets/FacePainter.dart';
import 'package:flutter_application_1/pages/widgets/auth-action-button.dart';
import 'package:flutter_application_1/pages/widgets/camera_header.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final CameraDescription cameraDescription;
  final Absen absen;

  const SignIn({Key? key, required this.cameraDescription, required this.absen})
      : super(key: key);

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  /// Service injection
  CameraService _cameraService = CameraService();
  // MLKitService _mlKitService = MLKitService();
  // FaceNetService _faceNetService = FaceNetService();
  DevService _devService = DevService();

  Future? _initializeControllerFuture;

  bool cameraInitializated = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;
  bool postFace = false;

  String imagePath = "";
  Size? imageSize;
  // Face? faceDetected;

  @override
  void initState() {
    super.initState();

    /// starts the camera & start framing faces
    _start();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  /// starts the camera & start framing faces
  _start() async {
    _initializeControllerFuture =
        _cameraService.startService(widget.cameraDescription);
    await _initializeControllerFuture;

    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

  //start stream and draws rectangles when detects faces
  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        // if its currently busy, avoids overprocessing
        if (_detectingFaces) return;

        _detectingFaces = true;

        try {
          _detectingFaces = false;
        } catch (e) {
          print(e);
          _detectingFaces = false;
        }
      }
    });
  }

  /// draws rectangles when detects faces
  // _frameFaces() {
  //   print("_frameFaces");
  //   imageSize = _cameraService.getImageSize();

  //   print("imageSize : " + imageSize.toString());

  //   _cameraService.cameraController.startImageStream((image) async {
  //     if (_cameraService.cameraController != null) {
  //       // if its currently busy, avoids overprocessing
  //       if (_detectingFaces) return;

  //       _detectingFaces = true;

  //       try {
  //         List<Face> faces = await _mlKitService.getFacesFromImage(image);
  //         print(faces.toString());

  //         if (faces.length > 0) {
  //           if (faces.length > 0) {
  //             // preprocessing the image
  //             setState(() {
  //               faceDetected = faces[0];
  //             });

  //             if (_saving) {
  //               _saving = false;
  //               _faceNetService.setCurrentPrediction(image, faceDetected!);
  //             }
  //           } else {
  //             setState(() {
  //               faceDetected = null;
  //             });
  //           }
  //         }

  //         _detectingFaces = false;
  //       } catch (e) {
  //         print(e);
  //         _detectingFaces = false;
  //       }
  //     }
  //   });
  // }

  /// handles the button pressed event
  Future<bool> onShot_() async {
    try {
      bool result = false;
      print("===========onShot_=============");

      await _cameraService.cameraController.stopImageStream();
      await Future.delayed(Duration(milliseconds: 200));
      XFile file = await _cameraService.takePicture();

      setState(() {
        print("_bottomSheetVisible");
        _bottomSheetVisible = true;
        pictureTaked = true;
        imagePath = file.path;
      });
      print("===========================");
      print(imagePath);

      FaceService faceService = new FaceService();
      SharedPreferences pref = await SharedPreferences.getInstance();
      var idUser = pref.getString("PREF_ID_USER")!;
      print("idUser " + idUser);

      var post = await faceService.checkFace(imagePath, idUser).then((value) {
        ReturnFaceData returnFaceData = value;
        result = returnFaceData.status ?? false;
        print(returnFaceData.status);
      });

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> absenNow() async {
    bool result = false;

    PostAbsen postAbsen = new PostAbsen();
    postAbsen.tipe_absen = widget.absen.tipeAbsen;

    postAbsen.datang_pulang = widget.absen.datangPulang;
    postAbsen.wfh_wfo = widget.absen.wfhWfo;
    postAbsen.tanggal_absen = widget.absen.tanggalAbsen;

    postAbsen.jam_absen = widget.absen.jamAbsen;

    postAbsen.lokasi = widget.absen.lokasi;

    postAbsen.latitude = widget.absen.latitude;

    postAbsen.longitude = widget.absen.longitude;
    postAbsen.keterangan = widget.absen.keterangan;

    SharedPreferences pref = await SharedPreferences.getInstance();

    var absen = await _devService
        .absen(pref.getString("PREF_TOKEN")!, postAbsen)
        .then((value) async {
      var res = ReturnAbsen.fromJson(json.decode(value));

      if (res.status_json == true) {
        result = true;
      } else {
        result = false;
      }
    });

    return result;
  }

  // /// handles the button pressed event
  // Future<bool> onShot() async {
  //   if (faceDetected == null) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text('No face detected!'),
  //         );
  //       },
  //     );

  //     return false;
  //   } else {
  //     _saving = true;

  //     await Future.delayed(Duration(milliseconds: 500));
  //     await _cameraService.cameraController.stopImageStream();
  //     await Future.delayed(Duration(milliseconds: 200));
  //     XFile file = await _cameraService.takePicture();

  //     setState(() {
  //       print("_bottomSheetVisible");
  //       _bottomSheetVisible = true;
  //       pictureTaked = true;
  //       imagePath = file.path;
  //     });
  //     print("===========================");
  //     print(imagePath);

  //     return true;
  //   }
  // }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      cameraInitializated = false;
      pictureTaked = false;
    });
    this._start();
  }

  @override
  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (pictureTaked) {
                    return Container(
                      width: width,
                      height: height,
                      child: Transform(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.file(File(imagePath)),
                          ),
                          transform: Matrix4.rotationY(mirror)),
                    );
                  } else {
                    return Transform.scale(
                      scale: 1.0,
                      child: AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: width,
                              height: width *
                                  _cameraService
                                      .cameraController.value.aspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  CameraPreview(
                                      _cameraService.cameraController),
                                  // if (faceDetected != null)
                                  //   CustomPaint(
                                  //     painter: FacePainter(
                                  //         face: faceDetected!,
                                  //         imageSize: imageSize!),
                                  //   )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          CameraHeader(
            "VALIDASI WAJAH",
            onBackPressed: _onBackPressed,
          ),
          if (postFace == true)
            Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !_bottomSheetVisible
          ? GestureDetector(
              onTap: () async {
                setState(() {
                  postFace = true;
                });

                var result = await onShot_();

                // 1. jika wajah di db cocok / hasil shot merupakan real face
                if (result.toString() == "true") {
                  // 2. lakukan absen
                  var postAbsen = await absenNow();

                  if (postAbsen.toString() == "true") {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainMenu()),
                        (Route<dynamic> route) => false);
                    WidgetSnackbar(
                        context: context,
                        message: "Absen berhasil",
                        warna: "hijau");
                  } else {
                    _reload();
                    WidgetSnackbar(
                        context: context,
                        message: "Absen gagal",
                        warna: "hijau");
                  }
                } else {
                  _reload();
                  WidgetSnackbar(
                      context: context,
                      message: "Data tidak sesuai",
                      warna: "merah");
                }

                setState(() {
                  postFace = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0))),
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            )
          : Container(),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: !_bottomSheetVisible
      //     ? AuthActionButton(_initializeControllerFuture!,
      //         onPressed: onShot,
      //         isLogin: true,
      //         reload: _reload,
      //         absen: widget.absen)
      //     : Container(),
    );
  }
}
