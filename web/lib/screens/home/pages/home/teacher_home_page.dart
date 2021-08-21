import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/shared/log_card.dart';
import 'package:web/services/database.dart';
import 'package:web/shared/bubble_icon_button.dart';

class TeacherHomePage extends StatefulWidget {
  final DeviceScreenType deviceScreenType;
  final UserData userData;
  final List<UserLog>? userLogs;
  final Function(List<UserLog>) updateUserLogs;

  const TeacherHomePage({
    Key? key,
    required this.deviceScreenType,
    required this.userData,
    required this.userLogs,
    required this.updateUserLogs,
  }) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final int currentYear = DateTime.now().year;

  DateTime _selectedDate = DateTime.now();
  bool dateChanged = false;

  int? period;

  late DatabaseService _databaseService;
  late double _padding;

  @override
  Widget build(BuildContext context) {
    _databaseService = DatabaseService(uid: widget.userData.uid);
    _padding = getValueForScreenType(
      context: context,
      mobile: 10,
      tablet: 10,
      desktop: 20,
    );

    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(_padding).copyWith(bottom: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
              'ยินดีต้อนรับ ${widget.userData.prefix}${widget.userData.firstname} ${widget.userData.lastname},'),
          const Text('กรุณาเลือกวันที่และคาบที่ต้องการ'),
          Divider(
            height: 20,
            thickness: 1,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BubbleIconButton(
                icon: Icons.calendar_today,
                text: dateChanged
                    ? _selectedDate.toLocal().toString().split(' ').first
                    : 'Select a date',
                onTap: () async {
                  DateTime? _picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(currentYear - 5),
                    lastDate: DateTime(currentYear + 5),
                  );
                  if (_picked != null && _picked != _selectedDate) {
                    setState(() {
                      _selectedDate = _picked;
                      dateChanged = true;
                    });
                  }
                },
              ),
              BubbleIconButton(
                icon: Icons.access_time,
                text: period?.toString() ?? 'Select a period',
                enabled: dateChanged,
                onTap: () async {
                  int _currentIntValue = period ?? 1;
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Select a period'),
                      content: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: StatefulBuilder(
                          builder: (context, setState) => NumberPicker(
                            value: _currentIntValue,
                            minValue: 1,
                            maxValue: periodRef.length,
                            step: 1,
                            onChanged: (changed) =>
                                setState(() => _currentIntValue = changed),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            setState(() => period = _currentIntValue);

                            _databaseService
                                .getUserLogsFromPeriod(
                                    timestamp:
                                        _selectedDate.millisecondsSinceEpoch,
                                    period: period!)
                                .then(widget.updateUserLogs);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              BubbleIconButton(
                icon: Icons.download,
                text: 'Download Data',
                enabled: widget.userLogs?.isNotEmpty ?? false,
                onTap: () {},
              )
            ],
          ),
          SizedBox(height: _padding),
          if (widget.userLogs != null &&
              widget.userLogs!.isNotEmpty &&
              period != null)
            Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: getValueForScreenType<int>(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                ),
                mainAxisSpacing: _padding * 2,
                crossAxisSpacing: _padding * 2,
                itemCount: widget.userLogs!.length,
                itemBuilder: (context, index) => LogCard(
                  userLog: widget.userLogs![index],
                  logMode: LogMode.teacher,
                ),
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              ),
            )
          // Date change with no data
          else if (dateChanged)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('No Data', style: theme.textTheme.bodyText1)],
              ),
            ),
        ],
      ),
    );
  }
}
