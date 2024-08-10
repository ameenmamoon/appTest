import 'package:flutter/material.dart';
import 'package:supermarket/widgets/payment_methods.dart';
import 'hyper_pay_service.dart';
import 'hyper_pay_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  String? _selectedPaymentType;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select Payment Method'),
        ),
        body: Container(),
      ),
    );
  }

  Map<String, String> _getAdditionalData(String paymentType) {
    switch (paymentType) {
      case 'PA':
        return {
          'cardNumber': '4111111111111111',
          'holderName': 'Test Name',
          'month': '01',
          'year': '2025',
          'cvv': '123',
        };
      case 'AL':
        return {
          'alternativeMethod': 'PayPal', // مثال: استخدم طريقة دفع بديلة
        };
      default:
        return {};
    }
  }
}
