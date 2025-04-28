import 'package:flutter/material.dart';

// Gotta make this stateful to handle the text fields
class ProfileScreen extends StatefulWidget {
  // Get the background color choice from the other screen
  final Color? currentBackgroundColor;

  const ProfileScreen({Key? key, this.currentBackgroundColor}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Need controllers for the text boxes
  late TextEditingController _nameController;
  late TextEditingController _designationController;
  // Focus nodes help with the keyboard popping up
  late FocusNode _nameFocusNode;
  late FocusNode _designationFocusNode; // Focus node for designation too

  @override
  void initState() {
    super.initState();
    // Set up the text controllers with starting text
    _nameController = TextEditingController(text: "Alex Doe"); // Start name
    _designationController = TextEditingController(text: "Flutter Developer"); // Start designation
    // Set up the focus nodes
    _nameFocusNode = FocusNode();
    _designationFocusNode = FocusNode(); // Init designation focus

    // Try to make the keyboard show for the name field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check if screen is still there before focusing
      if (mounted) {
        FocusScope.of(context).requestFocus(_nameFocusNode);
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controllers and focus stuff when done
    _nameController.dispose();
    _designationController.dispose();
    _nameFocusNode.dispose();
    _designationFocusNode.dispose(); // Clean up designation focus too
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is on
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Get the background color passed in
    final currentBackgroundColor = widget.currentBackgroundColor;

    // Style for the button
    // Figure out button background
    Color buttonBackgroundColor = isDarkMode ? Colors.grey[850]! : Colors.grey[100]!;

    // Figure out button text color
    Color buttonForegroundColor;
    if (isDarkMode) {
      // Dark mode: use the custom color or white if default
      buttonForegroundColor = currentBackgroundColor ?? Colors.white;
    } else {
      // Light mode: text is purple
      buttonForegroundColor = Colors.purple;
    }

    final ButtonStyle sharedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonBackgroundColor,
      foregroundColor: buttonForegroundColor, // Use the color we figured out
      elevation: 5, // Little shadow effect
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Keep it rounded
      ),
    );
    // Button style done

    // Basic screen layout
    return Scaffold(
      // Top bar setup (transparent)
      appBar: AppBar(
        title: Text("Edit Profile"), // Changed the title
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      // Main content area
      body: GestureDetector(
        // Tap outside text boxes to hide keyboard
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Show the profile pic (doesn't change)
                CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 24),

                // Name text box
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode, // Link the focus node
                  textAlign: TextAlign.center, // Center the text
                  style: Theme.of(context).textTheme.headlineMedium, // Use the theme's text style
                  decoration: InputDecoration(
                    hintText: "Your Name",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(height: 12), // Space things out

                // Designation text box
                TextField(
                  controller: _designationController,
                  focusNode: _designationFocusNode, // Link the focus node
                  textAlign: TextAlign.center, // Center the text
                  style: Theme.of(context).textTheme.titleMedium, // Use the theme's text style
                  decoration: InputDecoration(
                    hintText: "Your Designation",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                SizedBox(height: 40), // Space things out

                // Done button
                ElevatedButton(
                  style: sharedButtonStyle, // Use the button style from above
                  child: Text("Done Editing"), // Changed text
                  onPressed: () {
                    Navigator.pop(context); // Go back to previous screen
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
