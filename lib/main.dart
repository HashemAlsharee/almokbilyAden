// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'core/theme/app_theme.dart';
// import 'features/home/presentation/screens/home_screen.dart';

// void main() {
//   runApp(const AlMaqbaliShowroomApp());
// }

// class AlMaqbaliShowroomApp extends StatelessWidget {
//   const AlMaqbaliShowroomApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Al-Maqbali Showroom',
//       theme: AppTheme.lightTheme,
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('ar', 'AE'), // Arabic
//       ],
//       locale: const Locale('ar', 'AE'), // Force Arabic / RTL
//       home: const HomeScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Reference width of a typical phone in portrait mode.
  /// The app was designed and tested at this width.
  static const double _referenceWidth = 430.0;

  /// Screens must exceed this logical width to trigger scaling.
  /// Keeps phones and small tablets unscaled.
  static const double _scaleThreshold = 700.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlMokbily',
      theme: AppTheme.lightTheme,
      home: const HomePage(),
      builder: (context, child) => _responsiveWrapper(context, child!),
    );
  }

  /// Scales the entire UI proportionally for large displays (kiosk/signage).
  ///
  /// On phone-sized screens (≤ [_scaleThreshold] logical pixels wide),
  /// returns the child unchanged — the app behaves exactly as before.
  ///
  /// On larger screens, the UI is rendered at phone-like internal dimensions
  /// and then scaled up via [FittedBox] to fill the display. Flutter paints
  /// through canvas transforms, so text and vector graphics remain crisp
  /// at the display's native resolution.
  static Widget _responsiveWrapper(BuildContext context, Widget child) {
    final data = MediaQuery.of(context);
    final screenWidth = data.size.width;
    final screenHeight = data.size.height;

    // Don't scale on phone-sized or small-tablet screens.
    if (screenWidth <= _scaleThreshold) return child;

    // Scale factor: how many times larger the screen is than the reference.
    final scale = screenWidth / _referenceWidth;

    // Internal dimensions the app will lay out in (phone-like).
    final scaledWidth = _referenceWidth;
    final scaledHeight = screenHeight * _referenceWidth / screenWidth;

    return MediaQuery(
      data: data.copyWith(
        size: Size(scaledWidth, scaledHeight),
        padding: EdgeInsets.only(
          left: data.padding.left / scale,
          top: data.padding.top / scale,
          right: data.padding.right / scale,
          bottom: data.padding.bottom / scale,
        ),
        viewPadding: EdgeInsets.only(
          left: data.viewPadding.left / scale,
          top: data.viewPadding.top / scale,
          right: data.viewPadding.right / scale,
          bottom: data.viewPadding.bottom / scale,
        ),
        viewInsets: EdgeInsets.only(
          left: data.viewInsets.left / scale,
          top: data.viewInsets.top / scale,
          right: data.viewInsets.right / scale,
          bottom: data.viewInsets.bottom / scale,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: scaledWidth,
          height: scaledHeight,
          child: child,
        ),
      ),
    );
  }
}
