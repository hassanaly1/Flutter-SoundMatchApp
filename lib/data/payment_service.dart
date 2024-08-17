import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sound_app/helper/colors.dart';

class StripeService {
  StripeService._(); // Private Constructor

  static final StripeService instance = StripeService._(); // Private Instance

  Future<void> makePayment({required String paymentIntentClientSecret}) async {
    try {
      // String? paymentIntentClientSecret = await _createPaymentIntent(
      //   amount: 1099,
      //   currency: 'usd',
      // );
      // Use paymentIntent (client_secret) for further payment processing
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            allowsDelayedPaymentMethods: true,
            style: ThemeMode.dark,
            merchantDisplayName: 'Progziel Inc.',
            appearance: const PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(
                background: Colors.white,
                primary: MyColorHelper.primaryColor,
              ),
              primaryButton: PaymentSheetPrimaryButtonAppearance(
                colors: PaymentSheetPrimaryButtonTheme(
                    dark: PaymentSheetPrimaryButtonThemeColors(
                  background: MyColorHelper.primaryColor,
                  text: Colors.white,
                )),
              ),
            )),
      );
      _processPayment();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Future<String> _createPaymentIntent({
  //   required int amount,
  //   required String currency,
  // }) async {
  //   try {
  //     Map<String, dynamic> data = {
  //       'amount': _calculateAmountInCents(amount: amount),
  //       'currency': currency,
  //     };
  //     final response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       body: data,
  //       headers: {
  //         'Authorization': 'Bearer $STRIPE_SECRET_KEY',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       final responseBody = jsonDecode(response.body);
  //       debugPrint(responseBody.toString());
  //       var clientSecret = responseBody['client_secret'];
  //       return clientSecret;
  //     } else {
  //       throw Exception('Failed to Create Payment Intent');
  //     }
  //   } catch (e) {
  //     throw Exception('Error $e');
  //   }
  // }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  String _calculateAmountInCents({required int amount}) {
    final calculatedAmountInCents = amount * 100;
    return calculatedAmountInCents.toString();
  }
}
