import 'package:flutter/material.dart';
import 'package:edenresto/models/sales_report.dart';
import 'package:edenresto/models/sales_service.dart';
class SalesReportScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SalesReportScreen({super.key, required this.startDate, required this.endDate});

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  late Future<List<SalesReport>> futureSalesReports;

  @override
  void initState() {
    super.initState();
    futureSalesReports = SalesService().fetchSalesReport(widget.startDate, widget.endDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapport de vente'),
      ),
      body: FutureBuilder<List<SalesReport>>(
        future: futureSalesReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final reports = snapshot.data!;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Date : ${report.date.toLocal().toString().split(' ')[0]}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total des ventes : ${report.totalSales.toStringAsFixed(2)} €'),
                      ...report.itemsSold.map((item) {
                        return Text('${item.item} - ${item.quantity} vendu(s)');
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
