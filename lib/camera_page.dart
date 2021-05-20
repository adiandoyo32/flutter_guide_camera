import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _controller;

  Future<void> _initializeCamera() async {
    var cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<File> _takePicture() async {
    Directory root = await getTemporaryDirectory();
    String directoryPath = '${root.path}/guide_camera';
    await Directory(directoryPath).create(recursive: true);
    String filePath = '$directoryPath/${DateTime.now()}.jpg';

    try {
      await _controller.takePicture(filePath);
    } catch (e) {
      return null;
    }
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Picture'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: FutureBuilder<void>(
        future: _initializeCamera(),
        builder: (_, snapshot) =>
            (snapshot.connectionState == ConnectionState.done)
                ? Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: CameraPreview(_controller),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            margin: EdgeInsets.only(top: 32),
                            child: RaisedButton(
                              shape: CircleBorder(),
                              color: Colors.blue,
                              onPressed: () async {
                                if (!_controller.value.isTakingPicture) {
                                  File result = await _takePicture();
                                  Navigator.pop(context, result);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.6), BlendMode.srcOut),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    backgroundBlendMode: BlendMode
                                        .dstOut), // This one will handle background + difference out
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: MediaQuery.of(context).size.width -
                                      (MediaQuery.of(context).size.width / 10),
                                  height: MediaQuery.of(context).size.width -
                                      (MediaQuery.of(context).size.width / 2.8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.78,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Posisikan KTP di dalam bingkai,\n pastikan informasi di foto terlihat jelas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.4,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
      ),
    );
  }
}
