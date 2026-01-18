import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:menu_llm/api/meal.dart';
import 'package:menu_llm/components/menu.dart';

void main() {
    initializeDateFormatting("fr_FR");
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
    final PageController _pageController = PageController();
    int index = 0;

    late Future<List<Meal>> futureMeals;
    DateTime date = DateTime.now();
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

    String formatDate() {
        return DateFormat('d MMMM y', 'fr_FR').format(dates[index]);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(formatDate()),
            ),
            body: FutureBuilder<List<Meal>>(
                future: futureMeals,
                builder: (context, snapshot) {
                    if (snapshot.hasData) {
                        List<Meal> data = snapshot.data!;
                        dates = [];

                        List<Menu> pages = [];
                        for (var v in data) {
                            pages.add(
                                Menu(
                                    starter: v.starter,
                                    mainCourse: v.mainCourse,
                                    dessert: v.dessert,
                                )
                            );

                            dates.add(v.date);
                        }

                        return PageView(
                            scrollDirection: Axis.horizontal,
                            children: pages,
                            onPageChanged: (i) {
                                setState(() {
                                    index = i;
                                });
                            },
                        );
                    } else if (snapshot.hasError) {
                        return Text('${snapshot.error!}');
                    }

                    return const Center(
                        child: CircularProgressIndicator(),
                    );
                },
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
