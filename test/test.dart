class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? userInfo;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('authToken');

    if (authToken != null) {
      isLoggedIn = true; // User is logged in
      var fetchedUserInfo = await fetchUserInfo(authToken);
      if (fetchedUserInfo != null) {
        setState(() {
          userInfo = fetchedUserInfo;
        });
      }
    } else {
      isLoggedIn = false; // User is not logged in
      print('Auth token not found');
      // Handle the case when authToken is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... other widget code ...

    // Replace the existing ListView with this updated version
    Expanded(
      child: ListView(
        children: [
          // ... other SettingTile widgets ...

          // Conditionally display Login or Logout based on isLoggedIn
          if (!isLoggedIn)
            SettingTile(
              onTap: () => Navigator.pushNamed(
                context,
                LoginPage.id, // Replace with the ID or route name of your login page
              ),
              icon: Icons.login,
              title: 'Login',
            ),
          if (isLoggedIn)
            SettingTile(
              onTap: () {
                // Implement logout functionality here
                // For example, clear the authToken and update the state
              },
              icon: Icons.logout,
              title: 'Logout',
            ),

          // ... other SettingTile widgets ...
        ],
      ),
    ),

    // ... other widget code ...
  }
}
