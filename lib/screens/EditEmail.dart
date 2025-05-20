import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/drawer.dart';

class EditarEmail extends StatefulWidget {
  const EditarEmail({super.key});

  @override
  State<EditarEmail> createState() => _EditarEmailState();
}
bool _obscureText = true;

class _EditarEmailState extends State<EditarEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Alterar Email'),
          backgroundColor: Colors.white,
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      drawer: const CustomDrawer(),
      body: Padding(padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Senha', style: TextStyle(fontSize: 16),),
              SizedBox(height: 8,),
              TextField(decoration:  InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),),
              SizedBox(height: 24),
              Text('Novo Email',style: TextStyle(fontSize: 16),),
              SizedBox(height: 8,),
              TextField(decoration:  InputDecoration(
                border: OutlineInputBorder(),
              ),),
              SizedBox(height: 24),
              Text('Confirmar o Novo Email',style: TextStyle(fontSize: 16),),
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
