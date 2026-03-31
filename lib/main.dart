import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'screens/shell/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const AppGate());
}

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppGate',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // Solid dark background so nothing bleeds through on web
      builder: (context, child) => Container(
        color: AppColors.background,
        child: child,
      ),
      home: const AppShell(),
    );
  }
}
