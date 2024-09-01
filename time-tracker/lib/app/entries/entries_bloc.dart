import 'package:my_app/app/entries/daily_jobs_details.dart';
import 'package:my_app/app/entries/entries_list_tile.dart';
import 'package:my_app/app/entries/models/entry_job.dart';
import 'package:my_app/app/entry_page/models/entries.dart';
import 'package:my_app/app/job_page/models/job.dart';
import 'package:my_app/service/database.dart';
import 'package:my_app/utils/format.dart';
import 'package:rxdart/rxdart.dart';

class EntriesBloc {
  EntriesBloc({required this.database});

  final Database database;

  Stream<List<EntryJob>> get _allEntriesStream => Rx.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        _entriesJobsStream,
      );

  static List<EntryJob> _entriesJobsStream(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      print('entry ${entry}');
      final Job job = jobs.firstWhere(
        (job) => job.id == entry.jobId,
        orElse: () =>
            Job(name: '', ratePerHour: 0, id: documentIdFromCurrentDate()),
      );

      return EntryJob(entry, job);
    }).toList();
  }

  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    print('allEntries ${allEntries}');

    if (allEntries.isEmpty) {
      return [];
    }

    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: Format.currency(dailyJobsDetails.pay),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
