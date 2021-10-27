part of 'busqueda_bloc.dart';

@immutable
class BusquedaState {
  final bool seleccionManual;

  const BusquedaState({this.seleccionManual = false});

  BusquedaState copyWidth({bool? seleccionManual}) =>
      BusquedaState(seleccionManual: seleccionManual ?? this.seleccionManual);
}
