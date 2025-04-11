import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      backgroundColor: const Color(0xFF747474),
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
          backgroundColor: Color(0xFF747474),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.beach_access),
          label: 'Praias',
          backgroundColor: Color(0xFF747474),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.feed),
          label: 'Notícias',
          backgroundColor: Color(0xFF747474),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign),
          label: 'Denúncias',
          backgroundColor: Color(0xFF747474),
        ),
      ],
    );
  }
}
