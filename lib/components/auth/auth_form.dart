import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  const AuthForm(this.submitFn, this.isLoading);
  final Future<void> Function(String email, String password, String username,
      bool _isLogin, BuildContext ctx, String imagePath) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isLogin = true;
  File _pickedImage;
  void _validateForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();

      ///`_pickedImage` returns an empty string '' if no image was picked
      widget.submitFn(_email, _password, _username, _isLogin, context,
          _pickedImage?.path ?? '');
    } else {
      return;
    }
  }

  Future<void> _getImage() async {
    print("beginning of function");
    final pickedFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      //maxHeight: 200,
      maxWidth: 200,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
        print("Image has been set");

        ///@`Bug` on debug: Bug here bypassed by passing this function to a
        ///[GestureDetector] instead of the [TextButton] on **IOS only**
      });
    }
    print("End of function reached");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              if (!_isLogin)
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      _pickedImage == null ? null : FileImage(_pickedImage),
                ),
              //Temporary Bug fix.. maybe removed after testing on real device
              if (!_isLogin)
                Platform.isIOS
                    ? GestureDetector(
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          child: Text(
                            'Add Image',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: _getImage)
                    : FlatButton.icon(
                        icon: Icon(Icons.image),
                        label: Text('Add Image'),
                        onPressed: _getImage,
                      ),
              TextFormField(
                key: ValueKey('email'),
                onSaved: (val) {
                  _email = val;
                },
                validator: (val) {
                  if (val.isEmpty || !val.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email address"),
              ),
              if (!_isLogin)
                TextFormField(
                    key: ValueKey('username'),
                    onSaved: (val) {
                      _username = val;
                    },
                    validator: (val) {
                      if (val.length < 4 || val.isEmpty) {
                        return "Username is too short";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Username")),
              TextFormField(
                key: ValueKey('password'),
                onSaved: (val) {
                  _password = val;
                },
                validator: (val) {
                  if (val.isEmpty || val.length < 7) {
                    return "Password is too short";
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              SizedBox(
                height: 12,
              ),
              RaisedButton(
                  child: widget.isLoading
                      ? CircularProgressIndicator()
                      : Text(_isLogin ? 'Login' : 'SignUp'),
                  onPressed: widget.isLoading ? null : _validateForm),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: widget.isLoading
                    ? CircularProgressIndicator()
                    : Text(_isLogin
                        ? 'Create new account'
                        : 'Login to an existing account'),
                onPressed: widget.isLoading
                    ? null
                    : () => setState(() {
                          _isLogin = !_isLogin;
                        }),
              )
            ],
          ),
        )),
      ),
    ));
  }
}
