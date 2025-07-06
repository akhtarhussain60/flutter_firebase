import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostsScreen extends StatefulWidget {
  const AddPostsScreen({super.key});

  @override
  State<AddPostsScreen> createState() => _AddPostsScreenState();
}

class _AddPostsScreenState extends State<AddPostsScreen> {
  final formKey = GlobalKey<FormState>();
  final postController = TextEditingController();
  final nameController = TextEditingController();
  var isLoading = false;
  final firebaseDatabase = FirebaseDatabase.instance.ref("Client Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Add Posts"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your full name";
                  }
                  return null;
                },
                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "Enter name?",
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "What is in your mind?";
                  }
                  return null;
                },
                maxLines: 6,
                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                controller: postController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  hintText: "What is in your mind?",
                ),
              ),
              const SizedBox(height: 30),
              MaterialButton(
                height: 50,
                minWidth: double.infinity,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                      debugPrint("start loading");
                    });

                    final dataKey =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    firebaseDatabase.child(dataKey).set({
                      "Name": nameController.text.toString(),
                      "Complain": postController.text.toString(),
                      "Id": dataKey,
                    }).then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  }
                },
                child: isLoading
                    ? const SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Add Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
