import 'package:flutter/material.dart';
import 'package:frontend/pages/unblocking_challan_worklist_page.dart';
import 'package:frontend/theme/app_theme.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainLayout(child: UnblockingChallanWorklistPage()),
    ),
  );
}

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).size.width >= 750 ? const EdgeInsets.symmetric(vertical: 20, horizontal: 70) : EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: child,
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: AppTheme.primaryColor,
      child: Center(
        child: Text('Navbar', style: TextStyle(color: AppTheme.primaryWhite)),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: AppTheme.backgroundColor,
      child: Center(
        child: Text(
          'Footer',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
