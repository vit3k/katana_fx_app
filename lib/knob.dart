
import 'dart:math';

import 'package:flutter/material.dart';

class KnobPainter extends CustomPainter {
  var painter = Paint()
    ..color = Colors.blueGrey
    ..style = PaintingStyle.stroke
    ..strokeWidth = 18.0
    ..isAntiAlias = true;

  var valuePainter = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 18.0
    ..isAntiAlias = true;

  var minValue = -100;
  var maxValue = 100;
  var value = 0;

  KnobPainter(this.value, this.minValue, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(Rect.fromLTWH(9, 9, size.width - 9, size.height - 9), -1.3 * pi, 1.6*pi, false, painter);
    var ratio = (value - minValue) / (maxValue - minValue);
    canvas.drawArc(Rect.fromLTWH(9, 9, size.width - 9, size.height - 9), -1.3 * pi, ratio * 1.6*pi, false, valuePainter);
  }

  @override
  bool shouldRepaint(KnobPainter oldDelegate) {
    return value != oldDelegate.value;
  }
}

class Knob extends StatelessWidget {
  final minValue;
  final maxValue;
  final value;
  final void Function(int) onChanged;

  Knob(this.value, this.minValue, this.maxValue, {this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        var newValue = (value - details.primaryDelta.round()).clamp(minValue, maxValue);
        onChanged(newValue);
      },
      child: Container(
          width: 120,
          height: 120,
          child: CustomPaint(
            painter: KnobPainter(value, minValue, maxValue),
            child: Center(
                child: Text(value.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))
            ),
          )
      ),
    );
  }
}