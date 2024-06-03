import 'package:flutter/material.dart';

InputField({
  required double width,
  required TextEditingController controller,
  required String hintText,
  bool isObscure = false, required InputDecoration decoration,
}) {
  return Container(
    width: width * 0.8,
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Ajout de bordures arrondies
      border: Border.all(color: Colors.grey), // Ajout d'une bordure grise
    ),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 2, 2, 2),
          fontSize: 22,
        ),
        hintText: hintText,
        border: InputBorder.none, // Suppression de la bordure par défaut
      ),
      obscureText: isObscure,
    ),
  );
}
