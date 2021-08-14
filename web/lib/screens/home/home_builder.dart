import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/shared/nav_bar.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';

class HomeBuilder extends StatefulWidget {
  final AuthService authService;
  final UserData userData;
  final int currentIndex;
  final PageController pageController;
  final List<Widget> pages;
  final Function(int) onPageChange;
  final Function(Pages) animateTo;
  final DeviceScreenType deviceScreenType;

  const HomeBuilder({
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
  _HomeBuilderState createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
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
