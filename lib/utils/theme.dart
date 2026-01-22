import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:menu_llm/utils/platform.dart';

class ThemeService {
    final GetStorage _box = GetStorage();
    final String _key = 'isDarkMode';

    bool _loadThemeFromBox() => _box.read(_key) ?? WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

    Future<void> _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

    bool loadThemeFromBox() => _loadThemeFromBox();

    void switchTheme() async {
        bool isDarkMode = _loadThemeFromBox();

        if (isIOS()) {
            await Future<void>.delayed(const Duration(milliseconds: 500));
            await Get.forceAppUpdate();
        } else {
            Get.changeThemeMode(isDarkMode ? ThemeMode.light:ThemeMode.dark);
        }

        _saveThemeToBox(!isDarkMode);
    }
}
