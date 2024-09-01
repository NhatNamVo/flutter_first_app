import 'dart:async';

abstract class TimeCounterBase {
  int get seconds;
  Stream<int> get timeStream;

  void dispose();
  void onStart();
  void onPause();
  void onResume();
  void onFinish();
  void onReset();
}

class TimeCounter implements TimeCounterBase {
  @override
  late int seconds;

  final StreamController<int> _timeStreamController = StreamController();

  StreamSubscription? _timeSubcription;

  int _start = 0;

  @override
  Stream<int> get timeStream => _timeStreamController.stream;

  @override
  void dispose() {
    _timeStreamController.close();
  }

  @override
  void onStart() {
    _timeSubcription = Stream.periodic(const Duration(seconds: 1),
        (computationCount) => _start + computationCount).listen(
      (event) {
        seconds = event;
        _timeStreamController.add(event);
      },
    );
  }

  @override
  void onResume() {
    if (_timeSubcription?.isPaused ?? false) {
      _timeSubcription?.resume();
    }
  }

  @override
  void onPause() {
    if (!(_timeSubcription?.isPaused ?? true)) {
      _timeSubcription?.pause();
    }
  }

  @override
  void onFinish() {
    _timeSubcription?.cancel();
    _timeSubcription = null;
  }

  @override
  void onReset() {
    _timeSubcription?.cancel();
    _timeSubcription = null;
    onStart();
  }
}

extension IntToTime on int {
  int get hour => _getHour();

  int _getHour() {
    return (this / 3600).floor();
  }

  int get minute => _getMinute();

  int _getMinute() {
    return (this / 60).floor() % 60;
  }

  int get second => _getSecond();

  int _getSecond() {
    return this % 60;
  }

  int get tens => _getTens();

  int _getTens() {
    if (this >= 10) {
      return ((this - (this % 10)) / 10).round();
    }
    return 0;
  }

  int get ones => _getOnes();

  int _getOnes() {
    return this % 10;
  }
}