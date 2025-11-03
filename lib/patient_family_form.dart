// Import Flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Import de outras paginas
import 'patient_cpf_input_screen.dart';
import "patient_family_member_confirmation.dart";

import 'dart:convert';
import 'package:http/http.dart' as http;

// Enums para melhorar a legibilidade
enum Sexo { feminino, masculino }
enum RespostaSimNao { sim, nao }

class FamilyFormScreen extends StatefulWidget {
  final String cpf;
  final String name;
  const FamilyFormScreen({
    super.key,
    required this.cpf,
    required this.name});

  @override
  State<FamilyFormScreen> createState() => _FamilyFormScreenState();
}

class _FamilyFormScreenState extends State<FamilyFormScreen> {
  final _inicioSintomasController = TextEditingController();
  final _tempoChegadaHospitalController = TextEditingController();
  final _sequelasOutrasController = TextEditingController();
  final _altaMedicamentoController = TextEditingController();
  final _usoDiarioMedicamentoController = TextEditingController();

  Sexo? _sexo;
  String? _faixaEtaria;
  String? _grauParentesco;
  RespostaSimNao? _altaPrescritoMedicamento;
  RespostaSimNao? _medicamentoUsoDiario;

  bool get _isCuidadorExterno => _grauParentesco == 'Cuidador externo';

  // Checkboxes
  final Map<String, bool> _sequelas = {
    'Disfagia': false, 'Parestesia parcial': false, 'Parestesia total': false,
    'Paralisia parcial': false, 'Paralisia total': false, 'Perda da memória': false,
    'Perda da visão': false, 'Afasia': false,
  };

  final Map<String, bool> _comorbidadesPaciente = {
    'Diabetes': false, 'Hipertensão': false, 'Sedentarismo': false, 'Obesidade': false,
    'Infarto agudo do miocárdio': false, 'Insuficiência cardíaca': false,
    'Etilista': false, 'Fumante': false,
  };

  final Map<String, bool> _historicoFamiliar = {
    'Diabetes': false, 'Hipertensão': false, 'Sedentarismo': false, 'Obesidade': false,
    'Infarto agudo do miocárdio': false, 'Insuficiência cardíaca': false,
    'Etilista': false, 'Fumante': false, 'AVC': false,
  };

  // Parte da data
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _inicioSintomasController.dispose();
    _tempoChegadaHospitalController.dispose();
    _sequelasOutrasController.dispose();
    _altaMedicamentoController.dispose();
    _usoDiarioMedicamentoController.dispose();
    super.dispose();
  }

  String _getCheckedItems(Map<String, bool> map) {
    return map.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .join(', ');
  }

  String? _formatApiDate(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      final date = DateFormat('dd/MM/yyyy').parse(dateString);
      return date.toIso8601String();
    } catch (e) {
      return null;
    }
  }

  bool _isLoading = false; // n chamar submitForm enquanto ele esta ativo

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true;
    });

    String sequelasCombinadas = _getCheckedItems(_sequelas);
    if (_sequelasOutrasController.text.isNotEmpty) {
      if (sequelasCombinadas.isNotEmpty) {
        sequelasCombinadas += ', ${_sequelasOutrasController.text}';
      } else {
        sequelasCombinadas = _sequelasOutrasController.text;
      }
    }

    final Map<String, dynamic> formData = {
      "nome": widget.name,
      "cpf": widget.cpf,
      "sexo": _sexo?.name,
      "faixa_etaria": _faixaEtaria,
      "grau_parentesco": _grauParentesco,
      "data_inicio_sintomas": _formatApiDate(_inicioSintomasController.text),
      "tempo_chegada_hospital": _tempoChegadaHospitalController.text,
      "sequelas": sequelasCombinadas,
      "alta_medicamento": _altaPrescritoMedicamento == RespostaSimNao.sim,
      "alta_medicamento_qual": _altaMedicamentoController.text,
    };
    if (!_isCuidadorExterno) {
      formData.addAll({
        "comorbidades": _getCheckedItems(_comorbidadesPaciente),
        "historico_familiar": _getCheckedItems(_historicoFamiliar),
        "medicamento_uso_diario": _medicamentoUsoDiario == RespostaSimNao.sim,
        "medicamento_uso_diario_qual": _usoDiarioMedicamentoController.text,
      });
    }

    const String apiUrl = 'http://localhost:3050/db/forms/postForm';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formData),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Formulário salvo com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${errorData['message']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de conexão: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color vibrantBlue = Color(0xFF007BFF);
    const Color lightBlueCircle = Color(0xFF40A9FF);

    return Scaffold(
      backgroundColor: vibrantBlue,
      body: Stack(
        children: [
          // Circulos
          Positioned(top: -80, left: -80, child: Container(width: 250, height: 250, decoration: BoxDecoration(color: lightBlueCircle.withOpacity(0.5), shape: BoxShape.circle))),
          Positioned(bottom: -150, right: -100, child: Container(width: 350, height: 350, decoration: BoxDecoration(color: lightBlueCircle.withOpacity(0.4), shape: BoxShape.circle))),
          
          SafeArea(
            child: Column(
              children: [
                // Banner superior
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
                    child: const Center(child: Text('Preencha os dados a seguir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87))),
                  ),
                ),
                // Formulário
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Identificação do Paciente'),
                          _buildRadioGroup<Sexo>(
                            options: {'Feminino': Sexo.feminino, 'Masculino': Sexo.masculino},
                            groupValue: _sexo,
                            onChanged: (value) => setState(() => _sexo = value),
                          ),
                          _buildDropdown('Faixa etária:', [ 'até 18 anos', '19–25 anos', '26–35 anos', '36–45 anos', '46–55 anos', '56–65 anos', 'acima de 65 anos'], _faixaEtaria, (val) => setState(() => _faixaEtaria = val)),
                          _buildDropdown('Grau de parentesco:', ['Mãe', 'Pai', 'Irmão(ã)', 'Cônjuge', 'Filho(a)', 'Outro', 'Cuidador externo'], _grauParentesco, (val) => setState(() => _grauParentesco = val)),
                          
                          _buildSectionTitle('Dados Clínicos'),
                          _buildDateField('Data de início dos sintomas:', _inicioSintomasController),
                          _buildTextField('Tempo até chegada ao hospital:', _tempoChegadaHospitalController),

                          _buildSectionTitle('Evolução e Desfecho'),
                          _buildCheckboxGroup('Sequelas:', _sequelas),
                          _buildTextField('Outras sequelas:', _sequelasOutrasController),
                          _buildRadioGroup<RespostaSimNao>(title: 'Se recebeu alta, foi prescrito algum medicamento?', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _altaPrescritoMedicamento, onChanged: (val) => setState(() => _altaPrescritoMedicamento = val)),
                          if (_altaPrescritoMedicamento == RespostaSimNao.sim) _buildTextField('Se sim, qual?', _altaMedicamentoController),

                          Visibility(
                            visible: !_isCuidadorExterno,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Histórico e Fatores de Risco'),
                                _buildCheckboxGroup('Comorbidades/Fatores de risco do paciente:', _comorbidadesPaciente),
                                _buildCheckboxGroup('Histórico familiar:', _historicoFamiliar),
                                _buildRadioGroup<RespostaSimNao>(title: 'Uso de medicamento diário:', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _medicamentoUsoDiario, onChanged: (val) => setState(() => _medicamentoUsoDiario = val)),
                                if (_medicamentoUsoDiario == RespostaSimNao.sim) _buildTextField('Se sim, qual?', _usoDiarioMedicamentoController),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botão de confirmar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, foregroundColor: vibrantBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    ),
                    onPressed: _isLoading ? null : _submitForm,
                    child: const Text('Confirmar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          // Botão de voltar
          Positioned(
            bottom: 30, left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white, size: 50),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF007BFF))),
  );

  Widget _buildRadioGroup<T>({String? title, required Map<String, T> options, T? groupValue, required ValueChanged<T?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
        Wrap(
          spacing: 8.0,
          runSpacing: 0.0,
          children: options.entries.map((entry) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(value: entry.value, groupValue: groupValue, onChanged: onChanged, activeColor: const Color(0xFF007BFF)),
              Text(entry.key),
            ],
          )).toList(),
        ),
      ],
    );
  }
  
  Widget _buildCheckboxGroup(String title, Map<String, bool> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
        Wrap(
          spacing: 8.0,
          runSpacing: 0.0,
          children: options.keys.map((key) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(value: options[key], onChanged: (bool? value) => setState(() => options[key] = value!), activeColor: const Color(0xFF007BFF)),
                Text(key),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_today)),
      readOnly: true,
      onTap: () => _selectDate(context, controller),
    ),
  );

  Widget _buildTextField(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ),
  );

  Widget _buildDropdown(String label, List<String> items, String? value, ValueChanged<String?> onChanged) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      value: value,
      items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
    ),
  );
}