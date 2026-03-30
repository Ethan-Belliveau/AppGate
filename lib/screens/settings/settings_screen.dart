import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock_clock),
            title: const Text('Default Block Schedule'),
            subtitle: const Text('Set times when all apps are blocked'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('Purchases'),
            subtitle: const Text('Restore previous unlocks'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About AppGate'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
