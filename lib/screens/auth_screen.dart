import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/model/http_exception.dart';
import 'package:shop_project/provider/auth.dart';

enum Authmode {Signup, Login}
class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.yellow],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1]
              )
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 94, vertical: 20),
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0, 10.0, 0.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black,
                            offset: Offset(0, 2)
                          )
                        ]
                      ),
                      child: const Text('My Shop!', 
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.yellow,
                      ),),
                    )
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard()
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);


  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Authmode _authmode = Authmode.Login;
  Map<String, String> _authData = {
    'Email': '',
    'Password': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog (String message) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('An error occurred'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text('Okay'),
          )
        ],
      )
    );
  }

  Future<void> _submit () async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
    if (_authmode == Authmode.Login) {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['Email']!, 
        _authData['Password']!
      );
    } else {
      await Provider.of<Auth>(context, listen: false).signUp(
        _authData['Email']!, 
        _authData['Password']!
      );
    }
    } on HttpException catch(error) {
      var errorMessage = 'Athentication Failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address already exists in our database.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This email address was not found.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Password should be at least 6 characters long.';
      } else if (error.toString().contains('EMAIL_IN_USE')) {
        errorMessage = 'This email address is already in use.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMessage = 'Could Not authenticate you. Please try again later!';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchOffMode () {
    setState(() {
      _authmode = (_authmode == Authmode.Login) ? Authmode.Signup : Authmode.Login;
    });  
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      elevation: 8,
      child: Container(
        height: _authmode == Authmode.Signup ? 320 : 260,
        constraints: BoxConstraints(
          minHeight: _authmode == Authmode.Signup ? 320 : 260
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter a valid email address';
                    }
                    if (!value.contains('@')) {
                      return 'Invalid Email Address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['Email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password'
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid password';
                    }
                    RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\W).{8,}$');
                    if (!passwordRegex.hasMatch(value)) {
                      return 'Password should contain at least one uppercase, one lowercase, and one special character';
                    }
                    if (value.length < 8) {
                      return 'Password must contain atleast 8 character';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['Password'] = value!;
                  },
                ),
                if (_authmode == Authmode.Signup)
                TextFormField(
                  enabled: _authmode == Authmode.Signup,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authmode == Authmode.Signup ? (value) {
                    if (value != _passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  } : null
                ),
                const SizedBox(height: 20,),
                if (_isLoading)
                const CircularProgressIndicator()
                else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow
                  ),
                  onPressed: _submit, 
                  child: Text(_authmode == Authmode.Login ? 'LOGIN' : 'SIGN UP')
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    foregroundColor: Colors.black,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                  ),
                  onPressed: _switchOffMode, 
                  child: Text('${_authmode == Authmode.Login ? 'SIGN UP' : 'LOGIN'} INSTEAD')
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}