import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/views/home_screen.dart';
import 'package:flutter_firebase/views/phone_auth_screen.dart';
import 'package:flutter_firebase/views/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: const Text(
            "LogIn",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter email";
                    }
                    return null;
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  keyboardType: TextInputType.text,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  onTapOutside: (event) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter your Password";
                    }
                    return null;
                  },
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  height: 50,
                  minWidth: double.infinity,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      _auth
                          .signInWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      )
                          .then(
                        (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                value.user!.email.toString(),
                              ),
                            ),
                          );

                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (Route route) => false,
                          );
                        },
                      ).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error.toString(),
                            ),
                          ),
                        );
                        debugPrint(
                            "===================== $error ==================="
                                .toString());
                        setState(() {
                          isLoading = false;
                        });
                      });
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text("Signup"),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhoneAuthScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login with Phone Number",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
