import 'package:flutter/material.dart';

class ButtonUtils {
  static Widget buildElevatedButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    Color? buttonColor, // Nuevo parámetro opcional para el color del botón
    Color textColor = Colors.white,
    Color backgroundColor = const Color(0xFF8A47FF), // Color predeterminado
    Color? labelColor,
    Container? child,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ??
            backgroundColor, // Usar el color del botón o el predeterminado
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: 45,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            color: labelColor ?? textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
