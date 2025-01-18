import 'package:flutter/material.dart';
import 'package:shop_project/provider/product.dart';

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
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '', 
    title: '', 
    description: '',
    price: 0, 
    imageURL: ''
  );

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
      setState(() {
        
      });
    }
  }
  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title'
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusMode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: value!, 
                    description: _editedProduct.description, 
                    price: _editedProduct.price, 
                    imageURL: _editedProduct.imageURL
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value for your title';
                  }
                  return null;
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
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id, 
                    title: _editedProduct.title, 
                    description: _editedProduct.description, 
                    price: double.parse(value!), 
                    imageURL: _editedProduct.imageURL
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price for your product';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number for your price';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a valid positive number for your price';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLength: 2,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description for your product';
                  }
                  return null;
                },
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
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id, 
                            title: _editedProduct.title, 
                            description: _editedProduct.description, 
                            price: _editedProduct.price, 
                            imageURL: value!
                          );
                        },
                      ),
                    ),

                ],
              )
            ],
          )),
      )
    );
  }
}