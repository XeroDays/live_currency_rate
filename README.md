
This app is used to Convert amount of transactions from one currency to another.

## Features

- 

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
