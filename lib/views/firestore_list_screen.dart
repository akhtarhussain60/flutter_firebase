import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/views/add_firestore_data.dart';
import 'package:flutter_firebase/views/login_screen.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final _auth = FirebaseAuth.instance;
  final _editNameController = TextEditingController();
  final _editComplainController = TextEditingController();
  final _fireStore = FirebaseFirestore.instance.collection("Users").snapshots();
  CollectionReference reference =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text("Firestore List"),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (Route route) => false,
                );
              });
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFirestoreData(),
            ),
          );
        },
        label: const Text("Add Firestore Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _fireStore,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong!"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final id = snapshot.data!.docs[index]["id"].toString();
                  final title = snapshot.data!.docs[index]["Name"].toString();
                  final complain =
                      snapshot.data!.docs[index]["Complain"].toString();

                  return ListTile(
                      title: Text(snapshot.data!.docs[index]["Name"]),
                      subtitle: Text(snapshot.data!.docs[index]["Complain"]),
                      leading: PopupMenuButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              showMyDialog(
                                name: title,
                                complain: complain,
                                id: id,
                              );
                            },
                            value: "1",
                            child: const Text("Update"),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              reference.doc(id).delete();
                            },
                            value: "2",
                            child: const Text("Delete"),
                          ),
                        ],
                      ));
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<void> showMyDialog(
      {String? name, String? complain, String? id}) async {
    _editNameController.text = name.toString();
    _editComplainController.text = complain.toString();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextFormField(
            controller: _editNameController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              border: OutlineInputBorder(),
              hintText: "Name",
            ),
          ),
          content: TextFormField(
            maxLines: 3,
            controller: _editComplainController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              border: OutlineInputBorder(),
              hintText: "Complain",
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.amber,
              onPressed: () {
                Navigator.pop(context);
                reference.doc(id!).update({
                  "Name": _editNameController.text.toString(),
                  "Complain": _editComplainController.text.toString(),
                }).then((value) {
                  print("--------------- Successfully Added -----------------");
                }).onError((error, stackTrace) {
                  print("---------------  $error -----------------");
                });
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
