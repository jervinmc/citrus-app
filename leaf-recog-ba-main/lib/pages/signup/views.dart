import 'package:calamansi_recognition/config/global.dart';
import 'package:calamansi_recognition/pages/login/views.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
class SignUp extends StatefulWidget {


  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static String BASE_URL = ''+Global.url+'/register';
  bool _load = false;
  void notify(DialogType type , title, desc){
      AwesomeDialog(
                context: context,
                dialogType:type,
                animType: AnimType.BOTTOMSLIDE,
                title: title,
                desc: desc,
                btnOkOnPress: () {
                  if(DialogType.ERROR==type){
                    
                  }
                  else{
               
                  }
                },
                )..show();
    }
  void SignUp() async {
    if(_email.text==null || _password.text==null || _email.text=='' || _password.text=='') {
        notify(DialogType.ERROR,'Field is required.','Please fill up the form.');
        
        return;
    }
    if(_password.text.length<9){
      notify(DialogType.ERROR,'Password must be at least 8 characters.','');
      return ;
    }
      var params = {
        "email":_email.text,
        "password":_password.text
      };
      setState(() {
        _load=true;
      });
      final response = await http.post(Uri.parse(BASE_URL),headers: {"Content-Type": "application/json"},body:json.encode(params));
      if(response.statusCode==201){
        setState(() {
          _load=false;
        });
        notify(DialogType.SUCCES, 'Successfully Created', 'You may now enjoy your account.');
        _email.text="";
        _password.text="";
      }
      else{
        notify(DialogType.ERROR, 'Account is already exists.', "Please use other account.");
       setState(() {
         _load=false;
       });
      }
      
  }
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      children: <Widget>[
                        Image.asset("assets/images/logo.jpg",height: 200,),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            controller: _email,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(color: Colors.grey[800]),
                                hintText: "Email",
                                fillColor: Colors.white70),
                          )
                        ),
                        Container(
                          height: 100,
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                                    obscureText: true,
                                    controller: _password,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(8.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                        ),
                                        filled: true,
                                        hintStyle: TextStyle(color: Colors.grey[800]),
                                        hintText: "Password",
                                        fillColor: Colors.white70),
                                  )
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          width: 250,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xff68c3a3)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Register'),
                            onPressed: () {
                            SignUp();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          width: 250,
                          child: ElevatedButton(
                              child: Text('Cancel',style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              Get.toNamed('/login');
                            },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ),
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                            
                              
                          ),       
                          ),
                           _load ? Container(
                            color: Colors.white10,
                            width: 70.0,
                            height: 70.0,
                            child: new Padding(padding: const EdgeInsets.all(5.0),child: new Center(child: new CircularProgressIndicator())),
                          ) : Text('')
                      ],
                  ),
                ),
              ),
              
            ],
          )
    ),
    );
}
}