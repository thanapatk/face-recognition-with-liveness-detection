import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/student_home_page.dart';
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
    this.userLogs,
    required this.updateUserLogs,
  }) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  DateTime _selectedDate = DateTime.now();
  bool dateChanged = false;

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
            children: [
              BubbleIconButton(
                icon: Icons.calendar_today,
                text: dateChanged
                    ? _selectedDate.toLocal().toString().split(' ').first
                    : 'Select a date',
                onTap: () {},
              ),
              BubbleIconButton(
                icon: Icons.access_time,
                text: 'Select a period',
                enabled: dateChanged,
                onTap: () {},
              ),
              BubbleIconButton(
                icon: Icons.download,
                text: 'Download Data',
                // TODO: Add period boolean
                enabled: dateChanged && true,
                onTap: () {},
              )
            ],
          ),
          SizedBox(height: _padding),
          if (widget.userLogs != null && widget.userLogs!.isNotEmpty)
            Expanded(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: getValueForScreenType<int>(
                  context: context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                ),
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
