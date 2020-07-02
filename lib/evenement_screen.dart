import 'dart:convert';

import 'package:ffootvlg/models/Event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Event> CreateOneEvent(Event createGroup) async {
  final http.Response response = await http.post(
    'https://foot.agenda-crna-n.com/createGroup.php',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(createGroup.toJson()),
  );
  if (response.statusCode == 200) {
    return Event.fromJson(json.decode(response.body));
  } else {
    throw Exception('Impossible de créer l\'évènement');
  }
}

class EvenementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Evenements'),
        ),
      ),
    );
  }
}
