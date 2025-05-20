import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool enabled;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.enabled = true, 
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF5F5F5),
      currentIndex: currentIndex >= 0 ? currentIndex : 0,
      selectedItemColor: currentIndex == -1 ? Colors.black : const Color(0xFF2A2F8C),
      unselectedItemColor: Colors.black,
      onTap: enabled ? onTap : null, 
      selectedFontSize: 14,
      unselectedFontSize: 14,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Denúncias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.beach_access),
          label: 'Balneabilidade',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Notícias',
        ),
      ],
    );
  }
}

