import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final List<_NavItemData> items = [
      _NavItemData(iconPath: 'assets/icon/home.svg', label: 'Início'),
      _NavItemData(iconPath: 'assets/icon/denuncia.svg', label: 'Denúncias'),
      _NavItemData(iconPath: 'assets/icon/balneabilidade.svg', label: 'Balneabilidade'),
      _NavItemData(iconPath: 'assets/icon/noticias.svg', label: 'Notícias'),
    ];

    return Container(
      color: const Color(0xFFF5F5F5),
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final selected = currentIndex == index;
          final item = items[index];
          return Expanded(
            key: Key('navbar_item_$index'),
            child: GestureDetector(
              onTap: enabled ? () => onTap(index) : null,
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 48,
                    color: selected ? const Color(0xFF2A2F8C) : Colors.transparent,
                  ),
                  const SizedBox(height: 4),
                  SvgPicture.asset(
                    item.iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      selected ? const Color(0xFF2A2F8C) : const Color(0xFF3B3B3B),
                      BlendMode.srcIn,
                    ),
                  ),
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.label,
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Color(0xFF2A2F8C),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItemData {
  final String iconPath;
  final String label;

  const _NavItemData({required this.iconPath, required this.label});
}
