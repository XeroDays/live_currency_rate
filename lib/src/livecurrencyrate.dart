// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


class LiveCurrencyRate {
  static const String _baseUrl = 'https://api.softasium.com/Currency';

  static bool _healthCheck = false;

  /// Convert Currency
  /// currentCurrency: Currency Code you want to transfer from : USD
  /// toCurrency: Currency Code you want to transfer to : CAD
  /// price: Amount of currency you want to calucalte Forexample : 1
  static Future<CurrencyRate> convertCurrency(
    
      String currentCurrency, String toCurrency, double price,
      {int? timeOutSeconds}) async {
        HttpOverrides.global = MyHttpOverrides();
    final uri = Uri.parse('$_baseUrl/$currentCurrency/$toCurrency/$price');
    final headers = {
      "Authorization": "iamsyedidrees",
      "Accept": "*/*",
    };

    try {
      if (!_healthCheck) {
        http.Response statusHealthResponse = await http.post(
          Uri.parse('$_baseUrl/health'),
          headers: headers,
        );
        if (statusHealthResponse.statusCode == 200) {
          _healthCheck = true;
        }
      }

      //if timeout is not null then add timeout else without timeout post request
      http.Response response = timeOutSeconds != null
          ? await http
              .post(
              uri,
              headers: headers,
            )
              .timeout(
              Duration(seconds: timeOutSeconds),
              onTimeout: () {
                return http.Response("", 300);
              },
            )
          : await http.post(
              uri,
              headers: headers,
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
      print("Error : $e"); 
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
