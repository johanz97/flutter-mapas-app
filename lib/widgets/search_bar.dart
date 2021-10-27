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
              final resultado = await showSearch(
                  context: context, delegate: SearchDestination());
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

  void retornoBusqueda(BuildContext context, SearchResult result) {
    if (result.cancelo) return;

    if (result.manual!) {
      context.read<BusquedaBloc>().add(OnActivarMarcadorManual());
      return;
    }
  }
}
