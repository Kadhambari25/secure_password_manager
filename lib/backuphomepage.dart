// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import './addpassword.dart';
// import 'dart:convert';
// import 'package:local_auth/local_auth.dart';
// import './settings.dart';
// import 'package:permission_handler/permission_handler.dart';
// import './notifications.dart';


// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   @override

// final LocalAuthentication auth = LocalAuthentication();
// bool _authenticated = false;

//   List<String> saveddetails=[];

//   void initState() {
//     super.initState();
//     //loaddetails();
//     notificationservice.initialize();
//     _initAsync();
//   }
//   Future<void> _initAsync() async {
//   await _requestNotificationPermission();
//   await _authenticateUser();
// }

//   Future<void> _requestNotificationPermission() async {
//   var status = await Permission.notification.status;
//   if (!status.isGranted) {
//     await Permission.notification.request();
//   }
// }


//   Future<void> _authenticateUser() async {
//   try {
//     print("Checking biometric support...");
//     bool canCheckBiometrics = await auth.canCheckBiometrics;
//     bool isSupported = await auth.isDeviceSupported();

//     print("Can check biometrics: $canCheckBiometrics");
//     print("Device supports biometrics: $isSupported");

//     if (canCheckBiometrics && isSupported) {
//       print("Prompting biometric dialog...");
//       bool didAuthenticate = await auth.authenticate(
//         localizedReason: 'Please authenticate to access your passwords',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//           useErrorDialogs: true,
//         ),
//       );

//       print("Authentication success: $didAuthenticate");

//       if (didAuthenticate) {
//         setState(() {
//           _authenticated = true;
//         });
//         loaddetails();
//       }
//     } else {
//       print("This app requires a biometric authentication to continue..");
//     }
//   } catch (e) {
//     print("Authentication error: $e");
//   }
// }


//   void clearOldDataAndLoad() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.remove('received_details');  // clear old invalid data once here
//   loaddetails();
// }

//   void loaddetails() async{
//     final prefer= await SharedPreferences.getInstance();
//     List<String> savedList= prefer.getStringList('received_details') ?? [];
//     setState(() {
//       saveddetails=savedList;
//     });
//   }

//  int selectedindex=0;
//  final List<Widget> page=[
//   Homepage(),
//   settingspage(),
//  ];
//   void bottomfunc(int index){
//    setState(() {
//      page.elementAt(selectedindex);
//    });
//   }


  
//   Widget build(BuildContext context) {

//     if (!_authenticated) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Please authenticate to continue...'),
//       ),
//     );
//   }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Password Vault'),
//       ),
//       body: ListView.builder(
//         itemCount: saveddetails.length,
//         itemBuilder:(context,index){
//            Map<String,dynamic> entry= jsonDecode(saveddetails[index]);
//            String appname=entry['appname'];
//            String username=entry['username'];
//            String password=entry['password'];

//           return ListTile(
//             leading: Icon(Icons.settings_applications),
//             title: Text(appname),
//             subtitle: Text(username),
//             trailing: IconButton(onPressed: (){
//               showDialog(
//                 context: context, 
//                 builder: (BuildContext context){
//                   return AlertDialog(
//                     title: Text("password: ${entry['appname']}"),
//                     contentPadding:EdgeInsets.all(15),
//                     content: Text(entry['password']),
//                     actions: [
//                       TextButton(onPressed: (){Navigator.pop(context);}, child: Text('close'),)
//                     ],
//                   );
//                 });
//             }, icon: Icon(Icons.visibility_off)),
//           );
//         }),
//       floatingActionButton: FloatingActionButton(onPressed: (){
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context)=>Addpassword()));}),
//           bottomNavigationBar: BottomNavigationBar(
//             onTap: bottomfunc,
//             items: [
//             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//             BottomNavigationBarItem(icon: Icon(Icons.settings),label:'settings'),
//             ], ));
//   }
// }