import 'package:flutter/material.dart';
import 'package:web/models/user.dart';
import 'package:web/screens/home/pages/home/nav_bar.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';

class HomeDesktop extends StatefulWidget {
  final AuthService authService;
  final UserData userData;
  final int currentIndex;
  final PageController pageController;
  final List<Widget> pages;
  final Function(int) onPageChange;
  final Function(Pages) animateTo;

  const HomeDesktop({
    Key? key,
    required this.authService,
    required this.userData,
    required this.currentIndex,
    required this.pageController,
    required this.pages,
    required this.onPageChange,
    required this.animateTo,
  }) : super(key: key);

  @override
  _HomeDesktopState createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavBar(widget: widget),
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
