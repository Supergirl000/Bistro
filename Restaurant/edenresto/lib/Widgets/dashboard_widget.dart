import 'package:flutter/material.dart';
import 'package:edenresto/interfaces/MenuManagementScreen.dart';
import 'package:edenresto/Widgets/BillingScreenManagement.dart';
import 'package:edenresto/interfaces/PurchaseOrderScreen.dart';
import 'package:edenresto/interfaces/TableManagementScreen.dart';
import 'EmployeeManagementScreen.dart'; // Import your EmployeeManagementScreen
import 'package:edenresto/interfaces/SalesReportScreen.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;

  // Function to handle navigation when a card is tapped
  void _onFeatureTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MenuManagementScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BillingScreenManagement()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TableManagementScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PurchaseOrderScreen()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalesReportScreen(
      startDate: DateTime.now().subtract(const Duration(days: 30)), // Exemple : les 30 derniers jours
      endDate: DateTime.now(), ),
  ),
);
        
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmployeeManagementScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Number of columns in the grid
          childAspectRatio: 1.3, // Aspect ratio of each card
          children: <Widget>[
            _buildFeatureCard('Menu', Icons.restaurant_menu, 0),
            _buildFeatureCard('Billing', Icons.receipt, 1),
            _buildFeatureCard('Table Management', Icons.table_chart, 2),
            _buildFeatureCard('Orders', Icons.list_alt, 3),
            _buildFeatureCard('Reports', Icons.bar_chart, 4),
            _buildFeatureCard('Employees', Icons.person, 5), // Added Employee Management Card
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardWidget()),
            );
          } else {
            // Navigate to Settings screen (not implemented here)
          }
        },
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onFeatureTapped(index),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // Add padding for spacing
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 48,
                color: Colors.teal,
              ),
              const SizedBox(height: 10),  // Space between icon and text
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,  // Font size for the title
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


