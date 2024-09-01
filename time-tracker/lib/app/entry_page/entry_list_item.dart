import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/app/entry_page/models/entries.dart';
import 'package:my_app/app/job_page/models/job.dart';
import 'package:my_app/utils/format.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem(
      {super.key, required this.entry, required this.job, required this.onTap});

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContent(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final startDate = Format.date(entry.start);
    final endDate = Format.date(entry.end);
    final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    final durationFormatted = Format.hours(entry.durationInHours);

    final pay = job.ratePerHour * entry.durationInHours;
    final payFormatted = Format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(startDate, style: const TextStyle(fontSize: 18.0)),
          const SizedBox(
            width: 15.0,
          ),
          Text(endDate, style: const TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(
          children: <Widget>[
            Text('$startTime - $endTime',
                style: const TextStyle(fontSize: 16.0)),
            Expanded(child: Container()),
            Text(durationFormatted, style: const TextStyle(fontSize: 16.0)),
          ],
        )
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem(
      {required this.key, this.entry, this.job, this.onDismissed, this.onTap});

  final Key key;
  final Entry? entry;
  final Job? job;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: key,
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDismissed!(),
        child: EntryListItem(entry: entry!, job: job!, onTap: onTap!));
  }
}
