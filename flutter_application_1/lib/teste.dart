import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// void main() => runApp(new ConfigScreen());

// class ConfigScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'ImageCropper',
//       theme: ThemeData.light().copyWith(primaryColor: Colors.deepOrange),
//       home: MyHomePage(
//         title: 'ImageCropper',
//       ),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<MyHomePage> {
  AppState? state;
  File? imageFile;
  Uint8List webImagem = Uint8List(8);

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: imageFile != null ? kIsWeb ? Image.memory(webImagem, fit: BoxFit.cover) : Image.file(imageFile!) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.free) {
            _pickImage();
          } else if (state == AppState.picked) {
            _cropImage();
          } else if (state == AppState.cropped) {
            _clearImage();
          }
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free) {
      return const Icon(Icons.add);
    } else if (state == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state == AppState.cropped) {
      return const Icon(Icons.clear);
    } else {
      return Container();
    }
  }

  Future<void> _pickImage() async {
    PickedFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery) as PickedFile;
    if (imageFile != null) {
      setState(() async {
         var f = await imageFile!.readAsBytes();
        state = AppState.picked;
         webImagem =  f;
        imageFile =  File('a') as PickedFile?;
      });
    }
  }

  Future<void> _cropImage() async {
    File croppedFile = (await ImageCropper().cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        // androidUiSettings: AndroidUiSettings(
        //     toolbarTitle: 'Cropper',
        //     toolbarColor: Colors.deepOrange,
        //     toolbarWidgetColor: Colors.white,
        //     initAspectRatio: CropAspectRatioPreset.original,
        //     lockAspectRatio: false),
        // iosUiSettings: IOSUiSettings(
        //   title: 'Cropper',
        // )

        uiSettings: [
        WebUiSettings(context: context,
        barrierColor: Colors.blueAccent,
        customClass: 'Cropper',
        enableOrientation: true,
        enableResize: false,
        enforceBoundary: true,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 1000,
            height: 220
          ), 
          viewPort: const CroppieViewPort(width: 1280, height: 220, type: "rectangle"),
          enableExif: true,
          enableZoom: true,
          mouseWheelZoom: true,
          showZoomer: true
        ),
      ]
        )) as File;
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }
}