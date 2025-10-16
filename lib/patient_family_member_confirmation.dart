import 'package:flutter/material.dart';
import 'patient_family_form.dart';

class FamilyMemberConfirmationScreen extends StatefulWidget {
  const FamilyMemberConfirmationScreen({super.key});

  @override
  State<FamilyMemberConfirmationScreen> createState() =>
      _FamilyMemberConfirmationScreenState();
}

class _FamilyMemberConfirmationScreenState
    extends State<FamilyMemberConfirmationScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
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
                        'Preencha os dados a seguir',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card de informações do paciente
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
                        _buildInfoRow('CPF:', '123.456.789-10'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Nascimento:', '12/03/1965'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Contato:', '(85) 99681-4658'),
                        const SizedBox(height: 12),
                        _buildInfoRow('Nome:', 'José da Silva e Sousa'),
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FamilyFormScreen()),
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

  // Widget auxiliar para criar as linhas de informação
  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}