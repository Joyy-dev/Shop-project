import 'dart:math';

import 'package:flutter/material.dart';

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
                begin: Alignment.bottomLeft,
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 94),
                      transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10),
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
                        fontSize: 20
                      ),),
                    )
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard()
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

  void _submit () {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authmode == Authmode.Login) {
      //
    } else {
      //sign up user
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchOffMode () {
    if (_authmode == Authmode.Login) {
      setState(() {
        _authmode = Authmode.Signup;
      });
    } else {
      setState(() {
        _authmode = Authmode.Login;
      });
    }
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
                    if (value.contains('@')) {
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
                    if (value !=_passwordController) {
                      return 'Incorrect Password';
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