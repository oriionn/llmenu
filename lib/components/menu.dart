import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
    const Menu({super.key});

    @override
    State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
    @override
    Widget build(BuildContext context) {
        return ListView(
            children: <Widget>[
                ListTile(
                    leading: Icon(Icons.local_bar_outlined),
                    title: const Text("Entrée"),
                    subtitle: const Text("Kebab Frites + sauce du chef")
                ),
                ListTile(
                    leading: Icon(Icons.restaurant_outlined),
                    title: const Text("Plat"),
                    subtitle: const Text("Salade")
                ),
                ListTile(
                    leading: Icon(Icons.cake_outlined),
                    title: const Text("Dessert"),
                    subtitle: const Text("Tiramisu Kinder Bueno")
                )
            ]
        );
    }
}
