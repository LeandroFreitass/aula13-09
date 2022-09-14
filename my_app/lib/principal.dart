import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:location/location.dart';

String MsgCoordenada = "Sem valor";
String MsgCoordenadaAtualizada = "Sem valor";

class principal extends StatefulWidget {
  const principal({ Key? key }) : super(key: key);

  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {

  var location = new Location();
  late LocationData _locationData;
  bool _serviceEnabled = false;
  PermissionStatus  _permissionStatus = PermissionStatus.denied;

  void serviceStatus() async {
    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }
void obterPermissao() async {
  _permissionStatus = await location.hasPermission();
  if(_permissionStatus == PermissionStatus.denied) {
    _permissionStatus = await location.requestPermission();
    if (_permissionStatus != PermissionStatus.granted){
      return;
    }
  }
}

Future _obterLocalizacao() async{
  _locationData = await location.getLocation();
  return _locationData;
}
@override
void initState() {
  super.initState();
  location.changeSettings(interval: 300);
  location.onLocationChanged.listen((LocationData currentLocation) {
    setState(() {
      MsgCoordenadaAtualizada = currentLocation.latitude.toString() +
      "\n" +
      currentLocation.longitude.toString();
      print(currentLocation);
    });
   });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SItemas GPS")),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Usado o GPS"),
            Text(
              "Click para obter a coordenada",
              ),
              ElevatedButton(onPressed: ((){
                serviceStatus();
                if(_permissionStatus == PermissionStatus.denied){
                  obterPermissao();
                }else{
                  _obterLocalizacao().then((value) => {
                    setState(() {
                      MsgCoordenada = _locationData.latitude.toString() +
                      "\n" +
                      _locationData.longitude.toString();
                    })
                  });
                }

              }),
              child: Text("Click para obter coordenadas")),
              Text(MsgCoordenada),
              Text("Atualizada"),
              Text(MsgCoordenadaAtualizada)

          ],
        ),
      ),
      );
  }
}