import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatelessWidget {
  final double total;

  PaymentPage({required this.total});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '\$',
      customPattern: '\u00A4#,##0.00',
    );

    void _showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pedido realizado'),
            content: const Text('Su pedido se ha realizado correctamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pop(); 
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total a pagar:',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 16),
            Text(
              currencyFormat.format(total),
              style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: const Text('Realizar pedido con pago en efectivo'),
            ),
          ],
        ),
      ),
    );
  }
}
