import 'package:flutter/material.dart';
import 'package:practica_ds_flutter/screen_partition.dart';
import 'package:practica_ds_flutter/tree.dart';

class ScreenSpace extends StatefulWidget {
  final String id;
  const ScreenSpace({super.key, required this.id});

  @override
  State<ScreenSpace> createState() => _ScreenSpace();
}

class _ScreenSpace extends State<ScreenSpace> {
  late Tree tree;
  @override
  void initState() {
    super.initState();
    tree = getTree(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tree.root.id),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.home),
              onPressed: () => {}
            // TODO go home page = root
          ),
          //TODO other actions
        ],
      ),
      body: ListView.separated(
        // it's like ListView.builder() but better
        // because it includes a separator between items
        padding: const EdgeInsets.all(16.0),
        itemCount: tree.root.children.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildRow(tree.root.children[index], index),
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
      ),
    );
  }

  Widget _buildRow(Door door, int index) {
    return ListTile(
      title: Text('D    ${door.id}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          door.closed
              ? Icon(Icons.door_front_door_outlined) // Icono de puerta cerrada
              : Icon(Icons.exit_to_app), // Icono de puerta abierta
          SizedBox(width: 8), // Espacio entre iconos
          _buildLockIcon(door.state), // Función para determinar el icono del candado
        ],
      ),
    );
  }

  Widget _buildLockIcon(String doorState) {
    if (doorState == 'locked') {
      return Icon(Icons.lock_outline); // Icono de candado cerrado
    } else {
      return Icon(Icons.lock_open); // Icono de candado abierto
    }
  }


}
