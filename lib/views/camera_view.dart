import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:testtensorflow/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          print("Controller weight: ${controller.w}");
          print("Controller label: ${controller.label}");
          return controller.isCameraInitialized.value
              ? Stack(
                children: [
                  CameraPreview(controller.cameraController),
                  Container(
                    width:  100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green,width: 4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            color: Colors.white,
                            child: Text("akjsdhfgaskdjhfg ${controller.label}"),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              :const Center(child: Text("Loading Preview..."),);
        },
      ),
    );
  }
}
