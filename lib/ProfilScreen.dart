import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Member.dart';

Future<String> UpdateUser(Member user) async {
  final http.Response response = await http.put(
    'https://foot.agenda-crna-n.com/updateUser.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(user),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Rien n\'a été modifié');
  }
}

class ProfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var is_admin = StateContainer.of(context).user.is_admin;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: <Widget>[
          if(is_admin) IconButton(
            icon: Icon(Icons.group),
            onPressed:() => Navigator.pushNamed(context, '/listUser'),
          )
        ],
      ),
        body: Center(
            child: UpdateForm(user:StateContainer.of(context).user),
          ),
    );
  }
}


class UpdateForm extends StatefulWidget {

  final Member user;
  UpdateForm({@required this.user});

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {

  final _updateFormKey = GlobalKey<FormState>();

  bool _isObscureTEXT=true;

  TextEditingController LastNameController;
  TextEditingController FirstNameController;
  TextEditingController EmailController;
  TextEditingController PhoneController;
  TextEditingController BirthdayController;
  final PasswordController = TextEditingController();
  final ConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    LastNameController = TextEditingController(text: widget.user.last_name);
    FirstNameController =TextEditingController(text: widget.user.first_name);
    EmailController =TextEditingController(text: widget.user.email);
    PhoneController =TextEditingController(text: widget.user.phone_number);
    BirthdayController =TextEditingController(text: widget.user.birthday);
  }

  Widget _buildUpdateLastName(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: LastNameController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Nom',
          labelStyle: TextStyle(
              color: Colors.black
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
  Widget _buildUpdateFirstName(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: FirstNameController,
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          labelText: 'Prénom',
          labelStyle: TextStyle(
              color: Colors.black
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
  Widget _buildUpdateEmail(){
    return TextFormField(
      controller: EmailController,
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          labelText: 'Email',
          labelStyle: TextStyle(
              color: Colors.black
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
  Widget _buildUpdatePhone(){
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
              color: Colors.black
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
  Widget _buildUpdateBirthday(){
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
              color: Colors.black
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
  Widget _buildUpdatePassword(){
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      controller: PasswordController,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Mot de passe',
          labelStyle: TextStyle(
              color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black87,
          ),
        suffixIcon: GestureDetector(
          onTap: (){
            print(_isObscureTEXT);
            setState(() {
              _isObscureTEXT=!_isObscureTEXT;
            });
          },
          child: Icon(_isObscureTEXT ? Icons.visibility : Icons.visibility_off),
        )
      ),
      style: TextStyle(
          color: Colors.black87,
          fontFamily: 'OpenSans'
      ),
      obscureText: _isObscureTEXT,
      autofocus: false,
      validator: (value) {
        return _PasswordValidator(value);
      },
    );
  }
  Widget _buildUpdateConfirmPassword(){
    return TextFormField(
      controller: ConfirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        filled: true,
          border: UnderlineInputBorder(),
          labelText: 'Confirmer votre mot de passe',
          labelStyle: TextStyle(
              color: Colors.black
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
  Widget _buildUpdateBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: (){
          if(_updateFormKey.currentState.validate()){
            ValidationForm(StateContainer.of(context).user);
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'METTRE A JOUR',
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
    if(value.isEmpty || regex.hasMatch(value)){
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
    }else{
      return null;
    }

  }

  ValidationForm(Member user){
      final Member updateUser = Member(
          id:user.id,
          last_name:LastNameController.text,
          first_name:FirstNameController.text,
          phone_number:PhoneController.text,
          email:EmailController.text,
          birthday:BirthdayController.text,
          inscription_date:user.inscription_date,
          is_admin:user.is_admin,
          is_superuser:user.is_superuser
      );
      if(PasswordController.text!=""){
        var bytes = utf8.encode(PasswordController.text);
        var digest =sha256.convert(bytes);
        updateUser.password = digest.toString();
      }else{
        updateUser.password = user.password;
      }
      UpdateUser(updateUser).then((value) => {
      StateContainer.of(context).updateUserInfo(Member: updateUser),
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(value.toString()))),
      }).catchError((onError)=>{
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(onError.toString())))
      });
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _updateFormKey,
      child: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 24.0,),
              _buildUpdateLastName(),
              SizedBox(height: 24.0,),
              _buildUpdateFirstName(),
              SizedBox(height: 24.0,),
              _buildUpdateEmail(),
              SizedBox(height: 24.0,),
              _buildUpdatePhone(),
              SizedBox(height: 24.0,),
              _buildUpdateBirthday(),
              SizedBox(height: 24.0,),
              _buildUpdatePassword(),
              SizedBox(height: 24.0,),
              _buildUpdateConfirmPassword(),
              SizedBox(height: 12.0,),
              _buildUpdateBtn()
            ],
          ),
        ),
      ),
    );
  }
}
