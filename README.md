# LLMenu
Une petite application, d'abord développée pour Android, qui vous permet de regarder le menu de la cantine du **Lycée Louis Marchal** en toute tranquilité en profitant du design [Material 3](https://m3.material.io/) pour Android et du design Cupertino pour iOS.

## Comment j'ai fait ?
L'application créée par le professeur de NSI, disponible [ici](https://play.google.com/store/apps/details?id=fr.free.buchi.prof.menucantine) fait une simple requête HTTP à un serveur Flask, il m'a suffit d'utiliser un **Man In The Middle** (en l'occurence, j'ai utilisé [HTTP Toolkit](https://httptoolkit.com/)) pour récupérer l'endpoint utilisé et ainsi reproduire la même requête que l'application originale.

## Développement
### Prérequis
- Flutter

### Développer
Pour lancer la version développement de l'application :
```sh
git clone https://github.com/oriionn/llmenu.git
cd llmenu
flutter pub get
flutter run
```

## Compilation
### Android
```sh
flutter build apk
```
