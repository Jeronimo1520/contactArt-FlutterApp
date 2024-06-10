import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final double total;

  PaymentPage({required this.total});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _isCardInfoValid() {
    return _cardNumberController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty &&
        _cvvController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'es_ES',
      symbol: '\$',
      customPattern: '\u00A4#,##0.00',
    );

    void _showSuccessDialog(BuildContext context) {
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
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.of(context).pop(); // Vuelve a la página anterior (CartPage)
                },
              ),
            ],
          );
        },
      );
    }

    void _showOrderConfirmationDialog(BuildContext context) {
      if (!_isCardInfoValid()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor complete todos los campos de la tarjeta')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar pedido'),
            content: const Text('¿Está seguro de que desea realizar el pedido?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
              ),
              TextButton(
                child: const Text('Confirmar', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo de confirmación
                  _showSuccessDialog(context); // Muestra el diálogo de éxito
                },
              ),
            ],
          );
        },
      );
    }

    void _showCancelConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Cancelar pedido'),
            content: const Text('¿Está seguro de que no desea realizar el pedido?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                },
              ),
              TextButton(
                child: const Text('Sí', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.of(context).pop(); // Vuelve a la página anterior (CartPage)
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total a pagar:',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 16),
                Text(
                  currencyFormat.format(widget.total),
                  style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.green),
                ),
                const SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<String>(
                      title: const Text('Pago en efectivo'),
                      value: 'efectivo',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Pago con tarjeta (datáfono)'),
                      value: 'tarjeta',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ],
                ),
                Visibility(
                  visible: _selectedPaymentMethod == 'tarjeta',
                  child: Column(
                    children: [
                      TextField(
                        controller: _cardNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Número de tarjeta',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _expiryDateController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha de vencimiento (MM/AA)',
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                        ),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedPaymentMethod == null
                      ? null
                      : () {
                          _showOrderConfirmationDialog(context);
                        },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Cambia el color del botón a verde
                  ),
                  child: const Text(
                    'Realizar pedido',
                    style: TextStyle(color: Colors.white), // Cambia el color del texto a blanco
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _showCancelConfirmationDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Cambia el color del botón a rojo
                  ),
                  child: const Text(
                    'No realizar pedido',
                    style: TextStyle(color: Colors.white), // Cambia el color del texto a blanco
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


