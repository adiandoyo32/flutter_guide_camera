import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_guide_camera/camera_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: SingleChildScrollView(
              child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: (imageFile != null) ? Image.file(imageFile) : SizedBox(),
              ),
              RaisedButton(
                child: Text('Take Picture'),
                onPressed: () async {
                  imageFile = await Navigator.push<File>(
                      context, MaterialPageRoute(builder: (_) => CameraPage()));
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
