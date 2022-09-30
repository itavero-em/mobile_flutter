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

## Plugins
- [flutter_slidable](https://pub.dev/packages/flutter_slidable)
- [provider](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [settings_ui](https://pub.dev/packages/settings_ui)
- scandit_flutter_datacapture_barcode
- [webview_flutter](https://pub.dev/packages/webview_flutter)
- [build_runner](https://pub.dev/packages/build_runner) --dev




## build_runner
Plugin ist zum generieren von Dart-Code.
Wir z.B. verwendet für JSON

dart pub add build_runner --dev

flutter pub run build_runner build

Die verfügbaren Befehle sind build, watch, serveund test.

build: Führt einen einzelnen Build aus und wird beendet.
watch: Führt einen persistenten Build-Server aus, der das Dateisystem auf Änderungen überwacht und bei Bedarf Neuerstellungen durchführt.
serve: Wie watch, führt aber auch einen Entwicklungsserver aus.
Standardmäßig bedient dies die Verzeichnisse webund testauf Port 8080bzw. 8081Unten erfahren Sie, wie Sie dies konfigurieren.
test: Führt einen einzelnen Build aus, erstellt ein zusammengeführtes Ausgabeverzeichnis und führt dann dart run test --precompiled <merged-output-dir>. Nachfolgend finden Sie Anweisungen zum Übergeben benutzerdefinierter Argumente an den Testbefehl.

### bei Problemen mit build_runner
flutter clean

dart pub get

flutter pub get