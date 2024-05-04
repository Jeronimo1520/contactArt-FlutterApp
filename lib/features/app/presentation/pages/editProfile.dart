import 'package:contact_art/controllers/UserController.dart';
import 'package:contact_art/global/common/toast.dart';
import 'package:contact_art/models/User.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, this.user, this.userId}) : super(key: key);

 final User? user;
 final String? userId;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
 final TextEditingController _usernameController = TextEditingController();
 final TextEditingController _instagramController = TextEditingController();
 final TextEditingController _facebookController = TextEditingController();
 final TextEditingController _descriptionController = TextEditingController();

 final UserController userController = UserController();

  // Placeholder image URL (you can replace this with actual image data)
  final String _selectedImage = 'https://via.placeholder.com/150';

   @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  void _selectImage() {
    //BORREN LOS COMENTARIOS CUANDO YA NO SEAN NECESARIOS
    // Implement image picker logic here
    // For example, use image_picker package to select an image from the device
    // Update _selectedImage with the selected image URL
  }

  void _loadUserData() {
    _usernameController.text = widget.user?.userName ?? '';
    _instagramController.text = widget.user?.instagramLink! ?? '';
    _facebookController.text = widget.user?.facebookLink! ?? '';
    _descriptionController.text = widget.user?.description! ?? '';
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
              onPressed: _UpdateUser,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _UpdateUser() async{
    try {
      print(widget.user!.id);
      await userController.updateUserData(
        widget.userId,
        _usernameController.text,
        _instagramController.text,
        _facebookController.text,
        _descriptionController.text,
      );
      showToast(message: 'Perfil actualizado correctamente');
    } catch (e) {
      print(e);
      showToast(message: 'Error al actualizar el perfil');
    }

    setState(() {
      Navigator.pop(context);
    });
  }
}

