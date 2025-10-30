import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:passwordmanager/passwordlist.dart';
import 'package:passwordmanager/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './notifications.dart';
import './passwordlist.dart';


class Addpassword extends StatefulWidget {
  const Addpassword({super.key});

  @override
  State<Addpassword> createState() => _AddpasswordState();
}

class _AddpasswordState extends State<Addpassword> {

  final TextEditingController appname = TextEditingController();
  final TextEditingController username=TextEditingController();
  final TextEditingController password=TextEditingController();

  void save() async{

   final SharedPreferences prefer = await SharedPreferences.getInstance();

    List<String> details_list = prefer.getStringList('received_details') ?? [];

     // String entry="appname:${appname.text}, username:${username.text}, password:${password.text}"; storing in a single variable is difficult to use in the home page to use in listtile
    Map<String,String> entry ={
      'appname':appname.text,
      'username':username.text,
      'password':password.text
    };

    //convert to json string before storing
    String jsonentry = jsonEncode(entry);

    //add the json string to the list(details_list)
    details_list.add(jsonentry);
    prefer.setStringList('received_details', details_list);

    final SharedPreferences prefnotifi = await SharedPreferences.getInstance();
    bool received_notifi_details = prefnotifi.getBool('notification_enable')??false; 
    if(received_notifi_details==true){
        notificationservice.shownotification();
    }
  }
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your password'),
      ),
     body: Padding(
      padding: const EdgeInsets.all(10),
      child : SingleChildScrollView(
        child: Form(
      key: formkey,
      child: Column(
        children: [
          TextFormField(
            controller: appname,
            decoration: InputDecoration(border: OutlineInputBorder(),label: Text('App/website name')),
            validator: (value){
              if(value==null || value.isEmpty){
                  return 'Please enter the app/websit name';
              }
              else{
                return null;
              }
            }
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: username,
            decoration: InputDecoration(border:OutlineInputBorder(),label: Text('Email')),
            validator: (value){
              if(value==null || value.isEmpty){
                return('please enter the email');
              }
              else if(!RegExp(r'^[\w-\.]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                return('please enter the valid email');
              }
              else{
                  return null;
              }
            },
          ),
           SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            controller: password,
            decoration: InputDecoration(border: OutlineInputBorder(),label: Text('password')),
            validator:(value){
              if(value==null || value.isEmpty){
                return('please enter the password');
              }
              else if(!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{5,}$').hasMatch(value)){
                return('please enter the valid password.\nPassword must contain atleast one lower,\none upper and one special with min of 5 character ');
              }
              else{
                return null;
              }
            }
          ),
          SizedBox(height: 25),
          ElevatedButton(onPressed: (){
            if (formkey.currentState!.validate()) {
              save();
              Navigator.pushReplacement(
                context, 
               MaterialPageRoute(builder: (context)=>Passwordlist()),);
            }
          }, child: Text('Save'))
        ],
      )),
      ),
      ) ,
    );
  }

  @override
  void dispose() {
    appname.dispose();
    username.dispose();
    password.dispose();
    super.dispose();
  }
}