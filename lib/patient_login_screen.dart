import 'package:flutter/material.dart';
import 'patient_cpf_input_screen.dart';

// Gerenciar a seleção principal
enum ProfileType { paciente, parente }

// Gerenciar o grau de parentesco
enum Relationship { mae, pai, irmao, conjuge, outro }

class PatientSelectionScreen extends StatefulWidget {
  const PatientSelectionScreen({super.key});

  @override
  State<PatientSelectionScreen> createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  // Variável para controlar a seleção entre "Paciente" e "Parente"
  ProfileType? _selectedProfile;

  // Variável para controlar qual parente foi selecionado
  Relationship? _selectedRelationship;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF4FC3F7);
    const Color textColor = Color(0xFF37474F);
    const Color accentBlue = Color(0xFF81D4FA);
    const Color buttonColor = Color(0xFF4DD0E1);

    bool isParenteSelected = _selectedProfile == ProfileType.parente;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: <Widget>[
          // Elementos gráficos de círculo no fundo
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
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        
                        // Logo
                        Center(
                          child: Image.asset(
                            '../assets/logoPET.png',
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 15),

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
                        const Text(
                          'Selecione seu perfil',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: textColor,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Cards de seleção "Paciente" e "Parente"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Card Paciente
                            Expanded(
                              child: _buildProfileCard(
                                icon: Icons.person,
                                label: 'Paciente',
                                isSelected: _selectedProfile == ProfileType.paciente,
                                onTap: () {
                                  setState(() {
                                    _selectedProfile = ProfileType.paciente;
                                  });
                                },
                                textColor: textColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Card Parente
                            Expanded(
                              child: _buildProfileCard(
                                icon: Icons.people,
                                label: 'Parente',
                                isSelected: _selectedProfile == ProfileType.parente,
                                onTap: () {
                                  setState(() {
                                    _selectedProfile = ProfileType.parente;
                                  });
                                },
                                textColor: textColor,
                              ),
                            ),
                          ],
                        ),

                        // Seção de parentesco (aparece só quando parente é selecionado)
                        if (isParenteSelected) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Selecione o grau de parentesco',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Opções de parentesco em duas colunas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildRelationshipCard('Mãe do paciente', Relationship.mae, textColor),
                                    const SizedBox(height: 12),
                                    _buildRelationshipCard('Irmão(a) do paciente', Relationship.irmao, textColor),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildRelationshipCard('Pai do paciente', Relationship.pai, textColor),
                                    const SizedBox(height: 12),
                                    _buildRelationshipCard('Cônjuge do paciente', Relationship.conjuge, textColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 30),

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
                                  // Lógica do botão ENTRAR, apenas troca de tela por enquanto
                                  print('Perfil selecionado: $_selectedProfile');
                                  if(isParenteSelected) {
                                    print('Parentesco: $_selectedRelationship');
                                  }
                                  // Navega para a próxima tela
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

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botão de voltar (fixo, não rola com o conteúdo)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: IconButton(
                icon: Icon(Icons.arrow_circle_left_rounded, color: primaryColor, size: 50),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar o card de perfil
  Widget _buildProfileCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4DD0E1) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0xFF4DD0E1).withOpacity(0.2) : Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? const Color(0xFF4DD0E1) : Colors.grey.shade600,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFF4DD0E1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar os cards de parentesco
  Widget _buildRelationshipCard(String title, Relationship relationshipValue, Color textColor) {
    bool isSelected = _selectedRelationship == relationshipValue;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRelationship = relationshipValue;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF4DD0E1) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 3,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Row(
          children: [
            Radio<Relationship>(
              value: relationshipValue,
              groupValue: _selectedRelationship,
              onChanged: (Relationship? value) {
                setState(() {
                  _selectedRelationship = value;
                });
              },
              activeColor: const Color(0xFF4DD0E1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}