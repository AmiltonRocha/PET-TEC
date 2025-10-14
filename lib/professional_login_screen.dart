import 'package:flutter/material.dart';
import 'professional_cpf_input_screen.dart';

class ProfessionalLoginScreen extends StatefulWidget {
  const ProfessionalLoginScreen({super.key});

  @override
  State<ProfessionalLoginScreen> createState() => _ProfessionalLoginScreenState();
}

class _ProfessionalLoginScreenState extends State<ProfessionalLoginScreen> {
  final TextEditingController _authCodeController = TextEditingController();

  @override
  void dispose() {
    _authCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cores baseadas na sua imagem
    const Color primaryColor = Color(0xFF4FC3F7);
    const Color buttonColor = Color(0xFF4DD0E1);
    const Color textColor = Color(0xFF37474F);
    const Color accentBlue = Color(0xFF81D4FA);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Círculos de fundo
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

          // Conteúdo principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Bloco superior
                  Column(
                    children: [
                      const Text(
                        'Bem vindo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Banner "Profissional"
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: buttonColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Profissional',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Logo
                  Center(
                      child: Image.asset(
                        '../assets/logoPET.png',
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),

                  Column(
                    children: [
                      // Campo de texto para o código
                      TextField(
                        controller: _authCodeController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Código de autorização:',
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 20),

                      // Botão Entrar
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Ação do botão ENTRAR
                          print('Código digitado: ${_authCodeController.text}');
                          /* Ainda tem que colocar a lógica para validar o código, mas sendo honesto não sei se é uma
                             boa ideia o "profissional" ter que colocar o código, ao menos agora */

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CpfInputScreen()),
                          );
                        },
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Botão de voltar
          Positioned(
            bottom: 30,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_circle_left_rounded,
                color: primaryColor,
                size: 50,
              ),
              onPressed: () {
                // Ação para voltar para a tela anterior
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}