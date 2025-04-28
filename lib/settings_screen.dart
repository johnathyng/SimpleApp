import 'package:flutter/material.dart';

// Convert to StatefulWidget to manage local state if needed (like selected color chip)
class SettingsScreen extends StatefulWidget {
  // Callbacks and state from parent
  final VoidCallback toggleThemeCallback;
  final bool isLoggedIn;
  final Function(bool) setLoginStatusCallback;
  final Function(Color?) setBackgroundColorCallback;
  final Color? currentBackgroundColor; // Receive current background color

  const SettingsScreen({
    Key? key,
    required this.toggleThemeCallback,
    required this.isLoggedIn,
    required this.setLoginStatusCallback,
    required this.setBackgroundColorCallback,
    required this.currentBackgroundColor,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Define predefined colors with 5 more added
  final Map<String, Color?> _colorOptions = {
    'Default': null, // Represents using the theme's default
    'White': Colors.white,
    'Mint': Color(0xFFCFFFE5), // Light mint green
    'Lavender': Color(0xFFE6E6FA), // Light purple
    'Peach': Color(0xFFFFE5B4), // Light orange/peach
    'Sky Blue': Color(0xFFADD8E6), // Light blue
    'Rose': Color(0xFFFFE4E1), // Light pink/rose
    'Cream': Color(0xFFFFFACD), // Light yellow/cream
    'Lilac': Color(0xFFD8BFD8), // Light purple/lilac
    'Aqua': Color(0xFFAFEEEE), // Light aqua/turquoise
    'Coral': Color(0xFFFFDAB9), // Light coral
  };

  @override
  Widget build(BuildContext context) {
    // Determine the current theme's brightness correctly
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Get the default text style for the current theme
    final defaultTextStyle = Theme.of(context).textTheme.bodyLarge;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      body: ListView( // Use ListView for potentially scrollable content
        padding: EdgeInsets.all(16.0),
        children: [
          // --- Dark Mode Toggle ---
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              // The value should reflect the actual current theme mode
              value: isDarkMode,
              onChanged: (value) {
                // Call the toggle theme callback passed from MyApp
                // This callback should handle the setState in MyApp
                widget.toggleThemeCallback();
              },
            ),
          ),
          Divider(),

          // --- Background Color Picker ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Background Color', style: Theme.of(context).textTheme.titleMedium),
          ),
          Wrap( // Use Wrap to lay out chips nicely
            spacing: 8.0, // Horizontal space between chips
            runSpacing: 4.0, // Vertical space between lines
            children: _colorOptions.entries.map((entry) {
              String name = entry.key;
              Color? colorValue = entry.value;
              // Determine if this chip represents the currently selected color
              bool isSelected = widget.currentBackgroundColor == colorValue;

              return ChoiceChip(
                label: Text(name),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    // Call callback to update background color in MyApp
                    widget.setBackgroundColorCallback(colorValue);
                  }
                },
                // Style selected chip differently for better visibility
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                // Ensure label color contrasts with chip background
                labelStyle: TextStyle(
                  // Use a contrasting color for selected chip, otherwise default theme color
                  color: isSelected
                      ? (ThemeData.estimateBrightnessForColor(Theme.of(context).primaryColor.withOpacity(0.3)) == Brightness.dark ? Colors.white : Colors.black87)
                      : defaultTextStyle?.color, // Use theme's default text color
                ),
                // Ensure chip background contrasts with scaffold background
                backgroundColor: Theme.of(context).chipTheme.backgroundColor ?? (isDarkMode ? Colors.grey[700] : Colors.grey[300]),
              );
            }).toList(),
          ),
          Divider(),

          // --- Login/Logout Button ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              // Use default theme styling or customize
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isLoggedIn ? Colors.redAccent : Colors.green, // Different color based on action
                foregroundColor: Colors.white,
              ),
              child: Text(widget.isLoggedIn ? 'Logout' : 'Login'),
              onPressed: () {
                // Call callback to update login status in MyApp
                widget.setLoginStatusCallback(!widget.isLoggedIn);
              },
            ),
          ),
        ],
      ),
    );
  }
}
