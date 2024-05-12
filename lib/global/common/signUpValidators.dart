String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu contraseña';
  } else if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu correo';
  } else if (!value.contains('@')) {
    return 'Por favor, ingresa un correo válido';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu nombre';
  }
  return null;
}

String? validateLastName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu apellido';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu teléfono';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Por favor, ingresa solo números';
  }
  return null;
}

String? validateId(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu Cédula/NIT';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Por favor, ingresa solo números';
  }
  return null;
}
