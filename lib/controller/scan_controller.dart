import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController{

  @override
  void onInit(){
    super.onInit();
    initCamera();
    initTFlite();
    // label = "ddd";
  }

  @override
  void dispose(){
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  late CameraImage cameraImage;
  var x,y,w,h = 0.0;
  var label="ádfjdkj";
  var cameraCout = 0;
  var isCameraInitialized = false.obs;


  initCamera() async{
    if(await Permission.camera.request().isGranted)
      {
        cameras = await availableCameras();

        cameraController = await CameraController(
          cameras[0],
          ResolutionPreset.max,
          // imageFormatGroup: ImageFormatGroup.fromCameras(cameras),
        );
        await cameraController.initialize().then((value) {
           cameraController.startImageStream((image){
             cameraCout++;
             if(cameraCout%10==0){
               cameraCout =0;
               objectDectector(image);
             }
             update();
           });
        });
        isCameraInitialized(true);
        update();
      }
    else
      {
        print("Permission denies");
      }
  }

  initTFlite() async{
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/label.txt",
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
  }

  objectDectector(CameraImage image) async{
    var detector = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((e){
          return e.bytes;
    }).toList(),
    asynch: true,
    imageHeight: image.height,
    imageWidth: image.width,
    imageMean: 127.5,
    imageStd: 127.5,
    numResults: 1,
    rotation: 90,
    threshold: 0.4
    );

    if(detector != null){
      log("Result is $detector ");
      var ourDectectedObject = detector.first;
        // if(ourDectectedObject['confidenceInClass'] * 100 > 45){
      log("Result is $ourDectectedObject ");
          label = ourDectectedObject['label'];
          h = ourDectectedObject["rect"]["h"];
          print("height $h");
          // w = ourDectectedObject["rect"];
          // print("width $w");
          // y = ourDectectedObject["rect"];
          // x = ourDectectedObject["rect"];
          update();
      // }
    }
  }
}