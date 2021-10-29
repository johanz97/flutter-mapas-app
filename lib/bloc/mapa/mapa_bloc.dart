import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:mapas_app/helpers/helpers.dart';
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

  Polyline _miRutaDestino = const Polyline(
      polylineId: PolylineId('mi_ruta_destino'),
      width: 4,
      color: Colors.black87);

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
    } else if (event is OnCrearRutaInicioDestino) {
      yield* _onCrearRutaInicioDestino(event);
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

  Stream<MapaState> _onCrearRutaInicioDestino(
      OnCrearRutaInicioDestino event) async* {
    _miRutaDestino = _miRutaDestino.copyWith(pointsParam: event.coordenadas);
    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = _miRutaDestino;
    //Iconos
    //final iconIncio = await getAssetImageMarker();
    final iconIncio = await getMarkerInicioIcon(event.duracion.toInt());
    //final iconDestino = await getNetworkImageMarker();
    final iconDestino =
        await getMarkerDestinoIcon(event.nombreDestino, event.distancia);
    //Marcadores
    final markerInicio = Marker(
        icon: iconIncio,
        markerId: const MarkerId('inicio'),
        anchor: const Offset(0, 1),
        position: event.coordenadas[0],
        infoWindow: InfoWindow(
            title: 'Inicio',
            snippet: 'Duracion: ${(event.duracion / 60).floor()} minutos'));
    double kilometros = event.distancia / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;
    final markerFinal = Marker(
        icon: iconDestino,
        anchor: const Offset(0, 1),
        markerId: const MarkerId('destino'),
        position: event.coordenadas[event.coordenadas.length - 1],
        infoWindow: InfoWindow(
            title: event.nombreDestino,
            snippet: 'Distancia: $kilometros kilómetros'));
    final newMarkers = {...state.markers};
    newMarkers['inicio'] = markerInicio;
    newMarkers['destino'] = markerFinal;
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      //_mapController.showMarkerInfoWindow(const MarkerId('inicio'));
      //_mapController.showMarkerInfoWindow(const MarkerId('destino'));
    });
    yield state.copyWith(polylines: currentPolylines, markers: newMarkers);
  }
}
