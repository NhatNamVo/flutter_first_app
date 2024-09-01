import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/entry_page/add_entry/add_entry.dart';
import 'package:my_app/app/entry_page/entry_list_item.dart';
import 'package:my_app/app/entry_page/models/entries.dart';
import 'package:my_app/app/job_page/add_job/add_job.dart';
import 'package:my_app/app/job_page/list_item_builder.dart';
import 'package:my_app/app/job_page/models/job.dart';
import 'package:my_app/common_wiget/exception_alert_dialog/exception_alert_dialog.dart';
import 'package:my_app/service/database.dart';
import 'package:provider/provider.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key, required this.job, required this.database});

  final Job job;
  final Database database;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);

    await Navigator.of(context).push(CupertinoPageRoute(
      fullscreenDialog: false,
      builder: (context) => EntryPage(database: database, job: job),
    ));
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      database.deleteEntry(entry);
    } on FirebaseException catch (error) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final jobData = snapshot.data ?? job;

          return Scaffold(
            appBar: AppBar(
              title: Text(jobData.name),
              actions: <Widget>[
                IconButton(
                    onPressed: () =>
                        JobForm.show(context, database: database, job: jobData),
                    icon: const Icon(Icons.edit, size: 24)),
                const SizedBox(width: 4.0),
                IconButton(
                    onPressed: () => EntryForm.show(
                        context: context, database: database, job: jobData),
                    icon: const Icon(Icons.add, size: 24))
              ],
            ),
            body: _buildContent(context, jobData),
            
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder(
        stream: database.entriesStream(job: job),
        builder: (context, snapshot) {
          return ListItemsBuilder<Entry>(
              snapshot: snapshot,
              itemBuilder: (context, entry) {
                return DismissibleEntryListItem(
                    key: ValueKey(job.id),
                    job: job,
                    entry: entry,
                    onDismissed: () => _deleteEntry(context, entry),
                    onTap: () => EntryForm.show(
                        context: context,
                        database: database,
                        job: job,
                        entry: entry));
              });
        });
  }
}
