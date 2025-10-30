import 'package:flutter/material.dart';
import 'package:passwordmanager/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingspage extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  const settingspage({super.key,required this.onThemeChanged});

  @override
  State<settingspage> createState() => _settingspageState();
}

class _settingspageState extends State<settingspage> {
  bool _systempreference = true;
  bool _lightmode = false;
  bool _darkmode = false;
  bool _notificationPermission= true;
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState(){
    super.initState();
    _loadNotificationPref();
  }

  void _loadNotificationPref() async {
  final prefs = await SharedPreferences.getInstance();
  bool? savedValue = prefs.getBool('notification_enable');
  if (savedValue != null) {
    setState(() {
      _notificationPermission = savedValue;
    });
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting page'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:const EdgeInsets.all(10),
                child: Text('user system preference'),
                ),
                Switch(
                  value: _systempreference,
                  onChanged: (newswitchvalue){
                    _systempreference? print('blocked'): 
                    setState(() {
                      _systempreference = true;
                      _lightmode = false;
                      _darkmode=false;
                      _themeMode= ThemeMode.system;
                    });
                     widget.onThemeChanged(ThemeMode.system);
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: const EdgeInsets.all(10),
              child: Text('Light mode'),
              ),
              Switch(
                value: _lightmode, 
                onChanged: (newswitchvalue) {
                  _lightmode ? print('blocked'):
                  setState(() {
                    _lightmode=true;
                    _systempreference=false;
                    _darkmode=false;
                    _themeMode=ThemeMode.light;
                  });
                   widget.onThemeChanged(ThemeMode.light); 
                })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: const EdgeInsets.all(10),
              child: Text('Dark mode'),
              ),
              Switch(
                value: _darkmode,
                onChanged: (newswitchvalue){
                  _darkmode ? print('blocked'):
                  setState(() {
                    _darkmode=true;
                    _systempreference=false;
                    _lightmode=false;
                    _themeMode=ThemeMode.dark;
                  });
                   widget.onThemeChanged(ThemeMode.dark); 
                })
            ],
          ),
          SizedBox(width: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: const EdgeInsets.all(10),
              child: Text('Notification'),),
              Switch(
                value: _notificationPermission, 
                onChanged: (newnotificationvalue) async{
                setState(() {

                  _notificationPermission=newnotificationvalue;});
                final SharedPreferences prefnotifi = await SharedPreferences.getInstance();
                await prefnotifi.setBool('notification_enable', newnotificationvalue);
                await prefnotifi.reload();
                if(newnotificationvalue==true){
                  notificationservice.initialize();
                }
                else{
                  print('notification disables');
                }
              })
            ],

          )
        ],
      ),
    );
  }
}