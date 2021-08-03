import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/nav_bar.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';

class Home extends StatefulWidget {
  final AuthService authService;
  final UserData userData;
  final int currentIndex;
  final PageController pageController;
  final List<Widget> pages;
  final Function(int) onPageChange;
  final Function(Pages) animateTo;
  final DeviceScreenType deviceScreenType;

  const Home({
    Key? key,
    required this.authService,
    required this.userData,
    required this.currentIndex,
    required this.pageController,
    required this.pages,
    required this.onPageChange,
    required this.animateTo,
    required this.deviceScreenType,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.deviceScreenType == DeviceScreenType.mobile
            ? NavBarMobile(widget: widget)
            : NavBar(widget: widget),
        Expanded(
          child: PageView(
            children: widget.pages,
            onPageChanged: widget.onPageChange,
            controller: widget.pageController,
            physics: const NeverScrollableScrollPhysics(),
          ),
        )
      ],
    );
  }
}
