import 'package:flutter/material.dart';
import 'presentation/pages/producto_page.dart'; // Asegúrate de que este path sea correcto

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productos API',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProductoPage(), // Nombre de la clase corregido
    );
  }
}
