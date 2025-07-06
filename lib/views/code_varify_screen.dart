import 'package:flutter/material.dart';

class CodeVarifyScreen extends StatefulWidget {
  final String varificationId;
  const CodeVarifyScreen({super.key, required this.varificationId});
  @override
  State<CodeVarifyScreen> createState() => _CodeVarifyScreenState();
}

class _CodeVarifyScreenState extends State<CodeVarifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Code Varification"),
      ),
    );
  }
}
