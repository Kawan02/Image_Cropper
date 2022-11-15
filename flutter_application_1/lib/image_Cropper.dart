import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyCropper extends StatefulWidget {
  const MyCropper({super.key});

  @override
  State<MyCropper> createState() => _MyCropperState();
}

class _MyCropperState extends State<MyCropper> {
  File? imageSelecionada;

  File? _image;

  ImagePicker imagePicker = ImagePicker();

  Future pegarImagemGaleria() async {
    final imagemTemporaria = await imagePicker.pickImage(source: ImageSource.gallery);

    if(imagemTemporaria == null) return;
    File? imagemCortada = File(imagemTemporaria.path);
    imagemCortada = await _cropImage(imagemFile: imagemCortada);
      setState(() {
        _image = imagemCortada;
      });
  }

  _clear() {
    setState(() {
      _image = null;
    });
  }

  Future<File?> cortarImagem({required File imagem}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imagem.path, uiSettings: [
      WebUiSettings(
          context: context,
          barrierColor: Colors.blueAccent,
          customClass: 'Cropper',
          enableOrientation: true,
          enableResize: false,
          enforceBoundary: true,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(width: 1000, height: 220),
          viewPort: const CroppieViewPort(
              width: 1280, height: 220, type: "rectangle"),
          enableExif: true,
          enableZoom: true,
          mouseWheelZoom: true,
          showZoomer: true)
    ]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imagemFile: img);
      setState(() {
        _image = img;
      });
    } on PlatformException catch (e) {
      Get.snackbar("Atenção",
          "Ocorreu um problema! Tente novamente em alguns instantes.");
      print(e);
    }
  }

  Future<File?> _cropImage({required File imagemFile}) async {
    CroppedFile? _croppedImage = await ImageCropper().cropImage(
        sourcePath: imagemFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        cropStyle: CropStyle.rectangle,
        uiSettings: [
          WebUiSettings(
            context: context,
            customClass: 'Cropper',
            barrierColor: Colors.transparent,
            enableOrientation: true,
            enableResize: false,
            enforceBoundary: true,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(width: 650, height: 300),
            viewPort: const CroppieViewPort(
                width: 1280, height: 220, type: "rectangle"),
            enableExif: true,
            enableZoom: true,
            mouseWheelZoom: true,
            showZoomer: true,
          )
        ]);
    if (_croppedImage == null) return null;
    return File(_croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    var sizeHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Imagem Cropper"),
      ),
      body: Container(
        width: sizeWidth,
        height: sizeHeight,
        color: Colors.black12,
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                      child: IconButton(
                          onPressed: () {
                            _pickImage();
                          },
                          icon: const Icon(Icons.add_photo_alternate_outlined,
                              color: Colors.blue,
                              size: 30,
                              semanticLabel: "Upload")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100.0, top: 20.0),
                      child: IconButton(
                          onPressed: () {
                            _clear();
                          },
                          icon: const Icon(Icons.delete,
                              color: Colors.red,
                              size: 30,
                              semanticLabel: "Remover")),
                    ),
                  ],
                ),
                _image == null
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              "Faça upload de uma imagem...",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.black),
                            ),
                          ],
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Imagem carregada",
                            style:
                                TextStyle(fontSize: 30, color: Colors.black)),
                      ),
                _image == null
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Image.asset('img/sem_foto.png',
                              fit: BoxFit.cover),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: kIsWeb
                            ? Image.network(_image!.path)
                            : Image.file(_image!),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
