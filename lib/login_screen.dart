import 'dart:convert';

import 'package:ffootvlg/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:  Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(40)
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
              padding: EdgeInsets.all(40)
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
        border: InputBorder.none,
        labelText: 'Entrer votre email',
          labelStyle: TextStyle(
              color: Colors.black
          ),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white,
        )
      ),
      style: TextStyle(
        color: Colors.white,
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
          border: InputBorder.none,
          labelText: 'Entrer votre mot de passe',
          labelStyle: TextStyle(
            color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.white,
          )
      ),
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans'
      ),
      obscureText: true,
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
    RetrieveUser(EmailController.text, PasswordController.text).then((user) =>{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(user))) // on peut naviguer à la route suivante
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
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Créer un compte',
              style: TextStyle(
                color: Colors.white,
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
        _buildloginPassword(),
        _buildLoginBtn(),
          _buildSignupBtn()
        ],
      ),
    );
  }
}







