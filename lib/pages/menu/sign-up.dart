import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_application_1/api/camera.service.dart';
import 'package:flutter_application_1/api/face.service.dart';
import 'package:flutter_application_1/api/facenet.service.dart';
import 'package:flutter_application_1/api/ml_kit_service.dart';
import 'package:flutter_application_1/models/menu/cls_absen_hari_ini.dart';
import 'package:flutter_application_1/models/return_face_data.dart';
import 'package:flutter_application_1/pages/general_widget.dart/widget_snackbar.dart';
import 'package:flutter_application_1/pages/main_menu.dart';
import 'package:flutter_application_1/pages/widgets/FacePainter.dart';
import 'package:flutter_application_1/pages/widgets/auth-action-button.dart';
import 'package:flutter_application_1/pages/widgets/camera_header.dart';
import 'package:camera/camera.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  final CameraDescription cameraDescription;

  const SignUp({Key? key, required this.cameraDescription}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  String imagePath = "";
  // Face? faceDetected;
  Size? imageSize;
  bool postFace = false;
  bool _detectingFaces = false;
  bool pictureTaked = false;

  Future? get initializeControllerFuture =>
      _initializeControllerFuture; // home_viewmodel.dart 25

  late CameraController _controller;

  Future? _initializeControllerFuture;
  bool cameraInitializated = false;

  // switchs when the user press the camera
  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  // MLKitService _mlKitService = MLKitService();
  CameraService _cameraService = CameraService();
  // FaceNetService _faceNetService = FaceNetService();

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
    print(
        "_initializeControllerFuture" + _initializeControllerFuture.toString());
    setState(() {
      cameraInitializated = true;
    });

    _frameFaces();
  }

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

      var post = await faceService.postFace(imagePath, idUser).then((value) {
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
  //     imagePath = file.path;
  //     print(imagePath.toString());
  //     setState(() {
  //       _bottomSheetVisible = true;
  //       pictureTaked = true;
  //     });

  //     return true;
  //   }
  // }

  // /// draws rectangles when detects faces
  // _frameFaces() {
  //   imageSize = _cameraService.getImageSize();

  //   _cameraService.cameraController.startImageStream((image) async {
  //     // ignore: unnecessary_null_comparison
  //     if (_cameraService.cameraController != null) {
  //       // if its currently busy, avoids overprocessing
  //       if (_detectingFaces) return;

  //       _detectingFaces = true;

  //       try {
  //         List<Face> faces = await _mlKitService.getFacesFromImage(image);

  //         if (faces.length > 0) {
  //           setState(() {
  //             faceDetected = faces[0];
  //           });

  //           if (_saving) {
  //             print("============+_saving+==============");
  //             _faceNetService.setCurrentPrediction(image, faceDetected!);
  //             setState(() {
  //               _saving = false;
  //             });
  //           }
  //         } else {
  //           setState(() {
  //             faceDetected = null;
  //           });
  //         }

  //         _detectingFaces = false;
  //       } catch (e) {
  //         _detectingFaces = false;
  //       }
  //     }
  //   });
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
              future: initializeControllerFuture,
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
                    return //Container();
                        Transform.scale(
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
                                  //   ),
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
              },
            ),
            CameraHeader(
              "REGISTER WAJAH",
              onBackPressed: _onBackPressed,
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
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MainMenu()),
                        (Route<dynamic> route) => false);
                    WidgetSnackbar(
                        context: context,
                        message: "Registrasi wajah berhasil",
                        warna: "hijau");
                  } else {
                    _reload();
                    WidgetSnackbar(
                        context: context,
                        message: "Wajah tidak sesuai",
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
            : Container());

    // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    // floatingActionButton: !_bottomSheetVisible
    //     ? AuthActionButton(
    //         _initializeControllerFuture!,
    //         onPressed: onShot_,
    //         isLogin: false,
    //         reload: _reload,
    //         absen: Absen(),
    //       )
    //     : Container());
  }
}
