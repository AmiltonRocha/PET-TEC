import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  final String cpf;
  final Map<String, dynamic> patientData;

  const PatientDetailScreen({
    super.key,
    required this.cpf,
    required this.patientData,
  });

  // Função auxiliar para formatar a data (opcional, mas recomendado)
  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return 'N/A';
    }
    try {
      final DateTime date = DateTime.parse(isoDate);
      // Formata para Dia/Mês/Ano
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      // Se a data não estiver no formato ISO (ex: "weqqqqqq"), retorna o texto original
      return isoDate;
    }
  }

  // Função auxiliar para verificar 'Sim' (considerando boolean ou String)
  bool _isYes(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'sim';
    return false;
  }

  // Função auxiliar para exibir o valor ou 'N/A' se estiver vazio
  String _displayValue(String? value) {
    return (value == null || value.isEmpty) ? 'N/A' : value;
  }


  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF007BFF);
    const Color lightBlue = Color(0xFF40A9FF);
    const Color backgroundColor = Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: primaryBlue,
      body: Column(
        children: [
          _buildHeader(primaryBlue, lightBlue, context, patientData),
          Expanded(
            child: Container(
              color: backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAnnotationsSection(context, patientData),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primaryBlue, Color lightBlue, BuildContext context, Map<String, dynamic> patientData) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryBlue.withOpacity(0.15),
        ),
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
                  Text(
                    patientData['nome']?.toString() ?? 'Paciente', // Chave do JSON
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Faixa Etária: ${patientData['faixa_etaria']?.toString() ?? 'N/A'}', // Chave do JSON
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

  // Widget para a seção de anotações
  Widget _buildAnnotationsSection(BuildContext context, Map<String, dynamic> patientData) {
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
          _buildInfoCard(textColor, context, patientData),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Color textColor, BuildContext context, Map<String, dynamic> patientData) {
    // Variáveis para controlar a visibilidade dos campos condicionais
    final bool altaComMedicamento = _isYes(patientData['alta_medicamento']);
    final bool usaMedicamentoDiario = _isYes(patientData['medicamento_uso_diario']);

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
          // Usando as chaves do JSON
          _buildInfoRow('Sexo:', _displayValue(patientData['sexo']?.toString())),
          _buildInfoRow('Início Sintomas:', _formatDate(patientData['data_inicio_sintomas']?.toString())),
          _buildInfoRow('Chegada Hospital:', _displayValue(patientData['tempo_chegada_hospital']?.toString())),
          _buildInfoRow('Sequelas:', _displayValue(patientData['sequelas']?.toString())),
          // Campo novo
          _buildInfoRow('Outras Sequelas:', _displayValue(patientData['sequelas_outras']?.toString())),
          _buildInfoRow('Comorbidades:', _displayValue(patientData['comorbidades']?.toString())),
          _buildInfoRow('Hist. Familiar:', _displayValue(patientData['historico_familiar']?.toString())),
          _buildInfoRow('Familiar (Parentesco):', _displayValue(patientData['grau_parentesco']?.toString())),
          
          // --- Novos campos do formulário ---
          const Divider(height: 24),
          
          _buildInfoRow(
            'Alta com medicação?', 
            _displayValue(patientData['alta_medicamento']?.toString())
          ),
          // Mostra "Qual?" apenas se a resposta for Sim
          if (altaComMedicamento)
            _buildInfoRow(
              'Qual medicação (alta)?', 
              _displayValue(patientData['alta_medicamento_qual']?.toString())
            ),
          
          const SizedBox(height: 8), // Espaçador

          _buildInfoRow(
            'Usa medicação diária?', 
            _displayValue(patientData['medicamento_uso_diario']?.toString())
          ),
          // Mostra "Qual?" apenas se a resposta for Sim
          if (usaMedicamentoDiario)
            _buildInfoRow(
              'Qual medicação (diária)?', 
              _displayValue(patientData['medicamento_uso_diario_qual']?.toString())
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinha no topo se o valor quebrar linha
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
          const SizedBox(width: 10), // Espaço entre label e valor
          Expanded( // Permite que o valor quebre a linha se for muito longo
            child: Text(
              value,
              textAlign: TextAlign.end, // Alinha o valor à direita
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}