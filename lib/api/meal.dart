import 'dart:convert';

import 'package:http/http.dart' as http;

class Meal {
    final DateTime date;
    final String dessert;
    final String mainCourse;
    final String starter;

    const Meal({ required this.date, required this.dessert, required this.mainCourse, required this.starter });

    factory Meal.fromJson(Map<String, dynamic> json) {
        return switch (json) {
            { 'date': String date, 'date_txt': String dateTxt, 'dessert': String dessert, 'entree': String starter, "plat": String main_course } => Meal(
                date: parseDate(dateTxt, date),
                dessert: dessert,
                mainCourse: main_course,
                starter: starter
            ),
            _ => throw const FormatException("Failed to load meal"),
        };
    }
}

DateTime parseDate(String dateTxt, String date) {
    if (dateTxt == "aujourd'hui") {
        return DateTime.now();
    } else {
        return DateTime.parse(date);
    }
}

Future<List<Meal>> fetchMeal() async {
    final response = await http.get(
        Uri.parse("https://jseinfeld.eu.pythonanywhere.com/api_tab")
    );

    if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as List<dynamic>;
        List<Meal> meals = [];
        for (var v in responseJson) {
            meals.add(Meal.fromJson(v));
        }

        // temp
        meals.add(Meal(
            starter: "Salade",
            mainCourse: "Kebab avec la sauce du chef",
            dessert: "Tiramisu Bueno",
            date: DateTime.now().add(Duration(days: 50))
        ));

        return meals;
    } else {
        throw Exception("Failed to load meal");
    }
}
