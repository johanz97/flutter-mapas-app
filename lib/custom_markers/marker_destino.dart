part of 'custom_markers.dart';

class MarkerDestinoPainter extends CustomPainter {
  final String descripcion;
  final double metros;

  MarkerDestinoPainter({required this.descripcion, required this.metros});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;
    const double circuloNegroR = 20;
    const double circuloBlancoR = 7;

    //Circulo negro
    canvas.drawCircle(Offset(circuloNegroR, size.height - circuloNegroR),
        circuloNegroR, paint);

    //Circulo blanco
    paint.color = Colors.white;
    canvas.drawCircle(Offset(circuloNegroR, size.height - circuloNegroR),
        circuloBlancoR, paint);

    //Sombra
    final Path path = Path();
    path.moveTo(0, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(0, 100);
    canvas.drawShadow(path, Colors.black87, 10, false);

    //Caja blanca
    final cajaBlanca = Rect.fromLTWH(0, 20, size.width - 10, 80);
    canvas.drawRect(cajaBlanca, paint);

    //Caja negra
    paint.color = Colors.black;
    const cajaNegra = Rect.fromLTWH(0, 20, 70, 80);
    canvas.drawRect(cajaNegra, paint);

    //Dibujar textos
    double kilometros = metros / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;
    TextSpan textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w400),
        text: '$kilometros');
    TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(minWidth: 80, maxWidth: 80);
    textPainter.paint(canvas, const Offset(-5, 35));

    //Minutos
    textSpan = const TextSpan(
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
        text: 'Km');
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center)
      ..layout(maxWidth: 70);
    textPainter.paint(canvas, const Offset(20, 67));

    //Mi ubicación
    textSpan = TextSpan(
        style: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
        text: descripcion);
    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        maxLines: 2,
        ellipsis: '...')
      ..layout(maxWidth: size.width - 100);
    textPainter.paint(canvas, const Offset(90, 35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
