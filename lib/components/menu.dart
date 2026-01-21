import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_llm/api/meal.dart';
import 'package:menu_llm/utils/platform.dart';

class MenuTile extends StatelessWidget {
    const MenuTile({ super.key, required this.title, required this.content, required this.iosIcon, required this.androidIcon });
    final String title;
    final String content;
    final IconData iosIcon;
    final IconData androidIcon;

    @override
    Widget build(BuildContext context) {
        if (isIOS()) {
            return CupertinoListTile(
                leading: Icon(iosIcon),
                title: Text(title),
                subtitle: Text(content),
            );
        }

        return ListTile(
            leading: Icon(androidIcon),
            title: Text(title),
            subtitle: Text(content)
        );
    }
}

class Menu extends StatelessWidget {
    const Menu({super.key, required this.starter, required this.mainCourse, required this.dessert});

    final String starter;
    final String mainCourse;
    final String dessert;

    @override
    Widget build(BuildContext context) {
        return ListView(
            children: <Widget>[
                MenuTile(
                    androidIcon: Icons.local_bar_outlined,
                    iosIcon: CupertinoIcons.play_arrow_solid,
                    title: "Entrée",
                    content: starter
                ),
                MenuTile(
                    androidIcon: Icons.restaurant_outlined,
                    iosIcon: CupertinoIcons.flame_fill,
                    title: "Plat",
                    content: mainCourse,
                ),
                MenuTile(
                    androidIcon: Icons.cake_outlined,
                    iosIcon: Icons.cake,
                    title: "Dessert",
                    content: dessert,
                )
            ]
        );
    }
}

class Pages extends StatefulWidget {
    const Pages({ super.key, required this.pageController, required this.onPageChanged, required this.onLoad });
    final PageController pageController;
    final void Function(int newPage) onPageChanged;
    final void Function(List<DateTime> dates) onLoad;

    @override
    State<Pages> createState() => PagesState();
}

class PagesState extends State<Pages> {
    late Future<List<Meal>> futureMeals;

    @override
    void initState() {
        super.initState();
        futureMeals = fetchMeal();
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<List<Meal>>(
            future: futureMeals,
            builder: (context, snapshot) {
                if (snapshot.hasData) {
                    List<Meal> data = snapshot.data!;
                    List<DateTime> dates = [];

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

                    widget.onLoad(dates);

                    return PageView(
                        controller: widget.pageController,
                        scrollDirection: Axis.horizontal,
                        children: pages,
                        onPageChanged: (i) {
                            widget.onPageChanged(i);
                        },
                    );
                } else if (snapshot.hasError) {
                    return Text('${snapshot.error!}');
                }

                return Center(
                    child: isIOS() ? CupertinoActivityIndicator():CircularProgressIndicator()
                );
            },
        );
    }
}
