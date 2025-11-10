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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    
                    // Logo
                    Center(
                      child: Image.asset(
                        '../assets/logoPET.png',
                        width: 250,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Texto de boas-vindas
                    const Text(
                      'Bem vindo!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Texto "Profissional" na mesma cor do "Selecione seu perfil"
                    const Text(
                      'Profissional!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),

                    const Spacer(),

                    const SizedBox(height: 20),

                    Column(
                      children: [
                        // Campo de texto para o código (mais compacto)
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.50,
                            child: TextField(
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Botão Entrar (mesmo tamanho do main.dart)
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    buttonColor,
                                    buttonColor.withOpacity(0.85),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: buttonColor.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 0,
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
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),
                  ],
                ),
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