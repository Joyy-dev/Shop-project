import 'package:flutter/material.dart';

class EditProducts extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProducts({super.key});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocusMode = FocusNode();
  final _descriptionFocusMode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusMode = FocusNode();

  @override
  void initState() {
    _imageUrlFocusMode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose () {
    _imageUrlFocusMode.removeListener(_updateImageUrl);
    _priceFocusMode.dispose();
    _descriptionFocusMode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusMode.dispose();
    super.dispose();
  }

    void _updateImageUrl() {
      if (!_imageUrlFocusMode.hasFocus) {
        setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
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
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusMode);
                }
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLength: 2,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5, left: 10),
                    width: 100,
                    height: 30,
                    child: _imageUrlController.text.isEmpty ? const Text('Enter Your Image Url') : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image'
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusMode,
                    ),
                  )
                ],
              )
            ],
          )),
      )
    );
  }
}