// import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_widget.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {

  @override
  Widget build(BuildContext context) {

    return const MaterialApp(
        home: CameraWidget()
    );
    // return MaterialApp(
    //   home: CameraPreview(controller),
    // );
  }
}