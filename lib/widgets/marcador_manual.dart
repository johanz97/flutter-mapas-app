part of 'widgets.dart';

class MarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusquedaBloc, BusquedaState>(
      builder: (context, state) {
        if (state.seleccionManual) {
          return _BuildMarcadorManual();
        } else {
          return Container();
        }
      },
    );
  }
}

class _BuildMarcadorManual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 70,
          left: 20,
          child: FadeInLeft(
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  context
                      .read<BusquedaBloc>()
                      .add(OnDesactivarMarcadorManual());
                },
              ),
            ),
          ),
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: BounceInDown(
              child: const Icon(
                Icons.location_on,
                size: 30,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 70,
            left: 40,
            child: FadeIn(
              duration: const Duration(milliseconds: 2000),
              child: MaterialButton(
                minWidth: width - 120,
                child: const Text(
                  'Confirmar destino',
                  style: TextStyle(color: Colors.white),
                ),
                shape: const StadiumBorder(),
                elevation: 0,
                splashColor: Colors.transparent,
                color: Colors.black,
                onPressed: () {
                  calcularDestino(context);
                },
              ),
            ))
      ],
    );
  }

  void calcularDestino(BuildContext context) async {
    calculandoAlerta(context);
    final trafficService = TrafficService();
    final mapaBloc = context.read<MapaBloc>();
    final inicio = context.read<MiUbicacionBloc>().state.ubicacion;
    final destino = mapaBloc.state.ubicacionCentral;
    //Obtener informacion del destino
    final reverseQueryResponse =
        await trafficService.getCoordenadasInfo(destino!);
    final trafficResponse =
        await trafficService.getCordsInicioFin(inicio!, destino);
    final geometry = trafficResponse.routes[0].geometry;
    final duration = trafficResponse.routes[0].duration;
    final distance = trafficResponse.routes[0].distance;
    final nombreDestino = reverseQueryResponse.features[0].text;
    //Decodificar los puntos del geometry
    final points = Poly.Polyline.Decode(encodedString: geometry, precision: 6)
        .decodedCoords;
    final List<LatLng> cordsList =
        points.map((point) => LatLng(point[0], point[1])).toList();
    mapaBloc.add(
        OnCrearRutaInicioDestino(cordsList, distance, duration, nombreDestino));
    Navigator.of(context).pop();
    context.read<BusquedaBloc>().add(OnDesactivarMarcadorManual());
  }
}
