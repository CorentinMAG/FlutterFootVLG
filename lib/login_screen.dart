import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'models/Member.dart';

Future<Member> RetrieveUser(String email,String password) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/checkUserCredentials.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password':password
    }),
  );
  if (response.statusCode == 200) {
    return Member.fromJson(json.decode(response.body));
  } else {
    throw Exception('Identifiants invalides');
  }
}

Future<String> RecoverPassword(String email) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/sendEmail.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
    }),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Adresse email invalide');
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20)
          ),
          Expanded(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoginForm()
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.all(20)
          ),
        ],
        ) ,
      );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _loginFormKey = GlobalKey<FormState>();
  bool _isObscure=true;

  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

  @override
  void dispose() {
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  Widget _buildloginEmail(){
    return TextFormField(
      controller: EmailController,
      decoration: InputDecoration(
        filled: true,
        border: UnderlineInputBorder(),
        labelText: 'Entrer votre email',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.black87,
        )
      ),
      style: TextStyle(
        color: Colors.black87,
        fontFamily: 'OpenSans'
      ),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        return _EmailValidator(value);
      },
    );

  }

  _EmailValidator(String value){
    RegExp regex = RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$");
    if(value.isEmpty){
      return 'Ce champ ne peut pas être vide';
    }
    else if(regex.hasMatch(value)){
      return null;
    }else{
      return 'Email invalide';
    }
  }

  Widget _buildloginPassword(){
    return TextFormField(
      controller: PasswordController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Entrer votre mot de passe',
          labelStyle: TextStyle(
            color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black87,
          ),
        suffixIcon: GestureDetector(
          onTap: (){
            setState(() {
              _isObscure =!_isObscure;
            });
          },
          child: Icon(_isObscure ? Icons.visibility : Icons.visibility_off,),
        )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: _isObscure,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Ce champs ne peut pas être vide';
        }
        return null;
      },
    );
  }
  ValidationForm(){
    final container = StateContainer.of(context);
    RetrieveUser(EmailController.text, PasswordController.text).then((user) =>{
      container.updateUserInfo(Member: user),
      Navigator.pushReplacementNamed(context, '/home') // on peut naviguer à la route suivante
    }).catchError((onError) =>{
      Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          if(_loginFormKey.currentState.validate()){
            ValidationForm();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CONNEXION',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/register'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Pas encore inscrit? ',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Créer un compte',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordBtn(){
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/forgotten_password'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Mot de passe oublié',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _buildloginEmail(),
          SizedBox(height: 24.0,),
        _buildloginPassword(),
        _buildLoginBtn(),
          _buildSignupBtn(),
          SizedBox(height: 24.0,),
          _buildForgotPasswordBtn()
        ],
      ),
    );
  }
}

class ForgottenPassword extends StatefulWidget {
  @override
  _ForgottenPasswordState createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  final _forgetFormKey = GlobalKey<FormState>();
  final EmailController = TextEditingController();

  Widget _buildEmail(){
    return TextFormField(
      controller: EmailController,
      decoration: InputDecoration(
          filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Entrer votre email',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.black87,
          )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        return _EmailValidator(value);
      },
    );
  }
  _EmailValidator(String value){
    RegExp regex = RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$");
    if(value.isEmpty){
      return 'Ce champ ne peut pas être vide';
    }
    else if(regex.hasMatch(value)){
      return null;
    }else{
      return 'Email invalide';
    }
  }

  ValidateData(context){
    final email = EmailController.text;
    RecoverPassword(email).then((value) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(value.toString())))

    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }

  Widget _buildBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: Builder(builder: (context){
        return RaisedButton(
          elevation: 5.0,
          onPressed: (){
            if(_forgetFormKey.currentState.validate()){
              ValidateData(context);
            }
          },
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          child: Text(
            'VALIDER',
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        );
      })
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
      ),
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Form(
            key: _forgetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildEmail(),
                _buildBtn()
              ],
            ),
          )
        ),
      ),
    );
  }
}








