import 'package:flutter/material.dart';

class EditProducts extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProducts({super.key});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocusMode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),

      body: Form(
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title'
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusMode);
              }
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
              ),
              textInputAction: TextInputAction.next,
              keyboardType:  TextInputType.number,
              focusNode: _priceFocusMode,
            )
          ],
        ))
    );
  }
}