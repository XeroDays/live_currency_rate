import 'package:flutter/material.dart';
import 'package:live_currency_rate/live_currency_rate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Live Currency App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home();

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String rates = "Click to get Rates";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Live Currency App Demo")),
      body: InkWell(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          CurrencyRate rate =
              await LiveCurrencyRate.convertCurrency("USD", "PKR", 1);

          setState(() {
            rates = rate.result.toString();
            isLoading = false;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: size.width,
                child: Text(
                  "USD to PKR",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                )),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    child: Text(
                      "Rates  : " + rates,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
