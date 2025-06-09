import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Clase para gestionar el tema visual de la aplicación.
class AppTheme {
  // Hacemos el constructor privado para que nadie pueda instanciar esta clase.
  // Solo queremos acceder a sus propiedades estáticas.
  AppTheme._();

  // Definición de la paleta de colores principal de A.M.I.C.A.N.A.
  // Un azul profesional es una buena opción para una app académica.
  static const Color _primaryColor =
      Color(0xFF0D47A1); // Un azul oscuro y serio
  static const Color _accentColor =
      Color(0xFF4CAF50); // Un verde para acciones positivas

  // ----- TEMA CLARO -----
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: Colors.grey[100], // Un fondo ligeramente gris

    // Estilo de la barra de navegación superior (AppBar)
    appBarTheme: AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white, // Color para el título y los iconos
      elevation: 4.0,
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // Estilo para los botones elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // Estilos de texto por defecto
    textTheme: GoogleFonts.latoTextTheme(
      ThemeData.light().textTheme,
    ).copyWith(
      headlineSmall: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.lato(fontSize: 16),
    ),

    // Colores específicos del esquema de color
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      primary: _primaryColor,
      secondary: _accentColor,
      brightness: Brightness.light,
    ),
  );

  // Podrías definir un tema oscuro en el futuro si lo deseas.
  // static final ThemeData darkTheme = ThemeData(...);
}
