import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/entry_page/models/entries.dart';
import 'package:my_app/app/job_page/models/job.dart';
import 'package:my_app/common_wiget/date_time_picker/date_time_picker.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/database.dart';
import 'package:my_app/utils/format.dart';

class EntryForm extends StatefulWidget {
  const EntryForm(
      {super.key, required this.database, required this.job, this.entry});

  final Database database;
  final Job job;
  final Entry? entry;

  static Future<void> show(
      {required BuildContext context,
      required Database database,
      required Job job,
      Entry? entry}) async {
    await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
      builder: (context) =>
          EntryForm(database: database, job: job, entry: entry),
    ));
  }

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;

    if (form?.validate() == true) {
      form?.save();
      return true;
    }

    return false;
  }

  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  late String _comment;

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);

    final id = widget.entry?.id ?? documentIdFromCurrentDate();

    return Entry(
        id: id,
        start: start,
        end: end,
        comment: _comment,
        jobId: widget.job.id);
  }

  Future<void> _submit() async {
    try {
      final currentEntry = _entryFromState();
      await widget.database.setEntry(
        currentEntry
      );

      Navigator.of(context).pop();

    } on FirebaseException catch (error) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 5.0,
            title: Text(widget.job != null ? 'Update' : 'Create'),
            actions: <Widget>[
              IconButton(
                  onPressed: _submit,
                  icon: const Icon(
                    Icons.save,
                    size: 24.0,
                  ))
            ]),
        body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Center(
                child: SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildContext(context),
                    ),
                  )
                ],
              ),
            ))));
  }

  Widget _buildContext(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Form(
        key: _formKey,
        child: SizedBox(
          width: screenWidth * 0.9 - 32,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren()),
        ));
  }

  List<Widget> _buildChildren() {
    return [
      _buildStartDate(),
      _buildEndDate(),
      const SizedBox(
        height: 12.0,
      ),
      _buildDuration(),
      const SizedBox(
        height: 12.0,
      ),
      _buildComment(),
    ];
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      selectDate: (date) => setState(() => _startDate = date),
      selectTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      selectDate: (date) => setState(() => _endDate = date),
      selectTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    print(currentEntry.durationInHours);

    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Duration: ${Format.hours(currentEntry.durationInHours)}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ]);
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: const InputDecoration(
          hintText: 'Comment',
          labelStyle: TextStyle(fontSize: 20.0, color: Colors.black)),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }
}
