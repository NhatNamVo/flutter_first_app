import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/common_wiget/button/button.dart';

class SocialButton extends ButtonSystem {
  SocialButton({
    required String label,
    required Image icon,
    required VoidCallback onPressed,
    bgColor,
    height,
    textColor,
    borderRadius,
  })  : assert(label != null),
        super(
          label: label,
          icon: icon,
          onPressed: onPressed,
          bgColor: bgColor,
          height: height,
          textColor: textColor,
          borderRadius: borderRadius,
        );
}
