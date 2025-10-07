import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CpfInputScreen extends StatefulWidget {
  const CpfInputScreen({super.key});

  @override
  State<CpfInputScreen> createState() => _CpfInputScreenState();
}

class _CpfInputScreenState extends State<CpfInputScreen> {
  // Controlador para o campo de texto do CPF
  final TextEditingController _cpfController = TextEditingController();

  // Máscara para formatar o CPF automaticamente
  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color vibrantBlue = Color(0xFF007BFF);
    const Color lightBlueCircle = Color(0xFF40A9FF);
    const Color darkBlueBanner = Color(0xFF001F3F);

    return Scaffold(
      backgroundColor: vibrantBlue,
      body: Stack(
        children: [
          // Círculo decorativos no fundo
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: lightBlueCircle.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: lightBlueCircle.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Banner superior
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: darkBlueBanner,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: const Text(
                      'Digite o CPF do Paciente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Input do CPF
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CPF:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _cpfController,
                          inputFormatters: [_cpfMaskFormatter],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                          decoration: InputDecoration(
                            hintText: '000.000.000-00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: vibrantBlue, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botões de ação
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Colocar aqui lógica para CPF
                          print('CPF confirmado: ${_cpfMaskFormatter.getMaskedText()}');
                        },
                        child: const Text(
                          'Confirmar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          // Colocar aqui lógica para registro
                          print('Navegando para tela de registro...');
                        },
                        child: const Text(
                          'Registrar novo paciente.',
                          style: TextStyle(fontSize: 16),
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
              icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 50),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}