import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFF5F5F5),
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xFF2A2F8C),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
          backgroundColor: Color(0xFF747474),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Denúncias',
          backgroundColor: Color(0xFF747474),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.beach_access),
          label: 'Balneabilidade',
          backgroundColor: Color(0xFF747474),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Notícias',
          backgroundColor: Color(0xFF747474),
        ),
      ],
    );
  }
}
