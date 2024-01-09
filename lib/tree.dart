import 'package:practica_ds_flutter/requests.dart';

abstract class Area{
  late String id;
  late List<dynamic> children;
  late bool locked;
  Area(this.id, this.children, this.locked);
}

class Partition extends Area {
  Partition(String id, List<Area>children, bool locked) : super(id, children, locked);
}

class Space extends Area {
  Space(String id, List<Door> children, bool locked) : super(id, children, locked);
}

class Door {
  late String id;
  late bool closed;
  late String state;
  Door({required this.id, this.state="locked", this.closed=true});
}

// at the moment this class seems unnecessary but later we will extend it
class Tree {
  late Area root;

  Tree(Map<String, dynamic> dec) {
    // 1 level tree, root and children only, root is either Partition or Space.
    // If Partition children are Partition or Space, that is, Area. If root
    // is a Space, children are Door.
    // There is a JSON field 'class' that tells the type of Area.
    if (dec['class'] == "partition") {
      List<Area> children = <Area>[]; // is growable
      for (Map<String, dynamic> area in dec['areas']) {
        if (area['class'] == "partition") {
          children.add(Partition(area['id'], <Area>[], area['locked']));
        } else if (area['class'] == "space") {
          children.add(Space(area['id'], <Door>[], area['locked']));
        } else {
          assert(false);
        }
      }
      root = Partition(dec['id'], children, dec['lockedArea']);
    } else if (dec['class'] == "space") {
      List<Door> children = <Door>[];
      for (Map<String, dynamic> d in dec['access_doors']) {
        children.add(Door(id: d['id'], state: d['state'], closed: d['closed']));
      }
      root = Space(dec['id'], children, dec['lockedArea']);
    } else {
      assert(false);
    }
  }
}


