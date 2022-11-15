import 'package:flutter/material.dart';
import 'package:flutter_application_1/imageCropper.dart';
import 'package:flutter_application_1/image_Cropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       title: 'Imagem Cropper',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const MyCropper(),
    );
  }
}