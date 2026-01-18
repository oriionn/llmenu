import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
    const Menu({super.key, required this.starter, required this.mainCourse, required this.dessert});

    final String starter;
    final String mainCourse;
    final String dessert;

    @override
    Widget build(BuildContext context) {
        return ListView(
            children: <Widget>[
                ListTile(
                    leading: Icon(Icons.local_bar_outlined),
                    title: const Text("Entrée"),
                    subtitle: Text(starter)
                ),
                ListTile(
                    leading: Icon(Icons.restaurant_outlined),
                    title: const Text("Plat"),
                    subtitle: Text(mainCourse)
                ),
                ListTile(
                    leading: Icon(Icons.cake_outlined),
                    title: const Text("Dessert"),
                    subtitle: Text(dessert)
                )
            ]
        );
    }
}
