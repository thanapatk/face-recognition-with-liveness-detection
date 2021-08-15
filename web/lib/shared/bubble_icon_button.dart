import 'package:flutter/material.dart';

class BubbleIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  final bool enabled;
  const BubbleIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(
                text,
                style: theme.textTheme.bodyText1!.copyWith(
                  color: enabled
                      ? theme.textTheme.bodyText1!.color
                      : theme.disabledColor,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: enabled ? onTap : null,
    );
  }
}
