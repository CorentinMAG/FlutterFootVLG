import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Member.dart';


Future<Member> CreateUser(Member user) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createUser.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user),
  );
  if (response.statusCode == 200) {
    return Member.fromJson(json.decode(response.body));
  } else {
    throw Exception('Impossible de créer l\'utilisateur');
  }
}

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 43.0),
          child: RegisterForm(),
        ),
      )
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final _registerFormKey = GlobalKey<FormState>();
  bool _isObscure=true;

  final LastNameController = TextEditingController();
  final FirstNameController = TextEditingController();
  final EmailController = TextEditingController();
  final PhoneController = TextEditingController();
  final BirthdayController = TextEditingController();
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();

  Widget _buildRegisterLastName(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: LastNameController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Nom',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.black87,
          )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Ce champ ne peut pas être vide';
        }
        return null;
      },
    );
  }
  Widget _buildRegisterFirstName(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: FirstNameController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Prénom',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.account_circle,
            color: Colors.black87,
          )
      ),
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Ce champ ne peut pas être vide';
        }
        return null;
      },
    );
  }
  Widget _buildRegisterEmail(){
    return TextFormField(
      controller: EmailController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Email',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.black87,
          )
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        return _EmailValidator(value);
      },
    );
  }
  Widget _buildRegisterPhone(){
    return TextFormField(
      maxLength: 10,
      controller: PhoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        filled: true,
        counterText: "",
          border: UnderlineInputBorder(),
          labelText: 'Numéro de téléphone',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.phone_android,
            color: Colors.black87,
          )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Ce champ ne peut pas être vide';
        }
        return null;
      },
    );

  }
  Widget _buildRegisterBirthday(){
    return TextFormField(
      maxLength: 10,
      keyboardType: TextInputType.datetime,
      controller: BirthdayController,
      decoration: InputDecoration(
        filled: true,
        counterText: "",
          border: UnderlineInputBorder(),
          labelText: 'Date de naissance (AAAA-mm-jj)',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.cake,
            color: Colors.black87,
          )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: false,
      autofocus: false,
      validator: (value) {
        return _BirthdayValidator(value);
      },
    );
  }
  Widget _buildRegisterPassword(){
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: PasswordController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Mot de passe',
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
              _isObscure = !_isObscure;
            });
          },
          child: Icon(_isObscure ? Icons.visibility : Icons.visibility_off,color: Colors.black87,),
        )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: _isObscure,
      autofocus: false,
      validator: (value) {
       return _PasswordValidator(value);
      },
    );
  }
  Widget _buildRegisterConfirmPassword(){
    return TextFormField(
      controller: ConfirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Confirmer votre mot de passe',
          labelStyle: TextStyle(
              color: Colors.black87
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black87,
          )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: true,
      autofocus: false,
      validator: (value) {
       return _ConfirmPasswordValidator(PasswordController.text, value);
      },
    );
  }
  Widget _buildRegisterBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          if(_registerFormKey.currentState.validate()){
            ValidationForm();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CREER UN COMPTE',
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
  _BirthdayValidator(String value){
    RegExp regex = RegExp(r"^[0-9]{4}-[0-9]{2}-[0-9]{2}$");
    if(value.isEmpty){
      return 'Ce champ ne peut pas être vide';
    }else if(regex.hasMatch(value)){
      return null;
    }else{
      return "Le format doit être AAAA-mm-jj";
    }
  }
  _PasswordValidator(String value){
    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if(value.isEmpty){
      return 'Ce champ ne peut être vide';
    }else if(regex.hasMatch(value)){
      return null;
    }else{
      return "le mot de passe doit contenir:\n" +
          "au moins 1 chiffre\n" +
          "au moins 1 lettre en minuscule\n" +
          "au moins 1 lettre en majuscule\n" +
          "au moins 1 caractère spécial\n" +
          "pas d'espace dans le mot de passe\n" +
          "8 caractères minimum";
    }
  }

  _ConfirmPasswordValidator(String password, String confirmPassword){
    if(password != confirmPassword){
      return "Les deux mots de passe sont différents";
    }else if(confirmPassword.isEmpty){
      return 'Ce champ ne peut pas être vide';
    }else{
      return null;
    }

  }

  ValidationForm(){
    Member user = Member(
      last_name: LastNameController.text,
      first_name: FirstNameController.text,
      email: EmailController.text,
      phone_number: PhoneController.text,
      birthday: BirthdayController.text,
      password: PasswordController.text
    );
    final container = StateContainer.of(context);
    CreateUser(user).then((user) =>{
      container.updateUserInfo(Member: user),
      Navigator.pushReplacementNamed(context, '/home')
    })
        .catchError((onError) => {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });
  }

  @override
  void dispose() {
    LastNameController.dispose();
    FirstNameController.dispose();
    EmailController.dispose();
    PhoneController.dispose();
    BirthdayController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registerFormKey,
      child:Container(
        child:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 24.0,),
              _buildRegisterLastName(),
              SizedBox(height: 24.0,),
              _buildRegisterFirstName(),
              SizedBox(height: 24.0,),
              _buildRegisterEmail(),
              SizedBox(height: 24.0,),
              _buildRegisterPhone(),
              SizedBox(height: 24.0,),
              _buildRegisterBirthday(),
              SizedBox(height: 24.0,),
              _buildRegisterPassword(),
              SizedBox(height: 24.0,),
              _buildRegisterConfirmPassword(),
              SizedBox(height: 12.0,),
              _buildRegisterBtn()
            ],
          )
        )
      )
    );
  }
}

