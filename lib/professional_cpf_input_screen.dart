import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'patient_detail_screen.dart';
import 'professional_patient_form_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> fetchPatientByCpf(String cpf) async {
  final String cleanCpf = cpf.replaceAll(RegExp(r'[.-]'), '');
  
  final String apiUrl = "https://pet-tec-server.onrender.com/db/forms/getForm/$cleanCpf"; 

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Falha ao verificar paciente: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro de rede: $e');
  }
}

class CpfInputScreen extends StatefulWidget {
  const CpfInputScreen({super.key});

  @override
  State<CpfInputScreen> createState() => _CpfInputScreenState();
}

class _CpfInputScreenState extends State<CpfInputScreen> {
  final TextEditingController _cpfController = TextEditingController();

  bool _isLoading = false;

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
    const Color buttonColor = Color(0xFF4DD0E1);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Círculos decorativos (ajustados para fundo branco)
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: buttonColor.withOpacity(0.3),
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
                color: buttonColor.withOpacity(0.4),
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
                  // Banner superior (mais compacto)
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: buttonColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Text(
                          'Digite o CPF do PacienteLOL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input do CPF (mais compacto)
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                              enabled: !_isLoading,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                              decoration: InputDecoration(
                                hintText: '000.000.000-00',
                                filled: true,
                                fillColor: buttonColor.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(color: buttonColor, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botões de ação (mesmo padrão do professional_login_screen)
                  Column(
                    children: [
                      // Botão Confirmar (mesmo estilo do main.dart)
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
                              onPressed: _isLoading ? null : () async  {
                                final String cpfFormatted = _cpfController.text;
                                final String cpfUnmasked = _cpfMaskFormatter.getUnmaskedText();

                                if (cpfUnmasked.length != 11) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Por favor, digite um CPF completo.')),
                                  );
                                  return;
                                }

                                setState(() { _isLoading = true; });

                                try {
                                  final Map<String, dynamic>? patientData = await fetchPatientByCpf(cpfUnmasked);

                                  if (!mounted) return;

                                  if (patientData != null) {
                                    // Paciente encontrado, patientData contem o JSON
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PatientDetailScreen(cpf: cpfFormatted, patientData: patientData),
                                      ),
                                    );
                                  } else {
                                    // Paciente não encontrado (404)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Paciente não encontrado. Por favor, registre-o.')),
                                    );
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro ao conectar: $e')),
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() { _isLoading = false; });
                                  }
                                }
                              },
                              child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  )
                               : const Text(
                                'Confirmar',
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
                      const SizedBox(height: 16),
                      // Botão Registrar novo paciente (mesmo estilo do main.dart)
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
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
                              onPressed: _isLoading ? null : () {
                                final String cpf = _cpfController.text;
                                
                                print('Navegando para tela de registro com o CPF: $cpf');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientFormScreen(initialCpf: cpf),
                                  ),
                                );
                              },
                              child: const Text(
                                'Registrar novo paciente',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
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
              icon: const Icon(Icons.arrow_circle_left_outlined, color: buttonColor, size: 50),
              onPressed: _isLoading ? null : () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}