import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/student_home_page.dart';
import 'package:web/screens/home/pages/home/teacher_home_page.dart';
import 'package:web/screens/home/pages/profile/profile_page.dart';
import 'package:web/screens/home/pages/shared/mobile_drawer.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';
import 'package:web/shared/loading.dart';
import 'package:web/screens/home/home_builder.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  final _authService = AuthService();
  List<UserLog>? userLogs;

  final PageController _pageController = PageController();

  Pages _currentPage = Pages.home;

  @override
  Widget build(BuildContext context) {
    UserData? _userData = context.watch<UserData?>();
    return _userData == null
        ? FoldingCubeLoading(
            backgroundColor: Theme.of(context).backgroundColor,
            size: getValueForScreenType<double>(
              context: context,
              mobile: 60,
              tablet: 50,
              desktop: 40,
            ),
          )
        : ResponsiveBuilder(
            builder: (context, sizeInfo) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              drawer: sizeInfo.deviceScreenType == DeviceScreenType.mobile
                  ? MobileDrawer(
                      authService: _authService,
                      animateTo: _animateTo,
                      currentPage: _currentPage,
                    )
                  : null,
              body: HomeBuilder(
                deviceScreenType: sizeInfo.deviceScreenType,
                authService: _authService,
                userData: _userData,
                currentIndex: _currentPage.index,
                pageController: _pageController,
                pages: [
                  _userData.role == 'teacher'
                      ? TeacherHomePage(
                          deviceScreenType: sizeInfo.deviceScreenType,
                          userData: _userData,
                          userLogs: userLogs,
                          updateUserLogs: (List<UserLog> logs) =>
                              setState(() => userLogs = logs),
                        )
                      : StudentHomePage(
                          deviceScreenType: sizeInfo.deviceScreenType,
                          userData: _userData,
                          userLogs: userLogs,
                          updateUserLogs: (List<UserLog> logs) =>
                              setState(() => userLogs = logs),
                        ),
                  const ProfilePage(),
                ],
                onPageChange: (int i) =>
                    setState(() => _currentPage = Pages.values[i]),
                animateTo: _animateTo,
              ),
            ),
          );
  }

  void _animateTo(Pages p) async {
    _currentPage = p;
    await _pageController.animateToPage(_currentPage.index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
