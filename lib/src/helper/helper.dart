import 'dart:io';
// import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:permission_handler/permission_handler.dart';

class Helper {
  // static void requiredLoginFuntion(
  //     {required BuildContext context, required Function callBack}) {
  //   if (BlocProvider.of<AuthenticationBloc>(context).state is Authenticated) {
  //     callBack();
  //   } else {
  //     Navigator.pushNamed(context, loginRegister, arguments: true);
  //   }
  // }

  static String capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  // static void imgFromGallery(onPicked(dynamic image)) async {
  //   final picker = ImagePicker();
  //   XFile? imageP =
  //       await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  //   final File image = File(imageP!.path);
  //   onPicked(image);
  // }

 static Future<void> imgFromGallery2(Function(dynamic) onPicked) async {
  try {
    final picker = ImagePicker();
    final XFile? imageP = await picker.pickImage(source: ImageSource.gallery);
    if (imageP == null) return;

    if (kIsWeb) {
      Uint8List imageBytes = await imageP.readAsBytes();
      onPicked(imageBytes);
    } else {
      onPicked(File(imageP.path));
    }
  } catch (e) {
    debugPrint("Image picker error: $e");
  }
}

static Future<void> imgFromCamera(Function(dynamic) onPicked) async {
  try {
    final picker = ImagePicker();
    final XFile? imageP = await picker.pickImage(source: ImageSource.camera);
    if (imageP == null) return;

    if (kIsWeb) {
      Uint8List imageBytes = await imageP.readAsBytes();
      onPicked(imageBytes);
    } else {
      onPicked(File(imageP.path));
    }
  } catch (e) {
    debugPrint("Camera picker error: $e");
  }
}


  // String translate(BuildContext context, String key) {
  //   try {
  //     String result = AppLocalizations.of(context)!.translate(key)!;
  //     return result;
  //   } catch (e) {
  //     log("Translation is not available for key '$key'");
  //     return "null";
  //   }
  // }

  // static handleState(
  //     {required ErrorState state, required BuildContext context}) {
  //   print(state.error.runtimeType);

  //   if (state.error == 401) {
  //     print("d");
  //     BlocProvider.of<AuthenticationBloc>(context).add(LogoutPressed());
  //   } else {
  //     print("d2");
  //     return;
  //   }
  // }
  // }

  // Random random = new Random();
  // List<List<Color>> _gradientColorList = [
  //   [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
  //   [Color(0xFFbc4e9c), Color(0xFFf80759)],
  //   [Color(0xFF642B73), Color(0xFFC6426E)],
  //   [Color(0xFFC33764), Color(0xFF1D2671)],
  //   [Color(0xFFcb2d3e), Color(0xFFef473a)],
  //   [Color(0xFFec008c), Color(0xFFec008c)],
  //   [Color(0xFFf953c6), Color(0xFFb91d73)],
  //   [Color(0xFF7F00FF), Color(0xFFE100FF)],
  //   [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
  //   [Color(0xFFf12711), Color(0xFFf5af19)]
  // ];

  /// Get current device location and a readable address.
  /// Returns a map with keys: 'latitude', 'longitude', 'address'
  /// or null when not available / permission denied.
  // static Future<Map<String, String>?> getCurrentAddress({
  //   required BuildContext context,
  //   bool showDialogs = true,
  //   Duration locationTimeout = const Duration(seconds: 20),
  // }) async {
  //   // 1. Ensure location service is enabled
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     if (showDialogs) {
  //       await _showAlertDialog(
  //         context,
  //         title: 'Location Disabled',
  //         content:
  //             'Location services are disabled. Please enable them in device settings.',
  //         positiveText: 'Open Settings',
  //         onPositive: () => Geolocator.openLocationSettings(),
  //       );
  //     }
  //     return null;
  //   }

  //   // 2. Check permission
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       if (showDialogs) {
  //         await _showSimpleDialog(context, 'Permission Denied',
  //             'Location permission denied. Please grant permission to continue.');
  //       }
  //       return null;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     if (showDialogs) {
  //       await _showAlertDialog(
  //         context,
  //         title: 'Permission Denied Permanently',
  //         content:
  //             'Location permission is permanently denied. Open app settings to enable it.',
  //         positiveText: 'App Settings',
  //         onPositive: () => openAppSettings(),
  //       );
  //     }
  //     return null;
  //   }

  //   // 3. Get current position
  //   Position position;
  //   try {
  //     position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //       timeLimit: locationTimeout,
  //     );
  //   } catch (e) {
  //     if (showDialogs) {
  //       await _showSimpleDialog(
  //           context, 'Error', 'Unable to get location: ${e.toString()}');
  //     }
  //     return null;
  //   }

  //   // 4. Reverse geocode into a friendly address (best effort)
  //   String friendlyAddress;
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude,
  //       position.longitude,
  //     );

  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       final parts = <String>[
  //         place.name.toString(),
  //         place.street.toString(),
  //         place.subLocality.toString(),
  //         place.locality.toString(),
  //         place.administrativeArea.toString(),
  //         place.postalCode.toString(),
  //         place.country.toString()
  //       ].where((p) => p != null && p.trim().isNotEmpty).toList();

  //       friendlyAddress = parts.isNotEmpty
  //           ? parts.join(', ')
  //           : '${position.latitude}, ${position.longitude}';
  //     } else {
  //       friendlyAddress = '${position.latitude}, ${position.longitude}';
  //     }
  //   } catch (e) {
  //     // On web or in some edge cases placemarkFromCoordinates might fail.
  //     // Fallback to coordinates as the address.
  //     friendlyAddress = '${position.latitude}, ${position.longitude}';
  //   }

  //   return {
  //     'latitude': position.latitude.toString(),
  //     'longitude': position.longitude.toString(),
  //     'address': friendlyAddress,
  //   };
  // }

  // Simple alert dialog with one positive action (and optional cancel)
  static Future<void> _showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String positiveText = 'OK',
    VoidCallback? onPositive,
    String? negativeText,
    VoidCallback? onNegative,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (negativeText != null)
            TextButton(
              child: Text(negativeText),
              onPressed: () {
                Navigator.of(ctx).pop();
                if (onNegative != null) onNegative();
              },
            ),
          TextButton(
            child: Text(positiveText),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onPositive != null) onPositive();
            },
          ),
        ],
      ),
    );
  }

  static Future<void> _showSimpleDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}


  

  // String translate(BuildContext context, String key) {
  //   try {
  //     String result = AppLocalizations.of(context)!.translate(key)!;
  //     return result;
  //   } catch (e) {
  //     log("Translation is not available for key '$key'");
  //     return "null";
  //   }
  // }

//   static handleState(
//       {required ErrorState state, required BuildContext context}) {
//     print(state.error.runtimeType);

//     if (state.error == 401) {
//       print("d");
//       BlocProvider.of<AuthenticationBloc>(context).add(LogoutPressed());
//     } else {
//       print("d2");
//       return;
//     }
//   }
// }

// Random random = new Random();
// List<List<Color>> _gradientColorList = [
//   [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
//   [Color(0xFFbc4e9c), Color(0xFFf80759)],
//   [Color(0xFF642B73), Color(0xFFC6426E)],
//   [Color(0xFFC33764), Color(0xFF1D2671)],
//   [Color(0xFFcb2d3e), Color(0xFFef473a)],
//   [Color(0xFFec008c), Color(0xFFec008c)],
//   [Color(0xFFf953c6), Color(0xFFb91d73)],
//   [Color(0xFF7F00FF), Color(0xFFE100FF)],
//   [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
//   [Color(0xFFf12711), Color(0xFFf5af19)]
// ];
// }
