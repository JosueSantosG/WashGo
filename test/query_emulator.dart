import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final query = '''
    query {
      services {
        id
        nombre
        precioPequeno
        precioMediano
        precioGrande
        precioMoto
        precioOwnerPequeno
        precioOwnerMediano
        precioOwnerGrande
        precioOwnerMoto
        precioPendiente
        costo
        activo
      }
    }
  ''';

  final urlStr = 'http://127.0.0.1:9399/v1/projects/washgo-app-8392/locations/us-central1/services/washgo:executeGraphql';
  final url = Uri.parse(urlStr);

  try {
    print('Querying all services...');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-mantle-admin': 'true',
      },
      body: jsonEncode({'query': query}),
    );
    
    print('Status: ${response.statusCode}');
    final parsed = jsonDecode(response.body);
    final encoder = JsonEncoder.withIndent('  ');
    print(encoder.convert(parsed));
  } catch (e) {
    print('Error: $e');
  }
}
