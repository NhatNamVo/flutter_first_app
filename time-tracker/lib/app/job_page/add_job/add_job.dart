import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/job_page/models/job.dart';
import 'package:my_app/common_wiget/dialog/show_alert_dialog.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/database.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key, required this.database, this.job});

  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context, { required Database database, Job? job}) async {
    await Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
      builder: (context) => JobForm(database: database, job: job),
    ));
  }

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;

    if (form?.validate() == true) {
      form?.save();
      return true;
    }

    return false;
  }

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _ratePerHourController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  late String _name = '';
  late int _rate = 0;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job?.name ?? '';
      _rate = widget.job?.ratePerHour ?? 0;
    }


  }

  Future<void> _submit() async {
    try {
      if (!_validateAndSaveForm()) {
        print('form is not saved');
        return;
      }

      if (widget.job?.id == null) {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();

        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please chose a different job name',
              defaultActionText: 'Ok'
          );

          return;
        }
      }

      final id = widget.job?.id ?? documentIdFromCurrentDate();

      final job = Job(name: _name, ratePerHour: _rate, id: id);
      await widget.database.setJob(job);

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
            title: Text(widget.job != null ? 'Edit Job' : 'New Job'),
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
      TextFormField(
        initialValue: _name,
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        focusNode: _nameFocusNode,
        validator: (value) {
          if (!value!.isNotEmpty) {
            return 'Please enter name';
          }

          return null;
        },
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(_ratePerHourFocusNode);
        },
        onSaved: (value) => _name = value ?? '',
      ),
      const SizedBox(
        height: 12.0,
      ),
      TextFormField(
        initialValue: '${_rate}',
        decoration: const InputDecoration(
          labelText: 'Rate',
          border: OutlineInputBorder(),
        ),
        focusNode: _ratePerHourFocusNode,
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (value) {
          if (!value!.isNotEmpty) {
            return 'Please enter rate per hour';
          }

          return null;
        },
        onSaved: (value) => _rate = int.tryParse(value ?? '') ?? 0,

        onEditingComplete: () {
          _submit();
        },
      ),
      const SizedBox(
        height: 12.0,
      ),
    ];
  }
}
