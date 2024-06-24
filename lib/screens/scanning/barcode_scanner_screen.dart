import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeScannerScreen extends StatefulWidget {
  static const String licenseKey =
      'Ab8CKaOBNznRIQFd/w9NKYsZmx/m43ah21Idb5VyB+PaM/IBznVXJ8h4wS49anNj3F1lXJJ9Sxb9QPA2u2z8MoJaGDakfrllxWffKpJqJhiUOnglr1Mr4rs5qi5sTVJ5OBJx2cEHEeG4Owg00T1RoB0sm06LvdVTsCwq5gD3x4jnoBsr1zG46XtTR4/3n0V2hsk4UPV7N2i3pTq2lR+HvkBAINx6wzC7Sjb0enEUtS1PYKjDQj6LHdE4EsITHhfVaDc81kjAmytyLYiCMvLg/WQsirGEACzKX3uLVWri77Y6LLOxNYOOW+vZmJyM1u00GOFqD8ZZ74nrqPOHiL37NjXzqgfXpGAz8TGdvE5LFZ+TdxYmTj9Lmua0euYNt8w9tlo3Pn7GT47+ffXo+uON+i8HeIdJ9Hi8/f3hK/VdP5912mLFcJ1HAhI47NnAZ/UHrEzcdBQeYMAtORlBLy1FGBAiZcTN3osST2Y0iPm2AxtsA8uok3+dX6fpqaYuI10OPB4/YVkC212wAK5ucpPMLIzuXPz+/9oVfFMxesL2hYNPE7zx+H9FiYhLs36sQHkKK/yw9MdXlU+bmyitqSWcxsvPuO0HuUUtyZU9+2o0Gs3v7A3wXnmzP4GEfYxw5tx4C1yUeqLPV74z7g6Son33RFZHFzxUiq1zmuG97XZqdPM6LM5Xth8cMjZWbdN38EMtcqz2ks9GOFEMD1Kp9WENpv7JkKklZ0Id9dpYOc5rcFKnDZZVkPzMHxXNnYcDblF6BbU/n4r5XfXIofvxEKwXFUxlTihzN10VJE+jF7euR+mdgzu752DFWhuX15X3UOSTug==';

  final BarcodeCaptureListener barcodeCaptureListener;

  const BarcodeScannerScreen({Key? key, required this.barcodeCaptureListener})
      : super(key: key);

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() =>
      _BarcodeScannerScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with WidgetsBindingObserver {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late BarcodeCapture _barcodeCapture;
  late DataCaptureView _captureView;

  bool _isPermissionMessageVisible = false;

  _BarcodeScannerScreenState(this._context);

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _camera?.switchToDesiredState(FrameSourceState.on);
          }
        }));
  }

  get barcodeCapture => _barcodeCapture;

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    // Use the recommended camera settings for the BarcodeCapture mode.
    _camera?.applySettings(BarcodeCapture.recommendedCameraSettings);

    // Switch camera on to start streaming frames and enable the barcode tracking mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The barcode capture process is configured through barcode capture settings
    // which are then applied to the barcode capture instance that manages barcode capture.
    var captureSettings = BarcodeCaptureSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
    // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
    // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
    //todo über Setting konfigurieren
    captureSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.qr,
      Symbology.dataMatrix,
      Symbology.code39,
      Symbology.code128,
      Symbology.interleavedTwoOfFive
    });

    // Some linear/1d barcode symbologies allow you to encode variable-length data. By default, the Scandit
    // Data Capture SDK only scans barcodes in a certain length range. If your application requires scanning of one
    // of these symbologies, and the length is falling outside the default range, you may need to adjust the "active
    // symbol counts" for this symbology. This is shown in the following few lines of code for one of the
    // variable-length symbologies.
    captureSettings.settingsForSymbology(Symbology.code39).activeSymbolCounts =
        [for (var i = 7; i <= 20; i++) i].toSet();

    // Create new barcode capture mode with the settings from above.
    _barcodeCapture = BarcodeCapture.forContext(_context, captureSettings)
      // Register self as a listener to get informed whenever a new barcode got recognized.
      ..addListener(widget.barcodeCaptureListener);

    // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a barcode capture overlay to the data capture view to render the location of captured barcodes on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    BarcodeCaptureOverlay overlay =
        BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(
            _barcodeCapture, _captureView, BarcodeCaptureOverlayStyle.frame);

    var cameraLightOn = Provider.of<SettingsProvider>(context, listen: false)
        .settingsModel
        .cameraLight;

    _camera?.desiredTorchState =
        cameraLightOn ? TorchState.auto : TorchState.off;

    ScanViewFinderMode mode =
        Provider.of<SettingsProvider>(context, listen: false)
            .settingsModel
            .scanViewFinderMode;
    switch (mode) {
      case ScanViewFinderMode.rectangle:
        overlay
          ..viewfinder = RectangularViewfinder.withStyleAndLineStyle(
              RectangularViewfinderStyle.square,
              RectangularViewfinderLineStyle.light);
        break;
      case ScanViewFinderMode.line:
        overlay
          ..viewfinder =
              LaserlineViewfinder.withStyle(LaserlineViewfinderStyle.legacy);
        break;
      case ScanViewFinderMode.aimer:
        overlay..viewfinder = AimerViewfinder();
        break;
    }

    // Adjust the overlay's barcode highlighting to match the new viewfinder styles and improve the visibility of feedback.
    // With 6.10 we will introduce this visual treatment as a new style for the overlay.
    //todo Farbe noch über Settings
    overlay.brush = Brush(
        Color.fromARGB(0, 0, 0, 0), Color.fromARGB(255, 255, 255, 255), 3);

    _captureView.addOverlay(overlay);

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);

    if (Provider.of<SettingsProvider>(context, listen: false)
        .settingsModel
        .scanditManualScan)
      _barcodeCapture.isEnabled = false;
    else
      _barcodeCapture.isEnabled = true;
  }

  void startScanning() {
    _barcodeCapture.isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = PlatformText('No permission to access the camera!',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      // child = _captureView;
      child = LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: _captureView,
            ),
            Positioned(
              bottom: 16,
              right: 80,
              child: Visibility(
                visible: Provider.of<SettingsProvider>(context, listen: false)
                    .settingsModel
                    .scanditManualScan,
                child: FloatingActionButton(
                  onPressed: () {
                    startScanning();
                  },

                  backgroundColor: Colors.green,
                  child: Icon(Icons.barcode_reader),
                  heroTag:
                      'manual_barcode_scan', // Helden-Tag für Hero-Animationen
                ),
              ),
            ),
          ],
        );
      });
    }
    return Center(child: child);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _camera?.switchToDesiredState(FrameSourceState.off);
    }
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _barcodeCapture.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  T? _ambiguate<T>(T? value) => value;
}
