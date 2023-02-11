import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasee/ui/auth/login.dart';
import 'package:firebasee/ui/post/add_post.dart';
import 'package:firebasee/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Screen"),
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
      body: Column(
        children: [
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
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                defaultChild: const Text("loading"),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialog(title, snapshot.child('id').value.toString());
                                  },
                                  leading: const Icon(Icons.add, color: Colors.blue,),
                                  title: const Text("Edit"),
                                )),
                                 PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                      ref.child(snapshot.child('id').value.toString()).remove();
                                      },
                                      leading: const Icon(Icons.delete_outline, color: Colors.red,),
                                      title: const Text("Delete"),
                                    )),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPost()));
        },
        child: const Icon(Icons.add),
      ),
    );
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
                  ref.child(id).update({
                    'title': editController.text.toLowerCase(), 
                  }).then((value) {
                  Utils().toastMessage("Post Updated");
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: const Text("Update"))
          ],
        );
      },
    );
  }
}
// stream Builder fetch data
// Expanded(
//               child: StreamBuilder(
//                   stream: ref.onValue,
//                   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                     Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
//                     List<dynamic> list = [];
//                     list.clear();
//                     list = map.values.toList();
//                     if (!snapshot.hasData) {
//                       return const CircularProgressIndicator();
//                     } else {
//                       return ListView.builder(
//                         itemCount: snapshot.data!.snapshot.children.length,
//                         itemBuilder: (context, index) {
//                         return  ListTile(
//                           title: Text(list[index]['title']),
//                           // subtitle: Text(list[index]['title']),
//                         );
//                       });
//                     }
//                   })),