import 'package:supermarket/configs/application.dart';
import 'package:supermarket/utils/translate.dart';
import 'package:flutter/material.dart';
import 'package:supermarket/models/model.dart';
import 'package:supermarket/widgets/app_placeholder.dart';

class AppOrderItem extends StatelessWidget {
  final OrderModel? order;
  final VoidCallback? onPressed;

  const AppOrderItem({
    Key? key,
    this.order,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (order != null) {
      return InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order!.orderId.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order!.total} ر.س',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text(
                  //   order!.date ?? '',
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                  const SizedBox(height: 4),
                  Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 1,
                            color: order!.status == OrderStatus.waiting
                                ? Colors.yellow
                                : order!.status == OrderStatus.available
                                    ? Colors.orange
                                    : order!.status ==
                                            OrderStatus.partialAvailable
                                        ? Colors.orangeAccent
                                        : order!.status ==
                                                OrderStatus.notAvailable
                                            ? Colors.red
                                            : order!.status ==
                                                    OrderStatus.toDelivery
                                                ? Colors.blue
                                                : Colors.green,
                          ),
                        ),
                        child: Text(
                          Translate.of(context).translate(order!.status.name),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: order!.status == OrderStatus.waiting
                                      ? Colors.yellow
                                      : order!.status == OrderStatus.available
                                          ? Colors.orange
                                          : order!.status ==
                                                  OrderStatus.partialAvailable
                                              ? Colors.orangeAccent
                                              : order!.status ==
                                                      OrderStatus.notAvailable
                                                  ? Colors.red
                                                  : order!.status ==
                                                          OrderStatus.toDelivery
                                                      ? Colors.blue
                                                      : Colors.green),
                        ),
                      ),
                    ],
                  ),
                  // if (item!.status == OrderStatus.order)
                  //   Text(
                  //     Translate.of(context).translate('incomplete_payment'),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyMedium!
                  //         .copyWith(color: Colors.red),
                  //   ),
                  // if (item!.status != OrderStatus.order)
                  //   Text(
                  //     item!.status.name,
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .bodyMedium!
                  //         .copyWith(color: item!.statusColor),
                  //   ),
                ],
              ),
              const SizedBox(height: 8),
              // const Divider(),
            ],
          ),
        ),
      );
    }

    return AppPlaceholder(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        // decoration: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       width: 1,
        //       color: Theme.of(context).dividerColor,
        //     ),
        //   ),
        // ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 150,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
