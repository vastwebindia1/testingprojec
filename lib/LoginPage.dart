
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertaskswift/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Colorfile.dart';
import 'package:http/http.dart' as http;

import 'Signuppage.dart';


class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {


  TextEditingController useremail = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> Logindet(var email, var pass) async {

    final db = await SharedPreferences.getInstance();
    var url = new Uri.https("reqres.in", "/api/login");

    Map map = {
      "email": email,
      "password": pass
    };

    var body = json.encode(map);

    final http.Response response = await http.post(url,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
      body: body
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      var token = dataa["token"];
      db.setString("token", token);

      Navigator.push(context, MaterialPageRoute(builder: (context) => Mainpage() ));

    } else {

      final snackBar2 = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Invalid User Id or Password",style: TextStyle(color: Colors.yellow),textAlign: TextAlign.center),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        bottomSheet: Container(height: 20,color: Primarycolor,) ,
        backgroundColor: Secondarycolor,
        body:SingleChildScrollView(
          child: Column(
            children: [

              Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Text("Welcome to",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Primarycolor,fontStyle: FontStyle.italic,shadows: [Shadow(color: Colors.white,offset: Offset(0, -5))]),)
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                        child: Text("Flutter",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Primarycolor,fontStyle: FontStyle.italic,shadows: [Shadow(color: Colors.white,offset: Offset(0,-5))]),)
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 40),
                child: TextFormField(
                    controller: useremail,
                    decoration: InputDecoration(
                        labelText: "Enter Email id",
                        labelStyle: TextStyle(
                          color: Primarycolor,
                        ),
                        prefixIcon: Icon(Icons.email,size: 30,color: Primarycolor,),
                        enabled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 10
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Primarycolor,
                              width: 2
                          ),
                          borderRadius: BorderRadius.circular(20),
                        )
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                child: TextFormField(
                     controller: password,
                     decoration: InputDecoration(
                        labelText: "Enter Password",
                        labelStyle: TextStyle(
                          color: Primarycolor,
                        ),
                        prefixIcon: Icon(Icons.lock,size: 30,color: Primarycolor,),
                        enabled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red,
                              width: 10
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Primarycolor,
                              width: 2
                          ),
                          borderRadius: BorderRadius.circular(20),
                        )
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30,right: 30,top: 20),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Primarycolor,
                      onPrimary: Secondarycolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      )
                  ),
                  onPressed: () {

                    FocusScopeNode currentFocus = FocusScope.of(context);
                    currentFocus.unfocus();

                    if(useremail.text == "" || password.text == ""){

                      final snackBar2 = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Please Enter Valid Id or Password",style: TextStyle(color: Colors.yellow),textAlign: TextAlign.center),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                    }

                    Logindet(useremail.text, password.text);

                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Mainpage() ));
                  },
                  child: Text("Login"),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text("OR",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
              ),
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup() ));
                    },
                    child: Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Primarycolor,fontStyle: FontStyle.italic),),
                  )
              )

            ],
          ),
        ) ,
      ),
    );
  }
}
