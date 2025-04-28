import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbar.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/drawer.dart';

class editarperfil extends StatefulWidget {
  const editarperfil({super.key});

  @override
  State<editarperfil> createState() => _editarperfilState();
}

class _editarperfilState extends State<editarperfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(),
      drawer: const CustomDrawer(),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Nome completo', style: TextStyle(fontSize: 16),),
          SizedBox(height: 8,),
          TextField(decoration:  InputDecoration(
            border: OutlineInputBorder(),
          ),),
            SizedBox(height: 24),
            Text('CPF',style: TextStyle(fontSize: 16),),
            SizedBox(height: 8,),
            TextField(decoration:  InputDecoration(
              border: OutlineInputBorder(),
            ),),
            SizedBox(height: 24),
            Text('Telefone para contato',style: TextStyle(fontSize: 16),),
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
                  'Sair',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
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