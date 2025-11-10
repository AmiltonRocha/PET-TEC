import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'patient_family_form.dart'; // Import da sua próxima tela

class FamilyMemberConfirmationScreen extends StatefulWidget {
  final String cpfDoPaciente;
  const FamilyMemberConfirmationScreen({
    super.key,
    required this.cpfDoPaciente,
  });

  @override
  State<FamilyMemberConfirmationScreen> createState() =>
      _FamilyMemberConfirmationScreenState();
}

class _FamilyMemberConfirmationScreenState
    extends State<FamilyMemberConfirmationScreen> {
  // Controlador para o nome do acompanhante
  final _nameController = TextEditingController();

  final _pacienteCpfController = TextEditingController();
  final _pacienteNomeController = TextEditingController();
  final _pacienteNascimentoController = TextEditingController();
  final _pacienteContatoController = TextEditingController();

  final _cpfMaskFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _nascimentoMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final _contatoMaskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    // Pré-preenche o campo CPF com o valor recebido da tela anterior
    _pacienteCpfController.text = _cpfMaskFormatter.maskText(widget.cpfDoPaciente);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pacienteCpfController.dispose();
    _pacienteNomeController.dispose();
    _pacienteNascimentoController.dispose();
    _pacienteContatoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color vibrantBlue = Color(0xFF007BFF);
    const Color lightBlueCircle = Color(0xFF40A9FF);

    return Scaffold(
      backgroundColor: vibrantBlue,
      body: Stack(
        children: [
          // Círculos
          Positioned(
              top: -80,
              left: -80,
              child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      color: lightBlueCircle.withOpacity(0.5),
                      shape: BoxShape.circle))),
          Positioned(
              bottom: -150,
              right: -100,
              child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                      color: lightBlueCircle.withOpacity(0.4),
                      shape: BoxShape.circle))),

          // Conteúdo Principal
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Campo "Digite seu nome"
                  const Text(
                    'Digite seu nome como acompanhante',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Seu nome completo',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Banner "Preencha os dados a seguir"
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: const Center(
                      child: Text(
                        'Preencha os dados do paciente',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextFormField(
                          controller: _pacienteCpfController,
                          label: 'CPF do Paciente',
                          hint: '000.000.000-00',
                          keyboardType: TextInputType.number,
                          inputFormatters: [_cpfMaskFormatter],
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          controller: _pacienteNomeController,
                          label: 'Nome do Paciente',
                          hint: 'Nome completo do paciente',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          controller: _pacienteNascimentoController,
                          label: 'Nascimento do Paciente',
                          hint: 'DD/MM/AAAA',
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [_nascimentoMaskFormatter],
                        ),
                        const SizedBox(height: 12),
                        _buildTextFormField(
                          controller: _pacienteContatoController,
                          label: 'Contato (do Paciente ou Resp.)',
                          hint: '(00) 00000-0000',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_contatoMaskFormatter],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botão Confirmar
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: vibrantBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 16),
                      ),
                      onPressed: () {
                        // Lógica para confirmar os dados
                        print('Nome do familiar: ${_nameController.text}');
                        print(
                            'CPF Paciente: ${_pacienteCpfController.text}');
                        print(
                            'Nome Paciente: ${_pacienteNomeController.text}');

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FamilyFormScreen(
                                  cpf: _pacienteCpfController.text,
                                  name: _nameController.text)),
                        );
                      },
                      child: const Text('Confirmar',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
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
              icon: const Icon(Icons.arrow_circle_left_outlined,
                  color: Colors.white, size: 50),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}