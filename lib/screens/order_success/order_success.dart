import 'package:flutter/material.dart';
import 'package:supermarket/configs/config.dart';
import 'package:supermarket/utils/utils.dart';
import 'package:supermarket/widgets/widget.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  _OrderSuccessState createState() {
    return _OrderSuccessState();
  }
}

class _OrderSuccessState extends State<OrderSuccess> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On Add More
  void _onBack() {
    Navigator.pop(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('completed'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Translate.of(context).translate('order_send_success'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Translate.of(context).translate(
                          'order_success_message',
                        ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AppButton(
                  Translate.of(context).translate('back_to_home'),
                  mainAxisSize: MainAxisSize.max,
                  onPressed: _onBack,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
