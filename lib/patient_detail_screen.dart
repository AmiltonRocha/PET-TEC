import 'package:flutter/material.dart';
import 'professional_patient_form_screen.dart'; 

class PatientDetailScreen extends StatelessWidget {
  final String cpf;

  const PatientDetailScreen({
    super.key,
    required this.cpf,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF007BFF);
    const Color lightBlue = Color(0xFF40A9FF);
    const Color backgroundColor = Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        children: [
          _buildHeader(primaryBlue, lightBlue, context),
          Expanded(
            child: Container(
              color: backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Passa o 'context' e o 'cpf' para a seção de botões
                    _buildButtonsSection(context, cpf), 
                    _buildAnnotationsSection(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryBlue, Color lightBlue, BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        color: primaryBlue,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Círculos decorativos
            Positioned(
              top: -40,
              left: -40,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Botão de voltar
            Positioned(
              top: 0,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Conteúdo do cabeçalho
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE0E0E0),
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Sr. João da Silva e Souza', // Aqui tá estático
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Risco: Médio', // Aqui tá estático
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonsSection(BuildContext context, String cpf) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSmallButton(
                  'Visualizar Dados',
                  () {
                    print('Visualizando dados...');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSmallButton(
                  'Atualiza Dados',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientFormScreen(initialCpf: cpf),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLargeButton(
            'Cadastrar Saída',
            () {
              print('Cadastrando saída...');
            },
            isPrimary: true,
          ),
          const SizedBox(height: 12),
          _buildLargeButton(
            'LEITO A34',
            () {
              print('Abrindo detalhes do leito...');
            },
          ),
        ],
      ),
    );
  }

  // Widget para a seção de anotações
  Widget _buildAnnotationsSection(BuildContext context) {
    const Color textColor = Color(0xFF333333);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Anotações',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          // Passa o 'context' para o card de informações
          _buildInfoCard(textColor, context),
        ],
      ),
    );
  }

  Widget _buildSmallButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFB2EBF2),
        foregroundColor: const Color(0xFF00796B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLargeButton(String text, VoidCallback onPressed,
      {bool isPrimary = false}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF80DEEA) : const Color(0xFFB2EBF2),
        foregroundColor: isPrimary ? const Color(0xFF006064) : const Color(0xFF00796B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoCard(Color textColor, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informações do Paciente',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              InkWell(
                onTap: () {
                  // Ação para adicionar anotação
                  print('Adicionar nova anotação...');
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.green, size: 28),
                ),
              )
            ],
          ),
          const Divider(height: 24),
          _buildInfoRow('Idade:', '60 Anos'),
          _buildInfoRow('Tipo do AVC:', 'Isquêmico'),
          _buildInfoRow('Data de Entrada:', '12/07/2025'),
          _buildInfoRow('Profissional responsável:', 'Isabel Enfermeira'),
          _buildInfoRow('Familiar responsável:', 'Maria Francisca e Souza'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          Text(value,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }
}