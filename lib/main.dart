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

        var i = _findDate(pickedDate!);

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
            ),
            body: FutureBuilder<List<Meal>>(
                future: futureMeals,
                builder: (context, snapshot) {
                    if (snapshot.hasData) {
                        List<Meal> data = snapshot.data!;
                        dates = [];

                        if (data[0].mainCourse.toLowerCase().startsWith("pas de menu")) {
                            return Center(
                                child: Text("Aucun menu disponible"),
                            );
                        }

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
                            controller: _pageController,
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
                onPressed: _selectDate,
                tooltip: 'Sélectionner une date',
                child: const Icon(Icons.calendar_month),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text("Développée avec ❤️ par Orion"),
                    )
                ],
            )
        );
    }
}
