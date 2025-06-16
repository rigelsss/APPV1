import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sudema_app/screens/monumentos/monumentos.dart';
import 'package:sudema_app/screens/jardim/jardim.dart';


class BannerCarrossel extends StatefulWidget {
  final VoidCallback onTapDenuncia;

  const BannerCarrossel({
    super.key,
    required this.onTapDenuncia,
  });

  @override
  State<BannerCarrossel> createState() => _BannerCarrosselState();
}

class _BannerCarrosselState extends State<BannerCarrossel> {
  final PageController _controller = PageController(viewportFraction: 1.02);
  int _paginaAtual = 0;

  final List<String> imagens = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  void _handleTap(int index) {
    if (index == 0) {
      widget.onTapDenuncia();
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Monumentos()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Jardim()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = width * 0.25;

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: imagens.length,
            onPageChanged: (index) {
              setState(() => _paginaAtual = index);
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      imagens[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imagens.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _paginaAtual == index ? const Color(0xFF2A2F8C) : Colors.grey.shade400,
              ),
            );
          }),
        ),
      ],
    );
  }
}
