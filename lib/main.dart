import 'package:flutter/material.dart';
import 'professional_login_screen.dart';
import 'patient_login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Saúde Digital',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4FC3F7);
    const Color buttonColor = Color(0xFF4DD0E1);
    const Color textColor = Color(0xFF37474F);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Elementos gráficos de círculo no fundo (canto superior esquerdo)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: 20,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Conteúdo principal centralizado
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Texto de boas-vindas
                    const Text(
                      'Bem vindo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selecione seu perfil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Logo
                    Center(
                      child: Image.asset(
                        '../assets/logoPET.png',
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Botão Profissional
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: buttonColor.withOpacity(0.4),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProfessionalLoginScreen()),
                        );
                      },
                      child: const Text(
                        'Profissional',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Botão Paciente
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: buttonColor.withOpacity(0.4),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PatientSelectionScreen()),
                        );
                      },
                      child: const Text(
                        'Paciente',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}