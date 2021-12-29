import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertaskswift/Edituserdeta.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Colorfile.dart';
import 'Createuser.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {


  List userlist = [];

  var netname, ipadd, modelname, androidid, lat, long, city, address, postcode;


  Future<void> userlists() async {

    final db = await SharedPreferences.getInstance();
    final token = db.get("token");

    var url = new Uri.https("reqres.in", "/api/users",{
      "page": "2",
    });


   try{

     final http.Response response = await http.get(url,
       headers: {
         "Content-type": "application/json",
         "Accept": "application/json",
         'Authorization': 'Bearer $token',
       },
     );

     print(response);

     if (response.statusCode == 200) {
       var dataa = json.decode(response.body);
       var datalist = dataa["data"];

       setState(() {
         imgvis = true;
         userlist = datalist;
       });

       Map map = {
         "userlist": datalist
       };

       var userdata = json.encode(map);

       db.setString("userlistdata", userdata);
       
     } else {
     }

   }catch(e){


     String dataus = db.get("userlistdata").toString();
     var valueMap = json.decode(dataus);
     var userdatas = valueMap["userlist"];

     setState(() {
       userlist = userdatas;
       imgvis = false;
     });



   }



  }

  Future<void> deleteuser(var id) async {


    var url = new Uri.https("reqres.in", "/api/users/$id");


    final http.Response response = await http.delete(url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
    );

    print(response);

    if (response.statusCode == 204) {
      var dataa = json.decode(response.body);
      print(dataa);




    } else {

      final snackBar2 = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Invalid User Id or Password",style: TextStyle(color: Colors.yellow),textAlign: TextAlign.center),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }


  }

  var id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userlists();
    getCurrentLocation();
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {

        if(city == "Mumbai"){

          deleteuser(id);
          Navigator.of(context).pop();

        }else{
          final snackBar2 = SnackBar(
            backgroundColor: Colors.red,
            content: Text("Sorry you dont delete user on your current location.",style: TextStyle(color: Colors.yellow),textAlign: TextAlign.center),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
          Navigator.of(context).pop();
        }

      },
    );

    Widget okButton2 = FlatButton(
      child: Text("Cancle"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm",style: TextStyle(color: Primarycolor,fontWeight: FontWeight.bold),),
      content: Text("Do you want Delete User?"),
      actions: [
        okButton2,
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

  bool imgvis = true;
  late Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Dashboard"),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Createuser() ));
                      },
                      icon:Icon(Icons.person_add,),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: ListView.builder(
                      itemCount: userlist.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context,index){
                        return Container(
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Visibility(
                                      visible: imgvis,
                                      child: FadeInImage.assetNetwork(
                                        placeholder:'assets/userdet.png',
                                        image: userlist[index]["avatar"],height: 50,width: 50,),
                                      replacement: Image.asset('assets/userdet.png',height: 50,width: 50,),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Name: " + userlist[index]["first_name"],style: TextStyle(fontWeight: FontWeight.bold), ),
                                        Text("Email: " + userlist[index]["email"] ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap:(){
                                          setState(() {
                                            String name = userlist[index]["first_name"];
                                            String email = userlist[index]["email"];
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Edituser(name: name, enail: email) ));
                                          });
                                       },
                                        child: Icon(Icons.edit)),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          id = userlist[index]["id"];
                                          showAlertDialog(context);
                                        });
                                      },
                                        child: Icon(Icons.delete)),
                                  ],
                                )
                              ],
                            ),
                          )
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) {

      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();

    }).catchError((e) {
      print(e);
    });
  }
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        lat = _currentPosition.latitude;
        long = _currentPosition.longitude;
        address = place.street!;
        city = place.locality!;
        postcode = place.postalCode!;
      });


    } catch (e) {
      print(e);
    }
  }

}



