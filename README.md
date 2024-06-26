# itavero_mobile

itavero mobile

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build IPA/APK
flutter build ipa --export-method enterprise --obfuscate --split-debug-info true    
(aktuell geht das erstellen der IOS App nur ueber XCode. Siehe Meldung:
Try distributing the app in Xcode: "open /Users/itaverobm/IdeaProjects/mobile_flutter/build/ios/archive/Runner.xcarchive"
Dazu die Datei öffnen und den Button Distribute App druecken. Dann kommt eine Abfrage um auf den Schlüsselbund zuzugreifen. 
WICHTIG: Passwort eingeben und 'Immer Erlauben' drücken, mit 'Erlauben' geht es nicht.)

flutter build apk


## Plugins
- [flutter_slidable](https://pub.dev/packages/flutter_slidable)
- [provider](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [settings _ui](https://pub.dev/packages/settings_ui)
- scandit_flutter_datacapture_barcode
- [webview_flutter](https://pub.dev/packages/webview_flutter)
- [build_runner](https://pub.dev/packages/build_runner) --dev
- [split_view](https://pub.dev/packages/split_view/install) 
- [introduction_screen](https://pub.dev/packages/introduction_screen)
- [auto_size_text](https://pub.dev/packages/auto_size_text)




## build_runner
Plugin ist zum generieren von Dart-Code.
Wir z.B. verwendet für JSON

```
dart pub add build_runner --dev

flutter pub run build_runner build
```
Die verfügbaren Befehle sind build, watch, serve und test.

build: Führt einen einzelnen Build aus und wird beendet.
watch: Führt einen persistenten Build-Server aus, der das Dateisystem auf Änderungen überwacht und bei Bedarf Neuerstellungen durchführt.
serve: Wie watch, führt aber auch einen Entwicklungsserver aus.
Standardmäßig bedient dies die Verzeichnisse webund testauf Port 8080bzw. 8081Unten erfahren Sie, wie Sie dies konfigurieren.
test: Führt einen einzelnen Build aus, erstellt ein zusammengeführtes Ausgabeverzeichnis und führt dann dart run test --precompiled <merged-output-dir>. Nachfolgend finden Sie Anweisungen zum Übergeben benutzerdefinierter Argumente an den Testbefehl.

### bei Problemen mit build_runner

```
flutter clean

dart pub get

flutter pub get
```

### Generierung von App-Icons
Es ist möglich ein Icon für alle Größen in iOS und Android generieren zu lassen. Das Basis Icon liegt unter
/assets/icon/icon.png

Für die Generierung muss folgendes ausgeführt werden:

```
flutter pub run flutter_launcher_icons:main
```

## Flutter Native Splash
Konfiguration in der Datei pubspec.yml, danach folgenden Befehl ausführen
```
flutter pub run flutter_native_splash:create
```


## Base46 verschlüsseln
Muss noch dokumentiert werden.
...
certutil -encode C:\Temp\ios_profile\AdHocProfile.mobileprovision tmp.b64 && findstr /v /c:- tmp.b64 > AdHocProfile.b64 && del tmp.b64
...
