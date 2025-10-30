import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './addpassword.dart';
import 'dart:convert';
import 'package:local_auth/local_auth.dart';
import './settings.dart';
import 'package:permission_handler/permission_handler.dart';
import './notifications.dart';
import './passwordlist.dart';




class Homepage extends StatefulWidget {
  final Function(ThemeMode)  onThemeChanged;
  const Homepage({super.key, required this.onThemeChanged});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override

final LocalAuthentication auth = LocalAuthentication();
bool _authenticated = false;

  List<String> saveddetails=[];

  void initState() {
    super.initState();
    //loaddetails();
    notificationservice.initialize();
    _initAsync();
  }
  Future<void> _initAsync() async {
  await _requestNotificationPermission();
  await _authenticateUser();
}

  Future<void> _requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
}

  Future<void> _authenticateUser() async {
  try {
    print("Checking biometric support...");
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isSupported = await auth.isDeviceSupported();

    print("Can check biometrics: $canCheckBiometrics");
    print("Device supports biometrics: $isSupported");

    if (canCheckBiometrics && isSupported) {
      print("Prompting biometric dialog...");
      bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access your passwords',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );

      print("Authentication success: $didAuthenticate");

      if (didAuthenticate) {
        setState(() {
          _authenticated = true;
        });
      }
    } else {
      print("This app requires a biometric authentication to continue..");
    }
  } catch (e) {
    print("Authentication error: $e");
  }
}

 int selectedindex=0;
 
  void bottomfunc(int index){
   setState(() {
     selectedindex=index;
   });
  }
  
  Widget build(BuildContext context) {
    

    if (!_authenticated) {
    return const Scaffold(
      body: Center(
        child: Text('Please authenticate to continue...'),
      ),
    );
  }
    final List<Widget> page=[
    Passwordlist(),
    settingspage(onThemeChanged : widget.onThemeChanged),
    ];
    return Scaffold(
      appBar: AppBar(
        title:Center( child: Text('password manager',style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,elevation: 0, 
        
      ),
      body: page.elementAt(selectedindex),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>Addpassword()));},label: Text('Save password'),icon: Icon(Icons.key),),
          bottomNavigationBar: BottomNavigationBar(
            onTap: bottomfunc,
            currentIndex: selectedindex,
            items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label:'settings'),
            ], ));
  }
}