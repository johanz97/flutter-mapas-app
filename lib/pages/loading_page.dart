import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mapas_app/helpers/helpers.dart';
import 'package:mapas_app/pages/acceso_gps_page.dart';
import 'package:mapas_app/pages/mapa_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled()) {
        Navigator.pushReplacement(
            context, navegarMapaFadein(context, MapaPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkGpsLocation(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(snapshot.data),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }
        },
      ),
    );
  }

  Future checkGpsLocation(BuildContext context) async {
    //Permiso Gps
    final permisoGps = await Permission.location.isGranted;
    //Gps activo
    final gpsActivo = await Geolocator.isLocationServiceEnabled();
    if (permisoGps && gpsActivo) {
      Navigator.pushReplacement(
          context, navegarMapaFadein(context, MapaPage()));
      return '';
    } else if (!permisoGps) {
      Navigator.pushReplacement(
          context, navegarMapaFadein(context, AccesoGpsPage()));
      return 'Necesita permiso Gps';
    } else if (!gpsActivo) {
      return 'Active Gps';
    }
  }
}
