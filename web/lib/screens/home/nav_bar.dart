import 'package:flutter/material.dart';
import 'package:web/shared/constant.dart';
import 'package:web/screens/home/home.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, required this.widget}) : super(key: key);

  final Home widget;

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
                // TextButton(
                //   onPressed: () => widget.animateTo(Pages.home),
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(
                //         widget.currentIndex == Pages.home.index
                //             ? Theme.of(context)
                //                 .colorScheme
                //                 .primary
                //                 .withOpacity(0.5)
                //             : Colors.transparent),
                //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50.0),
                //     )),
                //     overlayColor: MaterialStateProperty.all(Colors.transparent),
                //   ),
                //   child: Text(
                //     'Home',
                //     style: Theme.of(context).textTheme.headline5!.copyWith(
                //           fontWeight: FontWeight.w500,
                //         ),
                //   ),
                // ),
                // TextButton(
                //   onPressed: () => widget.animateTo(Pages.profile),
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all(
                //         widget.currentIndex == Pages.profile.index
                //             ? Theme.of(context)
                //                 .colorScheme
                //                 .primary
                //                 .withOpacity(0.5)
                //             : Colors.transparent),
                //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50.0),
                //     )),
                //     overlayColor: MaterialStateProperty.all(Colors.transparent),
                //   ),
                //   child: Text(
                //     'Profile',
                //     style: Theme.of(context)
                //         .textTheme
                //         .headline5!
                //         .copyWith(fontWeight: FontWeight.w500),
                //   ),
                // ),
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
                      // TODO: Add a profile page
                      enabled: false,
                      value: Pages.profile,
                      child: ListTile(
                        leading: Icon(Icons.person_outline),
                        title: Text('Profile'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: Pages.signOut,
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Sign Out'),
                      ),
                    ),
                  ],
                  onSelected: (Pages p) async {
                    if (p == Pages.profile) {
                      await widget.animateTo(Pages.profile);
                    } else if (p == Pages.signOut) {
                      await widget.authService.signOut();
                    }
                  },
                  offset: const Offset(50, 55),
                  elevation: 2.0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NavBarMobile extends StatelessWidget {
  final Home widget;

  const NavBarMobile({Key? key, required this.widget}) : super(key: key);

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
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu),
            ),
            Text(
              'PSM ATTENDANCE',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
