import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:menu_llm/components/menu.dart';

void main() {
    runApp(const App());
}

class App extends StatelessWidget {
    const App({super.key});

    static final _defaultLightColorScheme =
        ColorScheme.fromSwatch(primarySwatch: Colors.indigo);

    static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
        primarySwatch: Colors.indigo, brightness: Brightness.dark);

    @override
    Widget build(BuildContext context) {
        return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp(
                title: 'Menu du Lycée Louis Marchal',
                theme: ThemeData(
                    colorScheme: lightColorScheme ?? _defaultLightColorScheme,
                    useMaterial3: true,
                ),
                darkTheme: ThemeData(
                    colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
                    useMaterial3: true,
                ),
                themeMode: ThemeMode.dark,
                home: const View(),
            );
        });
    }
}

class View extends StatefulWidget {
    const View({super.key});

    @override
    State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("17 janvier 2026"),
            ),
            body: PageView(
                scrollDirection: Axis.horizontal,
                children: [
                    Menu(),
                    Menu(),
                    Menu()
                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                tooltip: 'Sélectionner une date',
                child: const Icon(Icons.calendar_month),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
        );
    }
}
