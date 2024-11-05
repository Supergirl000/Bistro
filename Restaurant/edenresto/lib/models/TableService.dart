import 'package:dio/dio.dart';
import 'TableModel.dart';

class TableService {
  final Dio dio = Dio();

  TableService() {
    dio.options.baseUrl = 'https://votre-api-url.com'; // Remplacez par l'URL de votre API
  }

  Future<List<TableModel>> fetchTables() async {
    try {
      final response = await dio.get('/tables');
      return (response.data as List)
          .map((table) => TableModel.fromJson(table))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des tables');
    }
  }

  Future<void> createTable(TableModel table) async {
    try {
      await dio.post('/tables', data: table.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la création de la table');
    }
  }

  Future<void> updateTable(TableModel table) async {
    try {
      await dio.put('/tables/${table.id}', data: table.toJson());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la table');
    }
  }

  Future<void> deleteTable(int id) async {
    try {
      await dio.delete('/tables/$id');
    } catch (e) {
      throw Exception('Erreur lors de la suppression de la table');
    }
  }
}
