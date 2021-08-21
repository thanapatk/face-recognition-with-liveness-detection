import 'dart:ui';

import 'package:flutter/cupertino.dart';
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
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          barrierDismissible: true,
          barrierColor: Colors.black54,
          pageBuilder: (context, _, __) =>
              FullScreenLogCard(userLog: userLog, logMode: logMode),
        ),
      ),
      child: Hero(
        tag: userLog.timestamp,
        child: _LogCard(userLog: userLog, logMode: logMode),
      ),
    );
  }
}

class FullScreenLogCard extends StatelessWidget {
  const FullScreenLogCard({
    Key? key,
    required this.userLog,
    required this.logMode,
  }) : super(key: key);

  final UserLog userLog;
  final LogMode logMode;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Hero(
            tag: userLog.timestamp,
            child: _LogCard(
              userLog: userLog,
              logMode: logMode,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  const _LogCard({
    Key? key,
    required this.userLog,
    required this.logMode,
  }) : super(key: key);

  final UserLog userLog;
  final LogMode logMode;

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
                      height: _size.height * .3, child: const WaveLoading())
                ]
              : [
                  image,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        logMode == LogMode.teacher
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
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
                                mainAxisSize: MainAxisSize.min,
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('เวลา: ',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Text(userLog.time, style: theme.textTheme.bodyText1)
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
