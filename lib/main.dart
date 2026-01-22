import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:menu_llm/api/meal.dart';
import 'package:menu_llm/components/link.dart';
import 'package:menu_llm/components/menu.dart';
import 'package:menu_llm/utils/platform.dart';
import 'package:menu_llm/utils/theme.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting("fr_FR");
    await GetStorage.init();
    runApp(const App());
}

class App extends StatefulWidget {
    const App({ super.key });

    @override
    State<App> createState() => _AppState();
}

class _AppState extends State<App> {

    static final _defaultLightColorScheme = ColorScheme.fromSeed(
        seedColor:  Colors.blueAccent,
        brightness: Brightness.light,
    );

    static final _defaultDarkColorScheme = ColorScheme.fromSeed(
        seedColor:  Colors.blueAccent,
        brightness: Brightness.dark,
    );

    @override
    Widget build(BuildContext context) {
        if (isIOS()) {
            return GetCupertinoApp(
                home: const IOSView(),
                theme: CupertinoThemeData(
                    brightness: ThemeService().theme == ThemeMode.dark ? Brightness.dark:Brightness.light
                ),
            );
        }

        return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
            return GetMaterialApp(
                title: 'Menu du Lycée Louis Marchal',
                theme: ThemeData(
                    colorScheme: lightColorScheme ?? _defaultLightColorScheme,
                    useMaterial3: true,
                ),
                darkTheme: ThemeData(
                    colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
                    useMaterial3: true,
                ),
                themeMode: ThemeService().theme,
                home: AndroidView(),
            );
        });
    }
}

class AndroidView extends StatefulWidget {
    const AndroidView({super.key});

    @override
    State<AndroidView> createState() => _AndroidViewState();
}

class _AndroidViewState extends State<AndroidView> {
    final PageController _pageController = PageController();
    final ThemeService _themeService = ThemeService();
    int index = 0;

    late Future<List<Meal>> futureMeals;
    List<DateTime> dates = [DateTime.now()];

    @override
    void initState() {
        super.initState();
        futureMeals = fetchMeal();
    }

    @override
    void dispose() {
        _pageController.dispose();
        super.dispose();
    }

    String _formatDate() {
        DateFormat format = DateFormat('d MMMM y', 'fr_FR');
        if (dates.isEmpty) {
            return format.format(DateTime.now());
        }

        return format.format(dates[index]);
    }

    int _findDate(DateTime d1) {
        var i = dates.indexWhere((d) => (
            d1.day == d.day &&
            d1.month == d.month &&
            d1.year == d.year
        ));

        return i;
    }

    Future<void> _selectDate() async {
        final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: dates[index],
            firstDate: dates[0],
            lastDate: dates.last,
            selectableDayPredicate: (DateTime date) {
                return _findDate(date) != -1;
            }
        );

        if (pickedDate == null) return;
        var i = _findDate(pickedDate);

        if (i != -1) {
            _pageController.jumpToPage(i);
            setState(() {
                index = i;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(_formatDate()),
                actions: [
                    IconButton(
                        icon: Icon(_themeService.theme == ThemeMode.dark ? Icons.dark_mode:Icons.light_mode),
                        onPressed: _themeService.switchTheme,
                    )
                ],
            ),
            body: Pages(
                pageController: _pageController,
                onLoad: (List<DateTime> d) {
                    dates = d;
                },
                onPageChanged: (int i) {
                    setState(() {
                        index = i;
                    });
                },
            ),
            floatingActionButton: FutureBuilder<List<Meal>>(
                future: futureMeals,
                builder: (context, snapshot) {
                    if (snapshot.hasData && !snapshot.data![0].mainCourse.toLowerCase().startsWith("pas de menu")) {
                        return FloatingActionButton(
                            onPressed: _selectDate,
                            tooltip: 'Sélectionner une date',
                            child: const Icon(Icons.calendar_month),
                        );
                    }

                    return const SizedBox.shrink();
                }
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 0,
                    children: [
                        Text("Développée avec ❤️ par"),
                        Link(
                            content: "Orion",
                            href: "https://github.com/oriionn",
                        )
                    ],
                ),
            )
        );
    }
}

class IOSView extends StatefulWidget {
    const IOSView({super.key});

    @override
    State<IOSView> createState() => _IOSViewState();
}

class _IOSViewState extends State<IOSView> {
    final PageController _pageController = PageController();
    final ThemeService _themeService = ThemeService();
    int index = 0;

    late Future<List<Meal>> futureMeals;
    List<DateTime> dates = [DateTime.now()];

    @override
    void initState() {
        super.initState();
        futureMeals = fetchMeal();
    }

    @override
    void dispose() {
        _pageController.dispose();
        super.dispose();
    }

    String _formatDate() {
        DateFormat format = DateFormat('d MMMM y', 'fr_FR');
        if (dates.isEmpty) {
            return format.format(DateTime.now());
        }

        return format.format(dates[index]);
    }

    @override
    Widget build(BuildContext context) {
        return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: Text(_formatDate()),
                trailing: IconButton(
                    icon: Icon(_themeService.theme == ThemeMode.dark ? Icons.dark_mode:Icons.light_mode),
                    onPressed: _themeService.switchTheme,
                ),
            ),
            child: Pages(
                pageController: _pageController,
                onLoad: (List<DateTime> d) {
                    dates = d;
                },
                onPageChanged: (int i) {
                    setState(() {
                        index = i;
                    });
                },
            ),
        );
    }
}
