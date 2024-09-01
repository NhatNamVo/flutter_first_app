import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonSystem extends StatelessWidget {
  ButtonSystem(
      {Key? key,
      this.icon,
      this.textColor = Colors.white,
      this.height = 35.0,
      required this.label,
      this.bgColor = Colors.green,
      this.borderRadius = 12.0,  
      this.onPressed});

  final Image? icon;
  final String label;
  final Color bgColor;
  final double height;
  final Color? textColor;
  final double borderRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(label, style: TextStyle(color: textColor),),
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
        onPressed: onPressed,
      ),
    );
  }
}
