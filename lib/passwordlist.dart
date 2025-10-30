import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import './addpassword.dart';
import 'dart:convert';
import 'package:local_auth/local_auth.dart';


class Passwordlist extends StatefulWidget {
  const Passwordlist({super.key});

  @override
  State<Passwordlist> createState() => _Passwordlist();
}

class _Passwordlist extends State<Passwordlist> {
  @override

  final Map<String, IconData>appIcons={
    'facebook':Icons.facebook,
    'gmail':Icons.email,
    'instagram':Icons.camera_alt,
    'twitter': Icons.alternate_email,
    'linkedin': Icons.business,
    'snapchat': Icons.chat,
    'whatsapp': Icons.message,
    'amazon': Icons.shopping_cart,
    'flipkart': Icons.shopping_bag,
    'default':Icons.lock,
  };

final LocalAuthentication auth = LocalAuthentication();

//bool _authenticated = false;

  List<String> saveddetails=[];

  void initState() {
    super.initState();
    loaddetails();
  }
  


  void clearOldDataAndLoad() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('received_details');  // clear old invalid data once here
  loaddetails();
}

  void loaddetails() async{
    final prefer= await SharedPreferences.getInstance();
    List<String> savedList= prefer.getStringList('received_details') ?? [];
    setState(() {
      saveddetails=savedList;
    });
  }

  
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Password Vault'),
      ),
      body:saveddetails.isEmpty ? const Center(child: Text("No passwords saved yet.")): ListView.builder(
        itemCount: saveddetails.length,
        itemBuilder:(context,index){
           Map<String,dynamic> entry= jsonDecode(saveddetails[index]);
           String appname=entry['appname'];
           String username=entry['username'];
           String password=entry['password'];

          return ListTile(
            leading: Image.asset(
                'assets/images/${appname.toLowerCase().trim()}.png',
                 width: 40,
                 height: 40,
                 errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/default.png', width: 40, height: 40); },),
            title: Text(appname),
            subtitle: Text(username),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){
              showDialog(
                context: context, 
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("password: ${entry['appname']}"),
                    contentPadding:EdgeInsets.all(15),
                    content: Text(entry['password']),
                    actions: [
                      TextButton(onPressed: (){Navigator.pop(context);}, child: Text('close'),)
                    ],
                  );
                });
            }, icon: Icon(Icons.visibility_off)),
            IconButton(onPressed: (){
              showDialog(
                context: context, 
                builder:(BuildContext context){
                  return AlertDialog(
                    title: Text('delete details: ${entry['appname']}'),
                    content: Text('confirm to delete'),
                    actions: [
                      TextButton(onPressed: ()async{Navigator.pop(context);
                      setState(() {
                        saveddetails.removeAt(index);
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setStringList('received_details', saveddetails);
                      }, 
                  child:Text('delete'),),
                  TextButton(onPressed: (){
                  Navigator.pop(context);
                },child: Text('cancel'),)
                ],);
                }
                );
                }, 
            icon: Icon(Icons.delete)),
           ]
           ) 
          );
        }),
        );
  }
}