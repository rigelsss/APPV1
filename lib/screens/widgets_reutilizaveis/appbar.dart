import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;
  final VoidCallback? onNotificationTap;
  final bool isLoggedIn;

  const CustomAppBar({
    super.key,
    this.onLoginTap,
    this.onNotificationTap,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: SizedBox(
        height: 40,
        child: Image.asset('assets/images/logo_sudema.webp'),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          icon: Icon(isLoggedIn ? Icons.notifications : Icons.login),
          onPressed: isLoggedIn ? onNotificationTap : onLoginTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
