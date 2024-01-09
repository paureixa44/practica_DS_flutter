import 'package:flutter/material.dart';
import 'package:practica_ds_flutter/screen_partition.dart';
import 'package:practica_ds_flutter/tree.dart';
import 'package:practica_ds_flutter/requests.dart';

class ScreenSpace extends StatefulWidget {
  final String id;
  const ScreenSpace({super.key, required this.id});

  @override
  State<ScreenSpace> createState() => _ScreenSpace();
}

class _ScreenSpace extends State<ScreenSpace> {
  late Future<Tree> futureTree;
  @override
  void initState() {
    super.initState();
    futureTree = getTree(widget.id);
  }

  // future with listview
// https://medium.com/nonstopio/flutter-future-builder-with-list-view-builder-d7212314e8c9
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tree>(
      future: futureTree,
      builder: (context, snapshot) {
        // anonymous function
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              title: Text(snapshot.data!.root.id),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.home), onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);                }
                  // TODO go home page = root
                ),
                //TODO other actions
              ],
            ),
            body: ListView.separated(
              // it's like ListView.builder() but better because it includes a separator between items
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.root.children.length,
              itemBuilder: (BuildContext context, int i) =>
                  _buildRow(snapshot.data!.root.children[i], i),
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a progress indicator
        return Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );
  }

  Widget _buildRow(Door door, int index) {
    bool isDoorVisible = door.state == "unlocked";
    return ListTile(
      title: Text('D    ${door.id}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: _buildLockIcon(door.state),
            onPressed: () {
              if (door.state == 'locked') {
                unlockDoor(door);
                futureTree = getTree(widget.id);
                setState(() {});
              } else {
                lockDoor(door);
                futureTree = getTree(widget.id);
                setState(() {});
              }
            },
          ),
          SizedBox(width: 8), // Space between icons
          Visibility(
            visible: door.state == 'unlocked',
            child: IconButton(
              icon: _buildDoorIcon(door.closed), // Icon for closed door
              onPressed: () {
                if (door.closed) {
                  openDoor(door);
                  futureTree = getTree(widget.id);
                  setState(() {});
                } else {
                  closeDoor(door);
                  futureTree = getTree(widget.id);
                  setState(() {});
                }
                // Add your logic when the door icon is pressed (if needed)
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLockIcon(String doorState) {
    if (doorState == 'locked') {
      return Icon(Icons.lock_outline); // Icon for locked door
    } else {
      return Icon(Icons.lock_open); // Icon for unlocked door
    }
  }

  Widget _buildDoorIcon(bool closed) {
    if (closed) {
      return Icon(Icons.door_back_door_outlined); // Icon for locked door
    } else {
      return Icon(Icons.meeting_room); // Icon for unlocked door
    }
  }
}
