import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_project/provider/order.dart' as od;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final od.OrderItem order;

  const OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd-mm-yyyy hh:mm').format(widget.order.dateTime)),
            trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if (_expanded)
          Container(
            height: min(widget.order.products.length * 20.0 + 100, 180),
            child: ListView(
              children: widget.order.products.map((prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(prod.title, 
                  style: const TextStyle( fontSize: 18),),
                  Text('${prod.quantity} x \$${prod.price.toStringAsFixed(2)}',
                   style: const TextStyle(
                    fontSize: 18,
                  ),)
                ],
              )).toList(),
            ),
          )
        ],
      ),
    );
  }
}