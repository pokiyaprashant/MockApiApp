import 'package:http/http.dart' as http;

class TaskApi {
  static String baseUrl = 'https://61b0b4413c954f001722a5ae.mockapi.io';

  static getTaskList() async {
    return await http.get(Uri.parse('$baseUrl/prashant'));
  }

  static addTask({required String? name, required String? url}) async {
    return await http.post(
      Uri.parse('$baseUrl/prashant'),
      body: {"name": "$name", "avatar": "$url"},
    );
  }

  static updateTask({
    required String? id,
    required String? name,
    required String? url,
  }) async {
    return await http.put(
      Uri.parse('$baseUrl/prashant/$id'),
      body: {"name": "$name", "avatar": "$url"},
    );
  }

  static deleteTask({required String? id}) async {
    return await http.delete(
      Uri.parse('$baseUrl/prashant/$id'),
    );
  }
}
