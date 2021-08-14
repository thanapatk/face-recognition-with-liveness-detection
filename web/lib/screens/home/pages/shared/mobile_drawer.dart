import 'package:flutter/material.dart';
import 'package:web/services/auth.dart';
import 'package:web/shared/constant.dart';

class MobileDrawer extends StatelessWidget {
  final AuthService authService;
  final Function(Pages) animateTo;
  final Pages currentPage;
  const MobileDrawer({
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
