import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/chat_screen.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/images.dart';
import '../../../helper/alertDiaolg.dart';
import '../../../provider/authProvider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    ChatScreen(),
    Center(child: Text("Calls")),
    Center(child: Text("Ghost")),
    Center(child: Text("Updates")),
    SettingsScreen(),
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfile();
    });
  }

  Future<void> getProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getProfile();
    if (authProvider.userProfileDataModel?.success == true) {
    } else {
      showAlertError(authProvider.message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(app_bg), fit: BoxFit.cover),
        ),
        child: _screens[selectedIndex],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          // color:  Colors.transparent, // dark translucent background
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.blueAccent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(chat, "Chats", 0),
            _navItem(calls, "Calls", 1),
            _navItem(ghost, "Ghost", 2),
            _navItem(updated, "Updates", 3),
            _navItem(settings, "Settings", 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem(String icon, String label, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            color: isSelected ? Colors.white : Colors.blueAccent,
            width: 24,
            height: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Styles.semiBoldTextStyle(
              size: 15,
              color: isSelected ? Colors.white : Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
