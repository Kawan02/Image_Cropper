import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:get/get.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {


  File? imageFile;
  Uint8List webImagem = Uint8List(8);

  // Pega imagem da galeria
  _getFromGallery() async {
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 220,
    );
    _cropImage(File(pickedFile!.path));

    if (pickedFile != null) {
       var selected = File(pickedFile.path);
       setState(() {
         imageFile = selected;
       });
      // imageFile = pickedFile.path as File;
    } else {
      Get.snackbar("Atenção",
          "Ocorreu um problema! Tente novamente em alguns instantes.");
          print("Não tem imagem");
    } if (pickedFile != null) {
      var f = await pickedFile.readAsBytes();
      setState(() {
        webImagem =  f;
        imageFile =  File('a');
      });
    }
  }

   _clear() {
    setState(() {
      imageFile = null;
    });
  }

  _PegaImagemGaleria() async {
    // ignore: deprecated_member_use
    XFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 220,
    ) as XFile;
    _cropImage(File(pickedFile.path));

    if (pickedFile != null) {
     var selected = File(pickedFile.path);
     setState(() {
       imageFile = selected;
     });
    } else {
      Get.snackbar("Atenção",
          "Ocorreu um problema! Tente novamente em alguns instantes.");
          print("Não tem imagem");
    } if (pickedFile != null) {
      var f = await pickedFile.readAsBytes();
      setState(() {
        webImagem = f;
        imageFile = File('a');
      });
    } else {
      Get.snackbar("Atenção",
          "Ocorreu um problema! Tente novamente em alguns instantes.");
      print("Não tem imagem");
    }
  }

  // Função Crop Image
  _cropImage(File filePath) async {
    File croppedImage = (await ImageCropper().cropImage(
      sourcePath: filePath.path,
      maxWidth: 1280,
      maxHeight: 220,
      uiSettings: [
        WebUiSettings(context: context,
        barrierColor: Colors.transparent,
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
        )
      ]
    )) as File;
    
    // if (croppedImage != null) {
    //   imageFile = croppedImage;
    //   setState(() {});
    // }
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
          children: 
            [Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                       child: IconButton(onPressed: () {
                          _getFromGallery();
                    }, 
                        icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.blue, size: 30, semanticLabel: "Upload")
                    ),
                     ),
        
                     Padding(
                      padding: const EdgeInsets.only(left: 100.0, top: 20.0),
                      child: IconButton(onPressed: () {
                        _clear();
                      }, 
                        icon: const Icon(Icons.delete, color: Colors.red, size: 30, semanticLabel: "Remover")
                      ),
                    ),
                  ],
                  
                ),

                imageFile == null ?
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                            const Text("Faça upload de uma imagem...", style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ],
                      ),
                ) : const Padding(
                  padding: EdgeInsets.all(20.0),
                  child:  Text("Imagem carregada", style: TextStyle(fontSize: 30, color: Colors.black)),
                ),
        
                imageFile == null ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset('img/sem_foto.png', fit: BoxFit.cover),
                  ),
                ) : SizedBox(
                  width: sizeWidth * 1280,
                  height: sizeHeight * .320,
                  child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: kIsWeb ? Image.memory(webImagem, fit: BoxFit.cover) : Image.file((imageFile!), fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ],
              ),
        ),
    );
  }
}