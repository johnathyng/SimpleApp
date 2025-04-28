import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'settings_screen.dart'; // Need this for settings page

// This is the home screen widget, doesn't need state itself
class HomeScreen extends StatelessWidget {
  // Get functions and state from the main app widget
  final VoidCallback toggleThemeCallback;
  final bool isLoggedIn;
  final Function(bool) setLoginStatusCallback;
  final Function(Color?) setBackgroundColorCallback;
  final Color? currentBackgroundColor; // Get current background color choice

  // Constructor to get the stuff passed in
  const HomeScreen({
    Key? key,
    required this.toggleThemeCallback,
    required this.isLoggedIn,
    required this.setLoginStatusCallback,
    required this.setBackgroundColorCallback,
    required this.currentBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is on
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // --- Style for the buttons ---
    // Button background color
    Color buttonBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.grey[100]!;

    // Button text color logic
    Color buttonForegroundColor;
    if (isDarkMode) {
      // Dark Mode: Use custom color if set, otherwise white
      buttonForegroundColor = currentBackgroundColor ?? Colors.white;
    } else {
      // Light Mode: Always purple text
      buttonForegroundColor = Colors.purple;
    }

    // Put the style together
    final ButtonStyle sharedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonBackgroundColor,
      foregroundColor: buttonForegroundColor, // Use the color we figured out
      elevation: 5, // Little shadow
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
    );
    // --- Button style done ---


    // Basic screen layout
    return Scaffold(
      // Top bar setup (transparent)
      appBar: AppBar(
        // Title alignment comes from main.dart theme
        title: Text("Welcome ${isLoggedIn ? '(Logged In)' : ''}"), // Show if logged in
        actions: [
          // Theme toggle button on the right
          IconButton(
            icon: Icon(
                isDarkMode
                    ? Icons.light_mode // Sun icon
                    : Icons.dark_mode, // Moon icon
                // Use color from app bar theme
                color: Theme.of(context).appBarTheme.foregroundColor),
            tooltip: 'Toggle Theme', // Text on long press
            onPressed: toggleThemeCallback, // Call the function from main app
          ),
        ],
      ),
      // Main part of the screen
      body: Padding( // Add space around edges
        padding: const EdgeInsets.all(16.0),
        child: Center( // Center everything
          child: Column(
            // Center stuff vertically
            mainAxisAlignment: MainAxisAlignment.center,
            // Center stuff horizontally
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome message
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Welcome to the Profile App!",
                  // Use text style from theme
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center, // Center the text itself
                ),
              ),
              SizedBox(height: 20), // Space

              // --- Profile Button ---
              ElevatedButton(
                style: sharedButtonStyle, // Use the style defined above
                child: Text("View/Edit Profile"),
                onPressed: () {
                  // Go to profile screen
                  Navigator.push(
                    context,
                    // Pass background color choice to profile screen
                    MaterialPageRoute(builder: (context) => ProfileScreen(currentBackgroundColor: currentBackgroundColor)),
                  );
                },
              ),
              SizedBox(height: 15), // Space

              // --- Settings Button ---
              ElevatedButton(
                style: sharedButtonStyle, // Use the same style
                child: Text("Settings"),
                onPressed: () {
                  // Go to settings screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen(
                      // Pass down all the functions/state needed for settings
                      toggleThemeCallback: toggleThemeCallback,
                      isLoggedIn: isLoggedIn,
                      setLoginStatusCallback: setLoginStatusCallback,
                      setBackgroundColorCallback: setBackgroundColorCallback,
                      currentBackgroundColor: currentBackgroundColor,
                    )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
