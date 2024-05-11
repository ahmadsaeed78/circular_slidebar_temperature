import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Temperature Slider',
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _sliderValue = 0.5;
  int _currentTemperature = 20; // Initial temperature

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Circular Temperature Slider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperature: $_currentTemperature°C',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Container(
              width: 220,
              height: 220,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(220, 220),
                    painter: CircularSliderPainter(),
                  ),
                  Positioned(
                    left: 110 + 90 * math.cos(_sliderValue * 2 * math.pi - math.pi / 2),
                    top: 110 + 90 * math.sin(_sliderValue * 2 * math.pi - math.pi / 2),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          // Calculate angle from vertical center to touch position
                          double angle = math.atan2(
                            details.localPosition.dy - 110,
                            details.localPosition.dx - 110,
                          );

                          // Convert angle to a value between 0 and 1
                          _sliderValue = (angle + math.pi) / (2 * math.pi);

                          // Update current temperature based on slider value
                          _currentTemperature = ((_sliderValue * 100) + 10).toInt();
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularSliderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 20;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
