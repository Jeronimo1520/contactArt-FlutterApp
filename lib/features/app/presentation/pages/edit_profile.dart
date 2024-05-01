import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // Placeholder image URL (you can replace this with actual image data)
  String _selectedImage = 'https://via.placeholder.com/150';

  // Function to handle image selection
  void _selectImage() {
    // Implement image picker logic here
    // For example, use image_picker package to select an image from the device
    // Update _selectedImage with the selected image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Editable fields
            GestureDetector(
              onTap: _selectImage,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_selectedImage),
                  ),
                  SizedBox(height: 8),
                  Text('Cambiar foto'),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre Usuario'),
            ),
            TextFormField(
              controller: _instagramController,
              decoration: InputDecoration(labelText: 'Instagram'),
            ),
            TextFormField(
              controller: _facebookController,
              decoration: InputDecoration(labelText: 'Facebook'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción corta'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Implement logic to save profile data
                // You can access the entered values using _usernameController.text, etc.
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

