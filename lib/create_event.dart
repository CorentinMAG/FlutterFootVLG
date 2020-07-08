import 'dart:convert';

import 'package:ffootvlg/models/Member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/Group.dart';
import 'models/createEvent.dart';
import 'package:http/http.dart' as http;
import 'package:ffootvlg/models/Event.dart';

Future<Event> CreateOneEvent(CreateFirstEvent createevent) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createEvent.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(createevent.toJson()),
  );
  if (response.statusCode == 200) {
    return Event.fromJson(json.decode(response.body));
  } else {
    print(response.body);
    throw Exception('Impossible de créer l\'évènement');
  }
}

class CreateEventForm extends StatelessWidget {
  final Group group;
  CreateEventForm({this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer évènement'),
      ),
      body: EventForm(group:group)
    );
  }
}

class EventForm extends StatefulWidget {
  final Group group;
  EventForm({this.group});

  @override
  _EventFormState createState() => _EventFormState(group:group);
}

class _EventFormState extends State<EventForm> {

  final Group group;
  _EventFormState({this.group});

  DateTime selectedDate;
  TimeOfDay selectedTime;
  final _CreateEventFormKey = GlobalKey<FormState>();

  final EventNameController = TextEditingController();
  final EventDescriptionController = TextEditingController();
  final EventPlaceController = TextEditingController();


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale('fr','FR'),
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    );
    if (picked != null && picked != selectedTime){
      setState(() {
        selectedTime = picked;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _CreateEventFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 24.0,),
            _buildCreateNameEvent(),
            SizedBox(height: 24.0,),
            _buildCreateEndroitEvent(),
            SizedBox(height: 24.0,),
            _buildCreateHoraireDATE(),
            SizedBox(height: 24.0,),
            _buildCreateHoraireTIME(),
            SizedBox(height: 24.0,),
            _buildCreateDescriptionEvent(),
            SizedBox(height: 24.0,),
            _buildCreateBtn()
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNameEvent(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: EventNameController,
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Nom de l\'évènement *',
          hintText: 'Mon évènement',
          filled:true,
          labelStyle: TextStyle(
              color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.create,
            color: Colors.black,
          )
      ),
      style: TextStyle(
          color: Colors.black,
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
  Widget _buildCreateEndroitEvent(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: EventPlaceController,
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          filled: true,
          hintText: "12 rue des Herses 91810 Vert Le Grand ",
          labelText: 'Lieu de l\'évènement *',
          labelStyle: TextStyle(
              color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.place,
            color: Colors.black,
          )
      ),
      style: TextStyle(
          color: Colors.black,
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

  Widget _buildCreateDescriptionEvent(){
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: EventDescriptionController,
      maxLines: 5,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Description de l\'évènement...',
          labelText: 'Description',
          labelStyle: TextStyle(
              color: Colors.black
          ),
          prefixIcon: Icon(
            Icons.create,
            color: Colors.black,
          )
      ),
      style: TextStyle(
          color: Colors.black,
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

  Widget _buildCreateHoraireDATE(){
    Intl.defaultLocale ='fr_FR';
    return _InputDropdown(
      labelText: 'Date de l\'évènement *',
      valueText: selectedDate ==null ? 'Choisissez une date' :DateFormat.yMMMMd().format(selectedDate) ,
      onPressed: (){
        _selectDate(context);
      },
    );
  }
  Widget _buildCreateHoraireTIME(){
    return _InputDropdown(
      labelText: 'horaire de l\'évènement *',
      valueText: selectedTime ==null ? 'Choisissez une horaire' :selectedTime.format(context) ,
      onPressed: (){
        _selectTime(context);
      },
    );
  }
  Widget _buildCreateBtn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if(_CreateEventFormKey.currentState.validate()){
            validateForm();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'CREER L\'EVENEMENT',
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

  validateForm(){
    Event event = Event(id_group: widget.group.id,
        name: EventNameController.text,
        description: EventDescriptionController.text,
      endroit: EventPlaceController.text,
      datetime: selectedDate.add(Duration(hours: selectedTime.hour,minutes: selectedTime.minute)).toString()
    );
    final  createevent = CreateFirstEvent(creator: StateContainer.of(context).user,event: event);
    CreateOneEvent(createevent).then((value) => {
      Navigator.pop(context,value)
    }).catchError((onError)=>{
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text(onError.toString())))
    });

  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
        this.child,
        this.labelText,
        this.valueText,
        this.valueStyle,
        this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          prefixIcon: Icon(Icons.date_range),
          filled:true,
          labelStyle: TextStyle(
              color: Colors.black
          ),
          border: UnderlineInputBorder(),
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}


