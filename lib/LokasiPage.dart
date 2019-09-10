import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'model/api.dart';
//import 'model/lokasiModel.dart';


//void main() => runApp(GeoListenPage());

class GeoListenPage extends StatefulWidget {

  final String title;
  final VoidCallback reload;
//  GeoListenPage(this.reload);
  GeoListenPage({this.reload, this.title});

  @override
  _GeoListenPageState createState() => _GeoListenPageState();
}

class _GeoListenPageState extends State<GeoListenPage> {
  Geolocator geolocator = Geolocator();

  Position userLocation;

  String latitude, longitude, user_id;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(baseUrl.tambahLokasi, body: {
      "latitude": latitude,
      "longitude": longitude,
      "user_id" : user_id

    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(print);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
//    return MaterialApp(
      return Scaffold(
        appBar: AppBar(
          title: new Text("Location"),

        ),
        body: Form(
          key : _key,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userLocation == null
                    ? CircularProgressIndicator()
                    : Text("Location:"
                    +
                    userLocation.latitude.toString() +
                    " " +
                    userLocation.longitude.toString()
                ),

                Column(
                  children: <Widget>[
                    new TextFormField(
                      onSaved: (e) => latitude = e,
                      decoration: InputDecoration(labelText: 'Latitude'),
                      initialValue: userLocation.latitude.toString(),
                    ),
                    new TextFormField(
                      onSaved: (e) => longitude = e,
                      decoration: InputDecoration(labelText: 'Longitude'),
                      initialValue: userLocation.longitude.toString(),
                    ),
                    new TextFormField(
                      onSaved: (e) => user_id = e,
                      decoration: InputDecoration(labelText: 'userID'),
//                      initialValue: userLocation.longitude.toString(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          _getLocation().then((value) {
                            setState(() {
                              userLocation = value;
                            });
                          });
                        },
                        color: Colors.blue,
                        child: Text(
                          "Get Location",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        check();
                      },
                      color: Colors.redAccent,
                      child: new Text("Simpan", style: TextStyle(color: Colors.white),),
                    ),
                  ],

                ),
              ],
            ),
          ),
        ),
      );
//    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}