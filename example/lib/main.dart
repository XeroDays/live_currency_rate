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
      appBar: AppBar(title: const Text("Live Currency App Demo")),
      body: InkWell(
        onTap: () async {
          setState(() {
            isLoading = true;
          });
          CurrencyRate rate =
              await LiveCurrencyRate.convertCurrency("USD", "PKR", 1);

          setState(() {
            rates = "1 USD  =  ${rate.result} PKR";
            isLoading = false;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: size.width,
                child: const Text(
                  "USD to PKR",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22),
                )),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      const Text(
                        "Real-Time Current Rate",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        rates,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
