import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Colorfile.dart';
import 'MainPage.dart';

class Edituser extends StatefulWidget {

  final String name,enail;
  const Edituser({Key? key,
    required this.name,
    required this.enail}) : super(key: key);

  @override
  _EdituserState createState() => _EdituserState();
}

class _EdituserState extends State<Edituser> {

  TextEditingController username = TextEditingController();
  TextEditingController jobdet = TextEditingController();


  Future<void> updateuser(var name, var job) async {

    var url = new Uri.https("reqres.in", "/api/users");

    Map map = {
      "name": name,
      "job": job
    };

    var body = json.encode(map);

    final http.Response response = await http.put(url,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: body
    );

    print(response);

    if (response.statusCode == 200) {
      var dataa = json.decode(response.body);
      showAlertDialog(context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));

    } else {


    }


  }

  void userdata(){

    username.text = widget.name;
    jobdet.text = widget.enail;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdata();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Secondarycolor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                ),
                margin: EdgeInsets.only(top: 50),
                child: Icon(Icons.person,size: 100,),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Text("Update",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Primarycolor,fontStyle: FontStyle.italic,shadows: [Shadow(color: Colors.white,offset: Offset(0, -5))]),)
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                        child: Text("User Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Primarycolor,fontStyle: FontStyle.italic,shadows: [Shadow(color: Colors.white,offset: Offset(0,-5))]),)
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10,right: 10,top: 30),
                child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                        labelText: "Your Name",
                        labelStyle: TextStyle(
                          color: Primarycolor,
                        ),
                        prefixIcon: Icon(Icons.drive_file_rename_outline,size: 30,color: Primarycolor,),
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
                  controller: jobdet,
                  decoration: InputDecoration(
                      labelText: "Your Email",
                      labelStyle: TextStyle(
                        color: Primarycolor,
                      ),
                      prefixIcon: Icon(Icons.drive_file_rename_outline,size: 30,color: Primarycolor,),
                      enabled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 2
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
                  ),
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

                    if(username.text == "" || jobdet.text == ""){

                      final snackBar2 = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Please Enter Required Details.",style: TextStyle(color: Colors.yellow),textAlign: TextAlign.center),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                    }

                    updateuser(username.text, jobdet.text);


                  },
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Mainpage()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Success",style: TextStyle(color: Primarycolor,fontWeight: FontWeight.bold),),
    content: Text("User Details update Successfully."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
