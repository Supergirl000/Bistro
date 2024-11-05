import 'package:flutter/material.dart';
import 'package:edenresto/Widgets/dashboard_widget.dart'; // Update with correct path for DashboardWidget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resto Billing App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Resto Billing App Home'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Welcome to the Dashboard",
              style: Theme.of(context).textTheme.titleLarge, // Updated text style
            ),
          ),
          const Expanded(
            child: DashboardWidget(), // Embeds the DashboardWidget within the Home screen
          ),
        ],
      ),
    );
  }
}
