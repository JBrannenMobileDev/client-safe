import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Destination{
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Clients', Icons.people),
  Destination('Messages', Icons.message),
  Destination('Home', Icons.home),
  Destination('Jobs', Icons.camera),
  Destination('Collections', Icons.folder)
];