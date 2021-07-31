import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/home_page.dart';
import 'package:web/screens/home/pages/profile/profile_page.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';
import 'package:web/shared/loading.dart';
import 'package:web/screens/home/home_desktop.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authService = AuthService();

  final PageController _pageController = PageController();

  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
  ];

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
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: ScreenTypeLayout.builder(
              desktop: (context) => HomeDesktop(
                  authService: _authService,
                  userData: _userData,
                  currentIndex: _currentIndex,
                  pageController: _pageController,
                  pages: _pages,
                  onPageChange: (int i) => setState(() => _currentIndex = i),
                  animateTo: (Pages p) {
                    _currentIndex = p.index;
                    _pageController.animateToPage(_currentIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }),
              tablet: (context) => Container(),
              mobile: (context) => Container(),
            ),
          );
  }
}
