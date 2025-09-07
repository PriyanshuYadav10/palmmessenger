import 'package:flutter/material.dart';
import 'package:palmmessenger/config/theme/textstyles.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/chat_screen.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/chats/chat_screen.dart';
import 'package:palmmessenger/features/presentation/screens/Dashboard/settings_screen.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/images.dart';
import '../../../data/encryption/rsa_helper.dart';
import '../../../data/encryption/rsa_key_helper.dart';
import '../../../data/model/user_model.dart';
import '../../../helper/alertDiaolg.dart';
import '../../../helper/database_service.dart';
import '../../../helper/websocket_service.dart';
import '../../../provider/authProvider.dart';
import '../../utility/app_shared_prefrence.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;
  List<Widget>? _screens;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getProfile());
  }

  Future<void> initDashboard() async {

    final rsaHelper = RSAHelper();

    final prefs = AppSharedPref();
    var privatePem = await prefs.read('privateKey');
    print('private--> $privatePem');

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = UserModel(
      id: authProvider.userProfileDataModel?.profile?.sId.toString() ?? '',
      name: authProvider.userProfileDataModel?.profile?.name.toString() ?? '',
      publicKey: authProvider.userProfileDataModel?.profile?.publicKey.toString() ?? '',
    );

    final db = SecureStorageService();
    await db.saveUser(currentUser);

    final socket = WebSocketService();
    socket.connect();

    print('localId-->${currentUser.id.toString()}');
    print('localId-->${authProvider.userProfileDataModel?.profile?.sId.toString()}');
    setState(() {
      _screens = [
        ChatListScreen(
          localUserId: currentUser.id,
          rsaHelper: rsaHelper,
          privateKeyPem: privatePem,
          storage: db,
          socket: socket,
        ),
        const Center(child: Text("Calls")),
        const Center(child: Text("Ghost")),
        // const Center(child: Text("Updates")),
        SettingsScreen(),
      ];
    });

  }


  Future<void> getProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getProfile();
    if (authProvider.userProfileDataModel?.success == true) {
      final prefs = AppSharedPref();
      var  accessToken = '';
      final userData = await prefs.read("userData");
      accessToken = userData['accessToken'].toString();
      authProvider.userProfileDataModel?.profile?.accessToken = accessToken;
      prefs.save("userData", authProvider.userProfileDataModel?.profile);
      prefs.read('userData').then((data) {
        print('data--> ${data}');
      });
      initDashboard();
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
        child: _screens?[selectedIndex],
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
            // _navItem(updated, "Updates", 3),
            _navItem(settings, "Settings", 3),
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
