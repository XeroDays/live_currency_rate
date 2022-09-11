
This package is used to convert amount of currency from one currency exchange to another.

You will get live currency Exchange rates.



## Features

- Get Live Currency Exchange Rates
- Exchange currency ammount from one to another.
- Used to convert In-App-Purchase currency to Defualt currency for Admin Dashboard.

## Getting started


Just copy this library to your file
```dart
import 'package:live_currency_rate/live_currency_rate.dart';
```

and then
Run the following code

## Usage


```dart
 CurrencyRate rate = await LiveCurrencyRate.convertCurrency("USD", "AED", 500);
 print(rate.result);

```

## Additional information

We use https so that it may take some while.
Try using the Async function to get rates

Avalable for
-  iOS        : YES
-  Android    : YES
-  Web        : NO

Working on it.. it doesnt convert becuase we have not Define CORS in the server yet. 
Please wait for further updates. 


You can use all the currency Codes such as :
- AED
- PKR
- INR
- USD

- And many others
