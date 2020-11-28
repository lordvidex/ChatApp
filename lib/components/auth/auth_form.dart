import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  const AuthForm(this.submitFn, this.isLoading);
  final Future<void> Function(String email, String password, String username,
      bool _isLogin, BuildContext ctx) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _isLogin = true;
  void _validateForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_email, _password, _username, _isLogin, context);
    } else {
      return;
    }
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
              TextFormField(
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
