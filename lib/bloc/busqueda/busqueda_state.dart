part of 'busqueda_bloc.dart';

@immutable
class BusquedaState {
  final bool seleccionManual;
  final List<SearchResult> historial;

  BusquedaState({this.seleccionManual = false, List<SearchResult>? historial})
      : historial = (historial == null) ? [] : historial;

  BusquedaState copyWidth(
          {bool? seleccionManual, List<SearchResult>? historial}) =>
      BusquedaState(
          seleccionManual: seleccionManual ?? this.seleccionManual,
          historial: historial ?? this.historial);
}
