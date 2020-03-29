import 'dart:convert';
import 'dart:io';

import 'package:unitconverter/unit.dart';

class CurrencyConverter {
  final httpClient = HttpClient();
  final url = 'api.exchangeratesapi.io';

  Future<List<Unit>> getCurrencies() async {
    List<Unit> units = [];

    final uri = Uri.https(url, '/latest', {});

    final httpsRequest = await httpClient.getUrl(uri);
    final httpResponse = await httpsRequest.close();
    if (httpResponse.statusCode != HttpStatus.ok) {
      return null;
    }

    final responseBody = await httpResponse.transform(utf8.decoder).join();
    final jsonResponse = json.decode(responseBody);

    for (String currency in jsonResponse['rates'].keys) {
      units.add(Unit(
        name: currency,
        conversion: jsonResponse['rates'][currency],
      ));
    }

    return units;
  }
}
