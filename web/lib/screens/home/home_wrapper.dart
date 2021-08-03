import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/home_page.dart';
import 'package:web/screens/home/pages/profile/profile_page.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';
import 'package:web/shared/loading.dart';
import 'package:web/screens/home/home.dart';

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
                  ? PSMDrawer(
                      authService: _authService,
                      animateTo: _animateTo,
                      currentPage: _currentPage,
                    )
                  : null,
              body: Home(
                deviceScreenType: sizeInfo.deviceScreenType,
                authService: _authService,
                userData: _userData,
                currentIndex: _currentPage.index,
                pageController: _pageController,
                pages: [
                  HomePage(
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

class PSMDrawer extends StatelessWidget {
  final AuthService authService;
  final Function(Pages) animateTo;
  final Pages currentPage;
  const PSMDrawer({
    Key? key,
    required this.authService,
    required this.animateTo,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Text(
                'MENU',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
          ListTile(
            selected: currentPage == Pages.home,
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () async {
              Navigator.pop(context);
              if (currentPage != Pages.home) {
                await animateTo(Pages.home);
              }
            },
          ),
          ListTile(
            // TODO: Add a profile page
            enabled: false,
            selected: currentPage == Pages.profile,
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () async {
              Navigator.pop(context);
              if (currentPage != Pages.profile) {
                await animateTo(Pages.profile);
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () async => await authService.signOut(),
          ),
        ],
      ),
    );
  }
}
