// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LiveCurrencyRate {
  /// Convert Currency
  /// currentCurrency: Currency Code you want to transfer from : USD
  /// toCurrency: Currency Code you want to transfer to : CAD
  /// price: Amount of currency you want to calucalte Forexample : 1
  static Future<CurrencyRate> convertCurrency(
      String currentCurrency, String toCurrency, double price) async {
    final uri = Uri.parse(
        'https://api.softasium.com/Currency/$currentCurrency/$toCurrency/$price');
    final headers = {
      "Authorization": "iamsyedidrees",
      "Content-Lenght": "0",
      "Content-Type": "text/html",
    };
    // Map<String, dynamic> body = {'id': 21, 'name': 'bob'};
    // String jsonBody = json.encode(body);

    try {
      http.Response response = await http
          .post(
        uri,
        headers: headers,
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response("", 300);
        },
      );

      int statusCode = response.statusCode;
      String responseBody = response.body;
      if (statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(responseBody.toString());
        return CurrencyRate.fromSnapshot(data);
      } else if (statusCode == 300) {
        return CurrencyRate(
            message: "No Internet connected, or Weak Internet : $statusCode",
            status: false,
            result: 0);
      } else {
        return CurrencyRate(
            message: "Not Authorized. Return with Reponse code : $statusCode",
            status: false,
            result: 0);
      }
    } catch (e) {
      return CurrencyRate(
          message:
              "Error  :  Failed hitting api, Unable to connect to the server. or Server not available/active. Please Try again later!",
          status: false,
          result: 0);
    }
  }
}

class CurrencyRate {
  late String message;
  late bool status;
  late double result;
  CurrencyRate({
    required this.message,
    required this.status,
    required this.result,
  });

  CurrencyRate.fromSnapshot(Map<String, dynamic> map) {
    message = map["message"];
    status = map["status"];
    result = map["result"];
  }
}
