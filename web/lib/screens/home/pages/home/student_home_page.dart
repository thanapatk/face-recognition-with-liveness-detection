import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/student_info.dart';
import 'package:web/services/database.dart';
import 'package:web/shared/constant.dart';
import 'package:web/shared/loading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  bool changed = false;
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
            color: Theme.of(context).colorScheme.onSurface,
          ),
          Center(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      //offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(changed
                            ? _selectedDate.toLocal().toString().split(' ')[0]
                            : 'Select a date'),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                DateTime? _picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (_picked != null && _picked != _selectedDate) {
                  setState(() {
                    _selectedDate = _picked;
                    changed = true;
                    //_loading = true;
                  });

                  _databaseService
                      .getUserLogs(
                        userData: widget.userData,
                        timestamp: _selectedDate.millisecondsSinceEpoch,
                      )
                      .then((userLogs) => widget.updateUserLogs(userLogs));
                }
              },
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
          else if (changed)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No data',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class LogCard extends StatelessWidget {
  final UserLog userLog;
  const LogCard({Key? key, required this.userLog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
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
                        Row(
                          children: [
                            Text('คาบ: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Text(userLog.period,
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        Row(
                          children: [
                            Text('เวลา: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            Text(userLog.time,
                                style: Theme.of(context).textTheme.bodyText1)
                          ],
                        ),
                        Row(
                          children: [
                            Text('สถานะ: ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.w500)),
                            statusWidgets(userLog.status,
                                Theme.of(context).textTheme.bodyText1!),
                          ],
                        ),
                        SizedBox(
                            height:
                                Theme.of(context).textTheme.bodyText1!.fontSize)
                      ],
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
