import 'package:firebase_auth/firebase_auth.dart';

class SignupServices {
  Future<void> createUserData(String email, dynamic password) async {
    // ignore: unused_local_variable
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  // Future<void> userSignUp(String email, dynamic password) async {
  //   try {
  //     UserCredential credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     print("<<<<<<<<=========== $credential ============>>>>>>");
  //     print("----------- $email ----------");
  //     print("=========== $password ===========");
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == "weak password") {
  //       Utils.toastMessage("Error ==> $e");
  //     } else if (e.code == "Email already in use") {
  //       Utils.toastMessage("Error ==> $e");
  //     }
  //   } catch (error) {
  //     throw Exception(error);
  //   }
  // }

  // Future<void> signUpVarification(String email, dynamic password) async {
  //   UserCredential credential = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email, password: password)
  //       .then((value) {
  //     return value;
  //   }).onError((error, stackTrace) {
  //     throw Exception("AAA");
  //   });
  // }
}
