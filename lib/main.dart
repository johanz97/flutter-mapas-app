import 'package:flutter/material.dart';
import 'package:mapas_app/pages/acceso_gps_page.dart';
import 'package:mapas_app/pages/loading_page.dart';
import 'package:mapas_app/pages/mapa_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapas App',
      home: LoadingPage(),
      routes: {
        'loading': (_) => LoadingPage(),
        'mapa': (_) => MapaPage(),
        'acceso_gps': (_) => AccesoGpsPage()
      },
    );
  }
}
