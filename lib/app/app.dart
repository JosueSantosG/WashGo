import 'package:flutter/material.dart';

import 'package:washgo/config/routes/app_router.dart';
import 'package:washgo/config/theme/app_theme.dart';

class WashGoApp extends StatelessWidget {
  const WashGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WashGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
