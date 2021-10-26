import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:meta/meta.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/themes/uber_map_theme.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  MapaBloc() : super(MapaState());
  //Controlador del mapa
  late GoogleMapController _mapController;

  //Polylines
  Polyline _miRuta = const Polyline(
      polylineId: PolylineId('mi_ruta'), width: 4, color: Colors.transparent);

  void initMapa(GoogleMapController controller) {
    if (!state.mapaListo) {
      _mapController = controller;
      _mapController.setMapStyle(jsonEncode(uberMapTheme));
      add(OnMapaListo());
    }
  }

  void moverCamara(LatLng destino) {
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    _mapController.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState(MapaEvent event) async* {
    if (event is OnMapaListo) {
      yield state.copyWith(mapaListo: true);
    } else if (event is OnActualizarUbicacion) {
      yield* _onActualizarUbicacion(event);
    } else if (event is OnMarcarRecorrido) {
      yield* _onMarcarRecorrido(event);
    } else if (event is OnSeguirUbicacion) {
      yield* _onSeguirUbicacion(event);
    } else if (event is OnMovioMapa) {
      yield state.copyWith(ubicacionCentral: event.centroMapa);
    }
  }

  Stream<MapaState> _onActualizarUbicacion(OnActualizarUbicacion event) async* {
    if (state.seguirUbicacion) {
      moverCamara(event.ubicacion);
    }
    final puntos = [..._miRuta.points, event.ubicacion];
    _miRuta = _miRuta.copyWith(pointsParam: puntos);
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;
    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    if (state.dibujarRecorrido) {
      _miRuta = _miRuta.copyWith(colorParam: Colors.black87);
    } else {
      _miRuta = _miRuta.copyWith(colorParam: Colors.transparent);
    }
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = _miRuta;
    yield state.copyWith(
        dibujarRecorrido: !state.dibujarRecorrido, polylines: currentPolylines);
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {
    if (!state.seguirUbicacion) {
      moverCamara(_miRuta.points[_miRuta.points.length - 1]);
    }
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }
}
