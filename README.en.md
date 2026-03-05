# LLMenu
A small application, initially developed for Android, which allows you to view the menu of the **Lycée Louis Marchal** canteen at your leisure, featuring the [Material 3](https://m3.material.io/) design for Android and the Cupertino design for iOS.

## How did I do it?
The application created by the NSI teacher, available [here](https://play.google.com/store/apps/details?id=fr.free.buchi.prof.menucantine), makes a simple HTTP request to a Flask server. All I had to do was use a **Man In The Middle** (in this case, I used [HTTP Toolkit](https://httptoolkit.com/)) to retrieve the endpoint used and thus reproduce the same request as the original application.

## Development
### Prerequisites
- Flutter

### Development
To launch the development version of the application:
```sh
git clone https://git.oriondev.fr/orion/llmenu.git
cd llmenu
flutter pub get
flutter run
```

## Compilation
### Android
```sh
flutter build apk
```
