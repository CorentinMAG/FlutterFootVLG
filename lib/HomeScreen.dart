import 'package:ffootvlg/ProfilScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GroupScreen.dart';
import 'models/Member.dart';

class HomeScreen extends StatelessWidget {
  Member user;
  HomeScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomBar(user:user),
    );
  }
}
class BottomBar extends StatefulWidget {
  Member user;
  BottomBar({@required this.user});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    _widgetOptions = [
      GroupScreen(user:widget.user),
      ProfilScreen(user:widget.user)
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FootVLG'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profil'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}



