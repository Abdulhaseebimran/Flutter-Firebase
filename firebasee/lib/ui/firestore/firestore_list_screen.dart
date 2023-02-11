import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasee/ui/firestore/firestore_data.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../auth/login.dart';

class FirestoreScreens extends StatefulWidget {
  const FirestoreScreens({super.key});

  @override
  State<FirestoreScreens> createState() => _FirestoreScreensState();
}

class _FirestoreScreensState extends State<FirestoreScreens> {
  final auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection("users").snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Firestore"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: const Icon(Icons.logout_outlined)),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {

                });
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestore,
              builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator();
                }
                if(snapshot.hasError){
                  return const Text("Some Error");
                }
            return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return  ListTile(
                        onTap: (){
                          ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                            'title': "Hello I am Abdul Haseeb Imran",
                          }).then((value) {
                            Utils().toastMessage("Updated");
                          }).onError((error, stackTrace) {
                            Utils().toastMessage(error.toString());
                          });
                          
                          // ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                        },
                        title: Text(snapshot.data!.docs[index]['title'].toString()),
                        subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                      );
                    }));
          })
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFirestoreData()));
          },
          child: const Icon(Icons.add),
        ));
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update"),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: "Edit",
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Update"))
          ],
        );
      },
    );
  }
}
