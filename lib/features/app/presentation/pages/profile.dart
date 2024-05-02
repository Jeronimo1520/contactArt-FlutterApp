import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Perfil de Usuario'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(''),
              ),
              SizedBox(height: 16),
              Text(
                'Nombre de Usuario',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Acción al presionar el botón de editar perfil
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // Acción al presionar el botón de configuración
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      // Acción al presionar el botón de favoritos
                    },
                  ),
                ],
              ),
              SizedBox(height: 32),
              Text(
                'Lorem ipsum dolor sit amet leo venenatis consequat mattis nec mon',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(Icons.add),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/addProduct');
                  // Acción al presionar el botón "Añadir producto"
                },
                child: Text('Añadir producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
