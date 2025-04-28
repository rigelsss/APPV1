import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;
  final VoidCallback? onNotificationTap;
  final bool isLoggedIn;

  const HomeAppBar({
    super.key,
    this.onLoginTap,
    this.onNotificationTap,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
       backgroundColor: Colors.white,
      centerTitle: true,
      title: SizedBox(
        height: 40,
        child: Image.asset('assets/images/logosimples.png'),
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
