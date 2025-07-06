import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/views/code_varify_screen.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final phoneAuthController = TextEditingController();
  bool isLoading = false;
  final _formKay = GlobalKey<FormState>();
  final userCredential = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Phone Auth"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKay,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter your phone number";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                controller: phoneAuthController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  labelText: "Enter phone number",
                ),
              ),
              const SizedBox(height: 60),
              MaterialButton(
                height: 50,
                minWidth: double.infinity,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                onPressed: () async {
                  if (_formKay.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    await userCredential.verifyPhoneNumber(
                      phoneNumber: phoneAuthController.text.toString(),
                      verificationCompleted: (_) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      verificationFailed: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                        setState(() {
                          isLoading = false;
                        });
                      },
                      codeSent: (String varification, int? token) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CodeVarifyScreen(
                              varificationId: varification,
                            ),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                        setState(() {
                          isLoading = false;
                        });
                      },
                    );
                  }
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
                        "Login",
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
