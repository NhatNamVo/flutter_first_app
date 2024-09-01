import 'package:my_app/app/entry_page/models/entries.dart';
import 'package:my_app/app/job_page/models/job.dart';

class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry? entry;
  final Job? job;
}
