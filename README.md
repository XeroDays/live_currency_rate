
This package is used to convert amount of currency from one currency exchange to another.

You will get live currency Exchange rates.

### Pub Dev Website
https://pub.dev/packages/live_currency_rate

## Gallery

<div style="display:flex">
<code><img width="494" height="699" alt="image" src="https://github.com/user-attachments/assets/753b077e-0a46-41ae-bb0d-36fc7579c5a4" />
</code>  
</div>

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

Available on
-  iOS        : ✅ 
-  Android    : ✅ 
-  Web        : ✅ 
-  Windows    : ✅ 
-  Linux      : ✅ 
-  macOS      : ✅ 

You can use all the currency Codes such as :
- AED
- PKR
- INR
- USD

- And many others
