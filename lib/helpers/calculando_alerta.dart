part of 'helpers.dart';

void calculandoAlerta(BuildContext context) {
  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Espere por favor'),
        content: Text('Calculando ruta'),
      ),
    );
  }
}
