import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Center(
              child: Image.asset(
                'assets/images/logosimples.png',
                width: 260,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.campaign),
                  title: const Text('Denúncias'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.beach_access),
                  title: const Text('Balneabilidade'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.feed),
                  title: const Text('Notícias'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.black54, size: 26),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Username',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const Icon(Icons.login, size: 18),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
