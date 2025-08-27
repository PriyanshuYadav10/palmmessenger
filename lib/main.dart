

import 'package:flutter/material.dart' hide Key;
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:palmmessenger/features/provider/authProvider.dart';
import 'package:palmmessenger/features/provider/chatProvider.dart';
import 'package:palmmessenger/features/provider/settingProvider.dart';
import 'injection-container.dart' as di;
import 'package:palmmessenger/config/theme/app_themes.dart';
import 'package:palmmessenger/features/presentation/screens/SplashScreen.dart';
import 'package:palmmessenger/features/provider/homeProvider.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';



  print('plainText  $plainText');

  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(OKToast(
    child: MultiProvider(providers: [
      ChangeNotifierProvider(create: (context)=>di.sl<AuthProvider>()),
      ChangeNotifierProvider(create: (context)=>di.sl<HomeProvider>()),
      ChangeNotifierProvider(create: (context)=>di.sl<ChatProvider>()),
      ChangeNotifierProvider(create: (context)=>di.sl<Settingsprovider>())
    ],
    child: MyApp(),
    ),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(textScaleFactor: 0.8),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Palm Messenger',
        theme: theme(),
        home: SplashScreen(),
      ),
    );
  }
}
