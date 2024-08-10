import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  final String _merchantId =
      'your-merchant-id'; // استبدل هنا بمعلومات التاجر الخاصة بك
  final String _accessToken =
      'your-access-token'; // استبدل هنا برمز الوصول الخاص بك
  final String _entityId = 'your-entity-id'; // استبدل هنا بمعرف الكيان الخاص بك
  final String _paymentUrl =
      'https://test.oppwa.com/v1/checkouts'; // عنوان API الخاص بـ HyperPay

  Future<String?> createCheckout(
      double amount, String currency, String returnUrl) async {
    final response = await http.post(
      Uri.parse(_paymentUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      },
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'paymentType': 'DB', // نوع الدفع الأساسي
        'entityId': _entityId,
        'returnUrl': returnUrl,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id']; // استرجاع معرّف التحقق
    } else {
      print('Failed to create checkout: ${response.body}');
      return null;
    }
  }

  Future<void> processPayment({
    required String paymentType,
    required String checkoutId,
    required Map<String, String> additionalData,
  }) async {
    final response = await http.post(
      Uri.parse('$_paymentUrl/$checkoutId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken'
      },
      body: jsonEncode({
        'paymentType': paymentType,
        ...additionalData, // إضافة البيانات الإضافية حسب نوع الدفع
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result']['code'] == '000.000.000') {
        print('Payment successful');
      } else {
        print('Payment failed: ${data['result']['description']}');
      }
    } else {
      print('Failed to process payment: ${response.body}');
    }
  }
}
