import 'package:web/shared/constant.dart';

/*
const Map<String, String> _periodStringRef = {
  '1': '08:15-09:00',
  '2': '09:00-09:45',
  '3': '09:50-10:35',
  '4': '10:35-11:20',
  '5': '12:30-13:15',
  '6': '13:15-14:00',
  '7': '14:05-14:50',
  '8': '14:50-15:35',
  '9': '15:35-16:20',
};
Map<String, List<int>> _periodRef = _periodStringRef.map<String, List<int>>(
    (key, value) => MapEntry(
        key,
        value.split('-')
            .map((str) => DateTime.parse('1970-01-01T${str}Z').millisecondsSinceEpoch)
            .toList()));
*/
const int _allowedBeforeClass = 5 * 60 * 1000;
const int _canLateBy = 10 * 60 * 1000;
const Map<String, List<int>> periodRef = {
  '1': [29700000 - _allowedBeforeClass, 32400000 - _allowedBeforeClass],
  '2': [32400000 - _allowedBeforeClass, 35100000 - _allowedBeforeClass],
  '3': [35400000 - _allowedBeforeClass, 38100000 - _allowedBeforeClass],
  '4': [38100000 - _allowedBeforeClass, 40800000 - _allowedBeforeClass],
  '5': [45000000 - _allowedBeforeClass, 47700000 - _allowedBeforeClass],
  '6': [47700000 - _allowedBeforeClass, 50400000 - _allowedBeforeClass],
  '7': [50700000 - _allowedBeforeClass, 53400000 - _allowedBeforeClass],
  '8': [53400000 - _allowedBeforeClass, 56100000 - _allowedBeforeClass],
  '9': [56100000 - _allowedBeforeClass, 58800000 - _allowedBeforeClass],
};

///Get the timestamp since the state of the day
int getDateTimestamp(int timestamp) {
  return DateTime.parse(DateTime.fromMillisecondsSinceEpoch(timestamp)
          .toString()
          .split(' ')[0])
      .millisecondsSinceEpoch;
}

class UserLog {
  final String sid;
  final int timestamp;
  late String picUrl;
  late String time;
  late String period;
  Status? status;

  List<dynamic>? _getPeriodAndStatus(int timestamp) {
    // Get the time on 0:00 that day
    int day = getDateTimestamp(timestamp);

    // Get milliseconds since that day started
    int time = timestamp - day;

    for (MapEntry<String, List<int>> entry in periodRef.entries) {
      // if time in period range
      if (time >= entry.value[0] && time <= entry.value[1]) {
        String period = entry.key;
        Status status =
            (time - (entry.value[0] + _allowedBeforeClass)) < _canLateBy
                ? Status.onTime
                : Status.late;
        return [period, status];
      }
    }
    // if not in the period range,
    return null;
  }

  String _getPicUrl({required int timestamp, required String sid}) {
    // Link Format: https://storage.googleapis.com/<BUCKET_NAME>/<BLOB_NAME>
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp).toUtc();
    String foldername =
        "${dt.year.toString().padLeft(2, '0')}${dt.month.toString().padLeft(2, '0')}";
    String filename =
        "$foldername${dt.day.toString().padLeft(2, '0')}${dt.hour.toString().padLeft(2, '0')}${dt.minute.toString().padLeft(2, '0')}${dt.second.toString().padLeft(2, '0')}-$sid.jpg";

    return "https://storage.googleapis.com/$storageBucketName/$foldername/$filename";
  }

  UserLog({
    required this.sid,
    required this.timestamp,
  }) {
    dynamic temp = _getPeriodAndStatus(timestamp);
    if (temp != null) {
      period = temp[0];
      status = temp[1];
    } else {
      period = "";
      status = null;
    }
    time = DateTime.fromMillisecondsSinceEpoch(timestamp)
        .toString()
        .split(' ')
        .last
        .substring(0, 5); // Get the time in HH:MM format
    picUrl = _getPicUrl(timestamp: timestamp, sid: sid);
  }
}
