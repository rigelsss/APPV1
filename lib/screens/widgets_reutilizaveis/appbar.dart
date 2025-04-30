import 'package:flutter/material.dart';
import 'package:sudema_app/screens/notificacoes.dart'; 

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;
  final bool isLoggedIn;

  const HomeAppBar({
    super.key,
    this.onLoginTap,
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
          onPressed: isLoggedIn
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificacoesPage(),
                    ),
                  );
                }
              : onLoginTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
