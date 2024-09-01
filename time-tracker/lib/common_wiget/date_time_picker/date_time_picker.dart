import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/common_wiget/input_dropdown/input_dropdown.dart';
import 'package:my_app/utils/format.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    super.key,
    this.labelText,
    this.selectDate,
    this.selectTime,
    this.selectedDate,
    this.selectedTime,
  });

  final String? labelText;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime>? selectDate;
  final ValueChanged<TimeOfDay>? selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2100),
        initialDate: selectedDate);

    if (pickedDate != null && pickedDate != selectedDate) {
      selectDate!(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
        context: context, initialTime: selectedTime ?? TimeOfDay.now());
    if (pickedTime != null && pickedTime != selectedTime) {
      selectTime!(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headlineSmall;

    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText ?? '',
            valueStyle: valueStyle,
            valueText: Format.date(selectedDate!),
            onPressed: () => _selectDate(context),
          )),
      const SizedBox(
        width: 12.0,
      ),
      Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime?.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          )),
    ]);
  }
}
