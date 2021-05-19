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
      // appBar: AppBar(title: Text('Take Picture')),
      backgroundColor: Colors.black12,
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
                            height: MediaQuery.of(context).size.width /
                                _controller.value.aspectRatio,
                            child: CameraPreview(_controller),
                          ),
                          Container(
                            width: 64,
                            height: 64,
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
                        height: MediaQuery.of(context).size.width /
                            _controller.value.aspectRatio,
                        // color: Colors.black38,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 100,
                          color: Colors.red,
                        ),
                      )
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
