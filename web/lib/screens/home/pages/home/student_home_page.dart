import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/student_info.dart';
import 'package:web/screens/home/pages/shared/log_card.dart';
import 'package:web/services/database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:web/shared/bubble_icon_button.dart';

class StudentHomePage extends StatefulWidget {
  final DeviceScreenType deviceScreenType;
  final UserData userData;
  final List<UserLog>? userLogs;
  final Function(List<UserLog>) updateUserLogs;

  const StudentHomePage({
    Key? key,
    required this.userData,
    required this.userLogs,
    required this.updateUserLogs,
    required this.deviceScreenType,
  }) : super(key: key);

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  DateTime _selectedDate = DateTime.now();
  bool dateChanged = false;

  late DatabaseService _databaseService;
  late double _padding;

  @override
  Widget build(BuildContext context) {
    _databaseService = DatabaseService(uid: widget.userData.uid);
    _padding = getValueForScreenType<double>(
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
          widget.deviceScreenType == DeviceScreenType.mobile
              ? StudentInfoMobile(widget: widget)
              : StudentInfo(widget: widget),
          Divider(
            height: 20,
            thickness: 1,
            color: theme.colorScheme.onSurface,
          ),
          Center(
            child: BubbleIconButton(
              icon: Icons.calendar_today,
              text: dateChanged
                  ? _selectedDate.toLocal().toString().split(' ').first
                  : 'Select a date',
              onTap: () => onSelectDate(),
            ),
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
                mainAxisSpacing: _padding * 2,
                crossAxisSpacing: _padding * 2,
                itemCount: widget.userLogs!.length,
                // TODO: Remove adjacent time
                itemBuilder: (context, index) =>
                    LogCard(userLog: widget.userLogs![index]),
                staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              ),
            )
          // Date change with no data
          else if (dateChanged)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('No data', style: theme.textTheme.bodyText1)],
              ),
            )
        ],
      ),
    );
  }

  void onSelectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (_picked != null && _picked != _selectedDate) {
      setState(() {
        _selectedDate = _picked;
        dateChanged = true;
      });

      _databaseService
          .getUserLogs(
            userData: widget.userData,
            timestamp: _selectedDate.millisecondsSinceEpoch,
          )
          .then((userLogs) => widget.updateUserLogs(userLogs));
    }
  }
}
