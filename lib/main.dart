import 'package:flutter/material.dart';
import 'home_screen.dart';

// App starts here
void main() {
  runApp(MyApp());
}

// This is the main app widget, gotta be stateful for theme stuff
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // Start with light mode
  bool _isLoggedIn = false; // Start logged out
  Color? _selectedBackgroundColor; // Track chosen background color, null means default

  // Function to flip the theme
  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Function to set if user is logged in or out
  void _setLoginStatus(bool isLoggedIn) {
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  // Function to change the background color
  void _setBackgroundColor(Color? color) {
    setState(() {
      _selectedBackgroundColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- Figure out the colors based on settings ---

    // Background color stuff
    final effectiveLightBg = _selectedBackgroundColor ?? ThemeData.light().scaffoldBackgroundColor; // Light bg = chosen color or default light
    final effectiveDarkBg = ThemeData.dark().scaffoldBackgroundColor; // Dark bg = always default dark

    // Text color stuff
    final defaultLightTextColor = ThemeData.light().textTheme.bodyMedium!.color!; // Normal light mode text color (dark grey)
    final defaultDarkTextColor = ThemeData.dark().textTheme.bodyMedium!.color!;   // Normal dark mode text color (light grey)
    // Dark mode text is the chosen color, unless default bg is chosen then it's normal dark mode text
    final effectiveDarkTextColor = _selectedBackgroundColor ?? defaultDarkTextColor;

    // App bar text/icon color stuff
    // Light mode: make sure text/icons contrast with background
    final appBarLightFg = ThemeData.estimateBrightnessForColor(effectiveLightBg) == Brightness.dark
        ? Colors.white : defaultLightTextColor;
    // Dark mode: use chosen color, or white if default bg
    final appBarDarkFg = _selectedBackgroundColor ?? Colors.white;

    // --- Make the text themes ---
    TextTheme createTextTheme(Color defaultColor) {
      // Define text styles using the color passed in
      return TextTheme(
        bodyLarge: TextStyle(color: defaultColor),
        bodyMedium: TextStyle(color: defaultColor), // Normal text
        titleMedium: TextStyle(color: defaultColor.withOpacity(0.8)), // Subtitles maybe
        titleLarge: TextStyle(color: defaultColor, fontSize: 18),
        headlineSmall: TextStyle(color: defaultColor, fontSize: 24),
        headlineMedium: TextStyle(color: defaultColor, fontSize: 28, fontWeight: FontWeight.w500),
        // Add more if needed
      );
    }

    final lightTextTheme = createTextTheme(defaultLightTextColor); // Light theme uses normal dark text
    final darkTextTheme = createTextTheme(effectiveDarkTextColor); // Dark theme uses the special text color


    // Build the actual app material thing
    return MaterialApp(
      title: 'Profile Theme App', // Shows up in task manager etc.
      // --- Light Theme Setup ---
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue, // Base color
        scaffoldBackgroundColor: effectiveLightBg, // Use the background color we figured out
        textTheme: lightTextTheme, // Use the light text theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Make app bar invisible
          elevation: 0, // No shadow
          foregroundColor: appBarLightFg, // Use the text/icon color we figured out
          iconTheme: IconThemeData(color: appBarLightFg),
          actionsIconTheme: IconThemeData(color: appBarLightFg),
          titleTextStyle: TextStyle(color: appBarLightFg, fontSize: 20, fontWeight: FontWeight.w500),
          centerTitle: false, // Keep title to the left
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Default button color
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: defaultLightTextColor.withOpacity(0.7)), // Other icons
        // Other light theme stuff here if needed
      ),

      // --- Dark Theme Setup ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue, // Base color
        scaffoldBackgroundColor: effectiveDarkBg, // Use the default dark background
        textTheme: darkTextTheme, // Use the special dark text theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Make app bar invisible
          elevation: 0, // No shadow
          foregroundColor: appBarDarkFg, // Use the text/icon color we figured out
          iconTheme: IconThemeData(color: appBarDarkFg),
          actionsIconTheme: IconThemeData(color: appBarDarkFg),
          titleTextStyle: TextStyle(color: appBarDarkFg, fontSize: 20, fontWeight: FontWeight.w500),
          centerTitle: false, // Keep title to the left
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700], // Default dark button color
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: effectiveDarkTextColor.withOpacity(0.7)), // Other icons use the text color
        // Other dark theme stuff here if needed
      ),

      themeMode: _themeMode, // Tells the app which theme (light/dark) is active
      // Set the first screen and pass down functions/state
      home: HomeScreen(
        toggleThemeCallback: _toggleTheme,
        isLoggedIn: _isLoggedIn,
        setLoginStatusCallback: _setLoginStatus,
        setBackgroundColorCallback: _setBackgroundColor,
        currentBackgroundColor: _selectedBackgroundColor,
      ),
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}
