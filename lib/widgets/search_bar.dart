part of 'widgets.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (!state.seleccionManual) {
          return FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: buildSearchBar(context));
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: width,
          child: GestureDetector(
            onTap: () async {
              final proximidad =
                  context.read<MiUbicacionBloc>().state.ubicacion;
              final historial = context.read<BusquedaBloc>().state.historial;
              final resultado = await showSearch(
                  context: context,
                  delegate: SearchDestination(proximidad!, historial));
              retornoBusqueda(context, resultado!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              width: double.infinity,
              child: const Text(
                '¿Donde quieres ir?',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 5))
                  ]),
            ),
          )),
    );
  }

  Future retornoBusqueda(BuildContext context, SearchResult result) async {
    if (result.cancelo) return;

    final busquedaBloc = context.read<BusquedaBloc>();
    if (result.manual!) {
      busquedaBloc.add(OnActivarMarcadorManual());
      return;
    }

    calculandoAlerta(context);

    //Calcular la ruta
    final trafficService = TrafficService();
    final mapaBloc = context.read<MapaBloc>();

    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = result.position;
    final drivingResponse =
        await trafficService.getCordsInicioFin(inicio!, destino!);

    final geometry = drivingResponse.routes[0].geometry;
    final duration = drivingResponse.routes[0].duration;
    final distance = drivingResponse.routes[0].distance;
    final nombreDestino = result.nombreDestino;

    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6);
    final List<LatLng> rutaCoordenadas = points.decodedCoords
        .map((point) => LatLng(point[0], point[1]))
        .toList();

    mapaBloc.add(OnCrearRutaInicioDestino(
        rutaCoordenadas, distance, duration, nombreDestino!));
    Navigator.of(context).pop();

    //Agregar historial
    busquedaBloc.add(OnAgregarHistorial(result));
  }
}
