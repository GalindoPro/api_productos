import 'package:flutter/material.dart';
import '../../core/api/api_service_producto.dart';

class ProductoPage extends StatefulWidget {
  const ProductoPage({Key? key}) : super(key: key);

  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final ApiServiceProducto _api = ApiServiceProducto();
  List<Map<String, dynamic>> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final data = await _api.getProductos();
      setState(() {
        _productos = data.take(20).toList();
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _agregarProductoDialog() async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Agregar Producto"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Título"),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: "Descripción"),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text("Guardar"),
                onPressed: () async {
                  final nuevoProducto = {
                    "userId": 1,
                    "title": titleController.text,
                    "body": bodyController.text,
                  };
                  await _api.createProducto(nuevoProducto);
                  Navigator.pop(context);
                  _cargarProductos();
                },
              ),
            ],
          ),
    );
  }

  Future<void> _editarProductoDialog(Map<String, dynamic> producto) async {
    final titleController = TextEditingController(text: producto['title']);
    final bodyController = TextEditingController(text: producto['body']);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Producto"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: "Descripción"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                final actualizado = {
                  "userId": producto['userId'],
                  "id": producto['id'],
                  "title": titleController.text,
                  "body": bodyController.text,
                };
                await _api.updateProducto(producto['id'], actualizado);
                Navigator.pop(context);
                _cargarProductos();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarProductoConfirmacion(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("¿Eliminar producto?"),
            content: const Text("Esta acción no se puede deshacer."),
            actions: [
              TextButton(
                child: const Text("Cancelar"),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                child: const Text("Eliminar"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );

    if (confirmar == true) {
      await _api.deleteProducto(id);
      _cargarProductos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: ListView.builder(
        itemCount: _productos.length,
        itemBuilder: (context, index) {
          final producto = _productos[index];
          return ListTile(
            title: Text(producto['title']),
            subtitle: Text(producto['body']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editarProductoDialog(producto),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed:
                      () => _eliminarProductoConfirmacion(producto['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarProductoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
