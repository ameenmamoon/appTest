import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

class PaymentMethods extends StatefulWidget {
  final int orderId;
  final double amount;
  final String unitName;
  const PaymentMethods(
      {super.key,
      required this.orderId,
      required this.amount,
      required this.unitName});

  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  late PaymentConfig paymentConfig;
  @override
  void initState() {
    super.initState();
    paymentConfig = PaymentConfig(
      publishableApiKey: 'pk_test_1GkjbGKHAeoJchRFzpjgaTGyk1Qw14DGMgSAaEMC',
      amount: int.parse('${widget.amount * 100}'), // SAR 257.58
      description: 'order: ${widget.orderId}',
      metadata: {'unitName': ' ${widget.unitName}'},
      applePay: ApplePayConfig(
          merchantId: 'YOUR_MERCHANT_ID',
          label: 'YOUR_STORE_NAME',
          manual: true),
    );
  }

  void onPaymentResult(result) {
    if (result is PaymentResponse) {
      switch (result.status) {
        case PaymentStatus.paid:
          Navigator.pop(context, true);
          break;
        case PaymentStatus.failed:
          Navigator.pop(context, false);
          break;
        case PaymentStatus.initiated:
          // TODO: Handle this case.
          break;
        case PaymentStatus.authorized:
          // TODO: Handle this case.
          break;
        case PaymentStatus.captured:
          // TODO: Handle this case.
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ApplePay(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        ),
        const Text("or"),
        CreditCard(
          config: paymentConfig,
          onPaymentResult: onPaymentResult,
        )
      ],
    );
  }
}
