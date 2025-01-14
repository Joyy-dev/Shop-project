import 'package:flutter/material.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({super.key});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),
    );
  }
}