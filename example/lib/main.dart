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
  String rates = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Live Currency App Demo")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: size.width,
              child: const Text(
                "USD to AED",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              )),
          SizedBox(
              width: size.width,
              child: const Text(
                "US Doller to UAE Dirhem",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              )),
          const SizedBox(height: 20),
          isLoading
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    const Text(
                      "Real-Time Current Rate",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      rates,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                CurrencyRate rate =
                    await LiveCurrencyRate.convertCurrency("USD", "AED", 1);

                setState(() {
                  print(rate.message);
                  rates = "1 USD  =  ${rate.result} AED";
                  isLoading = false;
                });
              },
              child: Text("Click to get Rates")),
        ],
      ),
    );
  }
}
