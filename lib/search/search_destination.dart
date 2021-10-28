import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:mapas_app/models/search_response.dart';
import 'package:mapas_app/models/search_result.dart';
import 'package:mapas_app/services/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  // ignore: overridden_fields
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximidad;
  final List<SearchResult> historial;

  SearchDestination(this.proximidad, this.historial)
      : searchFieldLabel = 'Buscar',
        _trafficService = TrafficService();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, SearchResult(cancelo: true)),
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _construirResultadosSugerencias();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Colocar ubicacion'),
            onTap: () {
              close(context, SearchResult(cancelo: false, manual: true));
            },
          ),
          ...historial
              .map((result) => ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(result.nombreDestino!),
                    subtitle: Text(result.descripcion!),
                  ))
              .toList()
        ],
      );
    }
    return _construirResultadosSugerencias();
  }

  Widget _construirResultadosSugerencias() {
    if (query.isEmpty) return Container();
    _trafficService.getSugerenciasPorQuery(query.trim(), proximidad);
    return StreamBuilder(
      stream: _trafficService.sugerenciasStream,
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final lugares = snapshot.data!.features;
        if (lugares!.isEmpty) {
          return ListTile(
            title: Text('No hay resultados con $query'),
          );
        }
        return ListView.separated(
          itemCount: lugares.length,
          separatorBuilder: (_, i) => const Divider(),
          itemBuilder: (_, i) {
            final lugar = lugares[i];
            return ListTile(
              leading: const Icon(Icons.place),
              title: Text(lugar.textEs),
              subtitle: Text(lugar.placeNameEs),
              onTap: () {
                close(
                    context,
                    SearchResult(
                        cancelo: false,
                        manual: false,
                        position: LatLng(lugar.center[1], lugar.center[0]),
                        nombreDestino: lugar.textEs,
                        descripcion: lugar.placeNameEs));
              },
            );
          },
        );
      },
    );
  }
}
