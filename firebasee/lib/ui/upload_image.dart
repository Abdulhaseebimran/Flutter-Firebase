import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasee/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/utils.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('post');

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('no image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Upload Image"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        getImageGallery();
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: _image != null
                            ? Image.file(_image!.absolute)
                            : const Center(child: Icon(Icons.image)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RoundedButton(
                      title: "Uploaded",
                      loading: loading,
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        firebase_storage.Reference ref = firebase_storage
                            .FirebaseStorage.instance
                            .ref('/Abdulhaseeb/' +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString());
                        firebase_storage.UploadTask uploadTask =
                            ref.putFile(_image!.absolute);

                        Future.value(uploadTask).then((value) async {
                          var newUrl = await ref.getDownloadURL();

                          databaseRef.child('1').set({
                            'id': '1212',
                            'title': newUrl.toString()
                          }).then((value) {
                            setState(() {
                              loading = false;
                            });
                            Utils().toastMessage('uploaded');
                          }).onError((error, stackTrace) {
                            print(error.toString());
                            setState(() {
                              loading = false;
                            });
                          });
                        }).onError((error, stackTrace) {
                          Utils().toastMessage(error.toString());
                          setState(() {
                            loading = false;
                          });
                        });
                      })
                ])));
  }
}
