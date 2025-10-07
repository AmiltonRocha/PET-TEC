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

    bool isParenteSelected = _selectedProfile == ProfileType.parente;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Texto de boas-vindas
                  const Text(
                    'Bem vindo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Logo
                  Center(
                      child: Image.asset(
                        '../assets/logoPET.png',
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  const SizedBox(height: 40),

                  // Container principal com as opções
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkboxes "Paciente" e "Parente"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildCheckboxRow(
                              label: 'Paciente',
                              isSelected: _selectedProfile == ProfileType.paciente,
                              onTap: () {
                                setState(() {
                                  _selectedProfile = ProfileType.paciente;
                                });
                              },
                            ),
                            buildCheckboxRow(
                              label: 'Parente',
                              isSelected: _selectedProfile == ProfileType.parente,
                              onTap: () {
                                setState(() {
                                  _selectedProfile = ProfileType.parente;
                                });
                              },
                            ),
                          ],
                        ),

                        // Seção de parentesco (aparece só quando parente é selecionado)
                        Visibility(
                          visible: isParenteSelected,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 8.0, left: 12.0),
                                child: Text(
                                  'Selecione o grau de parentesco',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              buildRelationshipCheckbox('Mãe do paciente', Relationship.mae),
                              buildRelationshipCheckbox('Pai do paciente', Relationship.pai),
                              buildRelationshipCheckbox('Irmão(a) do paciente', Relationship.irmao),
                              buildRelationshipCheckbox('Cônjuge do paciente', Relationship.conjuge),
                              buildRelationshipCheckbox('Outro(a)', Relationship.outro),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botão Entrar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    child: const Text('ENTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              icon: const Icon(Icons.arrow_circle_left_rounded, color: primaryColor, size: 50),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para criar a linha de checkbox "Paciente" / "Parente"
  Widget buildCheckboxRow({required String label, required bool isSelected, required VoidCallback onTap}) {
    const Color textColor = Color(0xFF37474F);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (bool? value) => onTap(),
            activeColor: const Color(0xFF4DD0E1),
          ),
          Text(label, style: const TextStyle(fontSize: 16, color: textColor)),
        ],
      ),
    );
  }

  // Widget auxiliar para criar os checkboxes de parentesco
  Widget buildRelationshipCheckbox(String title, Relationship relationshipValue) {
    const Color textColor = Color(0xFF37474F);
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: textColor)),
      value: _selectedRelationship == relationshipValue,
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedRelationship = relationshipValue;
          } else {
            _selectedRelationship = null;
          }
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF4DD0E1),
    );
  }
}