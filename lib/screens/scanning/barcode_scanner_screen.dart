import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:itavero_mobile/models/settings_model.dart';
import 'package:itavero_mobile/provider/settings_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

const String licenseKey = 'AXe64LeBIzGcMYxuxQ2Hrlwe7PXwPbCf/hnoLL5AHB84JQCyAXB4OMpts/6zcFXNTnYwVaNG1RbGYp75hHmG329Epdv/TvKNRVXvZOdcczPWL6p1LGoISAECuI9eDVfzhWDCMbMsnEFvQr0r63xyVOWUdSwJUF8qtKLqe4DzJvctCGPRioJnbrew0Tt2Ce2V90PPtbw1NdOyQbcxEvjY/N6wdABBr2hzIaZkpMt/S4bh74xAoeN1yZGTuuPWFloKiMaNf3+QAyzNxmriFlXib8glIBas/kaQUsfUl6fpRBNeluTBxoMfxLFL/MuXsxG6cMZLwFr1jt9DIQvShQG8khAVylVR5z87591coZHLroh/AOAB3X2wHBrqzyXasGicuFsYesqQDWn4L2A4ZRTQPuqaH9FiwPK1mhNhvB8oijMmVNisFvR/fLwmh9rvxMtGX6k3rSuMqliCaP5HpGiYPESgR/LrZg2moh/PShAtq3uXIEVoJiPV+fTq+rmuxWeVyyM9HYEDKzkjOibfQ/YsTSPHtXPBTSKvLSE49qcdTj+8imdLIV7YpA0B7drbPLfSqeR+GoG3GYOuITUORnXNY+a9II1TH/Qt5o+SCd7nSNCeTEH8/YEg4UEjtNL9nPOVImRH8gEBA8bjf5SWzQo2anSWJzEkc7Qhb8ejpiAKwo5WZ4NWz6EdlOwKjPTIrb6CwvjHAptn4c2cThI+YGGspkgt/QAohRW2Kbnpcpd/oF0X0BiE+mmY0PCxLZShe6Ji3YU0hoKyai8vYOCoCq1+GklnzfN+SrexktM2XPY=';

class BarcodeScannerScreen extends StatefulWidget {
  final BarcodeCaptureListener barcodeCaptureListener;

  const BarcodeScannerScreen({Key? key, required this.barcodeCaptureListener}) : super(key: key);

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _BarcodeScannerScreenState(DataCaptureContext.forLicenseKey(licenseKey));
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
    BarcodeCaptureOverlay overlay = BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(
        _barcodeCapture, _captureView, BarcodeCaptureOverlayStyle.frame);


      ScanViewFinderMode mode = Provider.of<SettingsProvider>(context,listen: false).settingsModel.scanViewFinderMode;
      switch ( mode ) {
        case ScanViewFinderMode.rectangle:
          overlay ..viewfinder =
          RectangularViewfinder.withStyleAndLineStyle(
              RectangularViewfinderStyle.square, RectangularViewfinderLineStyle.light);
          break;
        case ScanViewFinderMode.line:

          overlay ..viewfinder = LaserlineViewfinder.withStyle(LaserlineViewfinderStyle.legacy);
          break;
        case ScanViewFinderMode.aimer:
          overlay ..viewfinder = AimerViewfinder();
          break;
      }



    // Adjust the overlay's barcode highlighting to match the new viewfinder styles and improve the visibility of feedback.
    // With 6.10 we will introduce this visual treatment as a new style for the overlay.
    //todo Farbe noch über Settings
    overlay.brush = Brush(Color.fromARGB(0, 0, 0, 0), Color.fromARGB(255, 255, 255, 255), 3);

    _captureView.addOverlay(overlay);

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeCapture.isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = PlatformText('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      child = _captureView;
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
  void didUpdateSession(BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {}

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