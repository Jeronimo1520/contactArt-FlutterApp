String? validatePrice(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa un número';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Por favor, ingresa solo números';
  }
  return null;
}
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu apellido';
  }
  return null;
}

String? validateDescription(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa tu apellido';
  }
  return null;
}