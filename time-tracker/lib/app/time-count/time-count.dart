import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/app/time-count/widget/text_widget.dart';
import 'package:my_app/service/time_count.dart';

class TimeCount extends StatefulWidget {
  TimeCount({super.key});

  final TimeCounterBase timeCounter = TimeCounter();

  // timeCounter.onStart();

  @override
  State<TimeCount> createState() => _TimeCountState();
}

class _TimeCountState extends State<TimeCount> {
  @override
  void initState() {
    super.initState();
    widget.timeCounter.onStart();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.timeCounter.timeStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final int seconds = widget.timeCounter.seconds;
            var separateWidget = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                ':',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'BlackOpsOne',
                    ),
                textAlign: TextAlign.center,
              ),
            );

            return Center(
                child: SizedBox(
                width: double.infinity,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TimeWidget(number: seconds.hour.tens),
                      TimeWidget(number: seconds.hour.ones),
                      separateWidget,
                      TimeWidget(number: seconds.minute.tens),
                      TimeWidget(number: seconds.minute.ones),
                      separateWidget,
                      TimeWidget(number: seconds.second.tens),
                      TimeWidget(number: seconds.second.ones),
                    ]),
                )
              );
          }

          return const SizedBox();
        });
  }
}
