import 'package:dio/dio.dart';
import 'sales_report.dart';

class SalesService {
  final Dio _dio = Dio();

  Future<List<SalesReport>> fetchSalesReport(DateTime startDate, DateTime endDate) async {
    final response = await _dio.get(
      'https://votre-api.com/sales-report',
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );

    if (response.statusCode == 200) {
      return (response.data as List).map((json) => SalesReport.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération du rapport de vente');
    }
  }
}
