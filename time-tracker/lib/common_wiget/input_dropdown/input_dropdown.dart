import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    super.key,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  });

  final String? labelText;
  final String? valueText;
  final TextStyle? valueStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText ?? '',
          ),
          baseStyle: valueStyle,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(valueText ?? '', style: valueStyle),
                Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade700
                      : Colors.white70,
                )
              ])),
    );
  }
}
