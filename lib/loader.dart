import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: const AlwaysStoppedAnimation(90 / 360),
          child: Container(
            color: Colors.grey,
            width: 300,
            height: 700,
            //color: Colors.yellow,
            child: CustomPaint(painter: FaceOutlinePainter()),
          ),
        ),
      ),
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Path path = Path();
    path.moveTo(size.width / 3, 0); //Ax, Ay
    path.quadraticBezierTo(size.width, size.height / 8, size.width / 3,
        size.height / 4); //Bx, By, Cx, Cy
    path.quadraticBezierTo(0, 3 * size.height / 8, size.width / 2,
        size.height / 2); //Dx, Dy, Ex, Ey
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}
