import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/views/add_posts_screen.dart';
import 'package:flutter_firebase/views/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ref_of_database = FirebaseDatabase.instance.ref("Client Post");
  final searchFilter = TextEditingController();
  final editNameController = TextEditingController();
  final editComplainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Post"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (Route route) => false,
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostsScreen()));
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: StreamBuilder(
          //     stream: ref_of_database.onValue,
          //     builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //       // Check if snapshot has data and if the data is of type Map
          //       if (!snapshot.hasData ||
          //           snapshot.data!.snapshot.value == null) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }

          //       // Safely access snapshot data and handle type checking
          //       Map<dynamic, dynamic> map = {};
          //       if (snapshot.data!.snapshot.value is Map) {
          //         map = Map<dynamic, dynamic>.from(
          //             snapshot.data!.snapshot.value as Map);
          //       } else {
          //         return const Center(
          //           child: Text("Data is not in expected format."),
          //         );
          //       }

          //       List<dynamic> list = map.values.toList();

          //       return ListView.builder(
          //         itemCount: list.length,
          //         itemBuilder: (context, index) {
          //           return ListTile(
          //             title: Text(list[index]["Name"] ?? "No Name"),
          //             subtitle: Text(list[index]["Complain"] ?? "No Complain"),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              controller: searchFilter,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref_of_database,
              itemBuilder: (context, snapshot, animate, index) {
                var id = snapshot.key;
                var title = snapshot.child("Name").value.toString();
                var complain = snapshot.child("Complain").value.toString();
                if (searchFilter.text.isEmpty) {
                  return SingleChildScrollView(
                    child: ListTile(
                      title: Text(snapshot.child("Name").value.toString()),
                      subtitle:
                          Text(snapshot.child("Complain").value.toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              showMyDialog(
                                title,
                                complain,
                                id.toString(),
                              );
                            },
                            value: "1",
                            child: const Text("Edit"),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              ref_of_database.child(id.toString()).remove();
                            },
                            value: "2",
                            child: const Text("Delete"),
                          )
                        ],
                      ),
                    ),
                  );
                }
                if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase().toString())) {
                  return SingleChildScrollView(
                    child: ListTile(
                      title: Text(snapshot.child("Name").value.toString()),
                      subtitle:
                          Text(snapshot.child("Complain").value.toString()),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<void> showMyDialog(String name, String complain, String id) async {
    editNameController.text = name;
    editComplainController.text = complain;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextFormField(
            controller: editNameController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              border: OutlineInputBorder(),
              hintText: "Name",
            ),
          ),
          content: TextFormField(
            maxLines: 3,
            controller: editComplainController,
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

                ref_of_database.child(id).update({
                  "Name": editNameController.text.toString(),
                  "Complain": editComplainController.text.toString(),
                }).then((value) {
                  print("------- Successfully Updated --------");
                }).onError((error, stackTrace) {
                  print("------- $error --------");
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
