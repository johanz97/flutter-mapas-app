part of 'widgets.dart';

class BtnSeguirUbicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapaBloc, MapaState>(
      builder: (context, state) => _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    final mapaBloc = context.read<MapaBloc>();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
              mapaBloc.state.seguirUbicacion
                  ? Icons.directions_run
                  : Icons.accessibility_new,
              color: Colors.black87),
          onPressed: () {
            mapaBloc.add(OnSeguirUbicacion());
          },
        ),
      ),
    );
  }
}
