import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
 final TextEditingController _usernameController = TextEditingController();
 final TextEditingController _instagramController = TextEditingController();
 final TextEditingController _facebookController = TextEditingController();
 final TextEditingController _descriptionController = TextEditingController();

  // Placeholder image URL (you can replace this with actual image data)
  final String _selectedImage = 'https://via.placeholder.com/150';


  void _selectImage() {
    //BORREN LOS COMENTARIOS CUANDO YA NO SEAN NECESARIOS
    // Implement image picker logic here
    // For example, use image_picker package to select an image from the device
    // Update _selectedImage with the selected image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
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
                  const SizedBox(height: 8),
                  const Text('Cambiar foto'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nombre Usuario'),
            ),
            TextFormField(
              controller: _instagramController,
              decoration: const InputDecoration(labelText: 'Instagram'),
            ),
            TextFormField(
              controller: _facebookController,
              decoration: const InputDecoration(labelText: 'Facebook'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción corta'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Implement logic to save profile data
                // You can access the entered values using _usernameController.text, etc.
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}

