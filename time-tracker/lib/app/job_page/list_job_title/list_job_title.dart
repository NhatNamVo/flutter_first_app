import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/job_page/models/job.dart';

class ListJobTitle extends StatelessWidget {
  const ListJobTitle({super.key, required this.job, this.onTab});

  final Job job;
  final VoidCallback? onTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.keyboard_arrow_right),
      shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      onTap: onTab,
    );
  }
}
