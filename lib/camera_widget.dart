import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'late.dart';

class CameraWidget extends StatefulWidget {
  /// Default Constructor
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  Late<CameraController> controller = Late();
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    controller.val = CameraController(_cameras[0], ResolutionPreset.max);
    controller.val.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.val.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (!controller.isInitialized || !controller.val.value.isInitialized) {
  //     return Container();
  //   }
  //
  //   var tmp = MediaQuery.of(context).size;
  //
  //   final screenH = max(tmp.height, tmp.width);
  //   final screenW = min(tmp.height, tmp.width);
  //
  //   tmp = controller.val.value.previewSize!;
  //
  //   final previewH = max(tmp.height, tmp.width);
  //   final previewW = min(tmp.height, tmp.width);
  //   final screenRatio = screenH / screenW;
  //   final previewRatio = previewH / previewW;
  //
  //   return Center(
  //         child: Container(
  //           width: screenW,
  //           height: screenW,
  //           color: Colors.black,
  //           child: ClipRRect(
  //             child: OverflowBox(
  //               maxHeight: screenRatio > previewRatio
  //                   ? screenH
  //                   : screenW / previewW * previewH,
  //               maxWidth: screenRatio > previewRatio
  //                   ? screenH / previewH * previewW
  //                   : screenW,
  //               child: Container(
  //                 decoration: const BoxDecoration(
  //                     border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 4.0))),
  //                 child: CameraPreview(
  //                   controller.val,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //   // return MaterialApp(
  //   //   home: CameraPreview(controller),
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    if (!controller.isInitialized || !controller.val.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;

    final screenH = max(tmp.height, tmp.width);
    final screenW = min(tmp.height, tmp.width);
    const iconSize = 80.0;

    return AspectRatio(
        aspectRatio: controller.val.value.aspectRatio,
        child: Stack(fit: StackFit.expand, children: [
          CameraPreview(controller.val),
          cameraOverlay(
              padding: 10, aspectRatio: 1, color: const Color(0x55000000)),
          Positioned(
              bottom: 50,
              left: ((screenW - iconSize) / 2),
              child: GestureDetector(
                onTap: () async {
                  XFile picture = await controller.val.takePicture();
                  // print(picture.toString());
                  GallerySaver.saveImage(picture.path);
                },
                child: Icon(
                  Icons.camera,
                  size: iconSize,
                ),
              ))
        ]));
  }

  Widget cameraOverlay(
      {required double padding,
      required double aspectRatio,
      required Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
                ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
            2;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
                ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      return Stack(fit: StackFit.expand, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.centerRight,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
        )
      ]);
    });
  }
}
