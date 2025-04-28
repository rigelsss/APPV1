import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/drawer.dart';

class EditarSenha extends StatefulWidget {
  const EditarSenha({super.key});

  @override
  State<EditarSenha> createState() => _EditarSenhaState();
}

class _EditarSenhaState extends State<EditarSenha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Alterar Senha'),
        backgroundColor: Colors.white,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      drawer: const CustomDrawer(),
      body: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Senha Atual', style: TextStyle(fontSize: 16),),
              SizedBox(height: 8,),
              TextField(decoration:  InputDecoration(
                border: OutlineInputBorder(),
              ),),
              SizedBox(height: 24),
              Text('Nova Senha',style: TextStyle(fontSize: 16),),
              SizedBox(height: 8,),
              TextField(decoration:  InputDecoration(
                border: OutlineInputBorder(),
              ),),
              SizedBox(height: 24),
              Text('Confirme a Nova Senha',style: TextStyle(fontSize: 16),),
              SizedBox(height: 8,),
              TextField(decoration:  InputDecoration(
                border: OutlineInputBorder(),
              ),),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Confirmar alteração',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
                  ),
                ),
              ),

            ]),
      ),
    );
  }
}
