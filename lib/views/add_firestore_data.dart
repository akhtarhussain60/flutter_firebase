import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final _nameController = TextEditingController();
  final _complainController = TextEditingController();
  var isLoading = false;
  final cloudFirestore = FirebaseFirestore.instance.collection("Users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text("Add Firestore Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              onTapOutside: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                border: OutlineInputBorder(),
                hintText: "Name",
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLines: 4,
              onTapOutside: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              controller: _complainController,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                border: OutlineInputBorder(),
                hintText: "Complain",
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                setState(() {
                  isLoading = true;
                });

                String docsKey =
                    DateTime.now().millisecondsSinceEpoch.toString();

                cloudFirestore.doc(docsKey).set({
                  "Name": _nameController.text.toString(),
                  "Complain": _complainController.text.toString(),
                  "id": docsKey,
                }).then((value) {
                  setState(() {
                    isLoading = false;
                  });
                }).onError((error, stackTrace) {
                  setState(() {
                    isLoading = false;
                  });
                  debugPrint("--------- $error ---------");
                });
              },
              child: isLoading
                  ? const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Add Data",
                      style: TextStyle(
                        letterSpacing: 1.5,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
