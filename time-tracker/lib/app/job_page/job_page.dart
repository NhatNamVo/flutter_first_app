import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/entry_page/entry_page.dart';
import 'package:my_app/app/job_page/add_job/add_job.dart';
import 'package:my_app/app/job_page/list_item_builder.dart';
import 'package:my_app/app/job_page/list_job_title/list_job_title.dart';
import 'package:my_app/app/job_page/models/job.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/database.dart';
import 'package:provider/provider.dart';

class JobPage extends StatelessWidget {
  const JobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs'), actions: <Widget>[
        IconButton(
            onPressed: () => JobForm.show(context,
                database: Provider.of<Database>(context, listen: false)),
            icon: const Icon(Icons.add, size: 24.0))
      ]),
      body: _buildContent(context),
    );
  }
}

Widget _buildContent(BuildContext context) {
  final database = Provider.of<Database>(context, listen: false);
  database.jobsStream();

  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (error) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: error);
    }
  }

  return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
            snapshot: snapshot,
            itemBuilder: (context, job) => Dismissible(
                  key: ValueKey<Job>(job),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) => _delete(context, job),
                  direction: DismissDirection.endToStart,
                  child: ListJobTitle(
                    job: job,
                    onTab: () => EntryPage.show(context, job),
                  ),
                ));
      });
}
