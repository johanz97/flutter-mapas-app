import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/models/traffic_response.dart';

class TrafficService {
  //Singleton
  TrafficService._privateConstructor();
  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService() {
    return _instance;
  }

  final _dio = Dio();
  final _baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apiKey =
      'pk.eyJ1Ijoiam9oYW56OTciLCJhIjoiY2t2OW4wMDZjOG5xYjJ1cGhiNmxyYWtvdSJ9.OyDYURtIf3riWHCNF5XZBg';

  Future<TrafficResponse> getCordsInicioFin(
      LatLng inicio, LatLng destino) async {
    final cordString =
        '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '$_baseUrl/mapbox/driving/$cordString';
    final resp = await _dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': _apiKey,
      'language': 'es'
    });
    final data = TrafficResponse.fromJson(resp.data);
    return data;
  }
}
