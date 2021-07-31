import 'package:flutter/material.dart';
import 'package:web/shared/constant.dart';
import 'package:web/screens/home/home_desktop.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, required this.widget}) : super(key: key);

  final HomeDesktop widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PSM ATTENDANCE',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 34,
                  ),
            ),
            const SizedBox(width: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => widget.animateTo(Pages.home),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        widget.currentIndex == Pages.home.index
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                            : Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    )),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    'Home',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () => widget.animateTo(Pages.profile),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        widget.currentIndex == Pages.profile.index
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5)
                            : Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    )),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: Text(
                    'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 20),
                PopupMenuButton<Pages>(
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      widget.userData.picUrl,
                      scale: 1.8,
                    ),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: Pages.profile, child: Text('Profile')),
                    const PopupMenuItem(
                        value: Pages.signOut, child: Text('Sign Out')),
                  ],
                  onSelected: (Pages p) async {
                    if (p == Pages.profile) {
                      widget.animateTo(Pages.profile);
                    } else if (p == Pages.signOut) {
                      await widget.authService.signOut();
                    }
                  },
                  offset: const Offset(50, 55),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
