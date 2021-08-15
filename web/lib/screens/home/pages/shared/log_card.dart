import 'package:flutter/material.dart';
import 'package:web/models/log.dart';
import 'package:web/shared/constant.dart';
import 'package:web/shared/loading.dart';

enum LogMode { student, teacher }

class LogCard extends StatelessWidget {
  final UserLog userLog;
  final LogMode logMode;
  const LogCard({
    Key? key,
    required this.userLog,
    this.logMode = LogMode.student,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Image.network(
      userLog.picUrl,
      fit: BoxFit.fitWidth,
      loadingBuilder: (context, image, progress) => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: progress != null
              ? [
                  SizedBox(
                      height: _size.height * .5, child: const WaveLoading())
                ]
              : [
                  image,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        logMode == LogMode.teacher
                            ? Row(
                                children: [
                                  Text(
                                    'เลขประจำตัว',
                                    style: theme.textTheme.bodyText1!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(userLog.sid,
                                      style: theme.textTheme.bodyText1),
                                ],
                              )
                            : Row(
                                children: [
                                  Text('คาบ: ',
                                      style: theme.textTheme.bodyText1!
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                  Text(userLog.period,
                                      style: theme.textTheme.bodyText1),
                                ],
                              ),
                        Row(
                          children: [
                            Text('เวลา: ',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Text(userLog.time, style: theme.textTheme.bodyText1)
                          ],
                        ),
                        Row(
                          children: [
                            Text('สถานะ: ',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            statusWidgets(
                                userLog.status, theme.textTheme.bodyText1!),
                          ],
                        ),
                        SizedBox(height: theme.textTheme.bodyText1!.fontSize)
                      ],
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
