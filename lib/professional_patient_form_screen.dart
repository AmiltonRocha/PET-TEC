// professional_patient_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum Sexo { feminino, masculino }
enum RespostaSimNao { sim, nao }
enum RespostaSimNaoSemIndicacao { sim, nao, semIndicacao }
enum TipoAVC { isquemico, hemorragico }
enum Desfecho { internado, transferido, alta, obito }

class PatientFormScreen extends StatefulWidget {
  final String? initialCpf;

  const PatientFormScreen({
    super.key,
    this.initialCpf, // Torna o CPF opcional no construtor
  });

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();

  // Máscara
  final _cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _inicioSintomasController = TextEditingController();
  final _dataAvcController = TextEditingController();
  final _tempoVmController = TextEditingController();
  final _sequelasOutrasController = TextEditingController();
  final _altaMedicamentoController = TextEditingController();
  final _histFamiliarOutrasController = TextEditingController();
  final _usoDiarioMedicamentoController = TextEditingController();

  // Variáveis de estado para os campos do formulário
  Sexo? _sexo;
  String? _faixaEtaria;
  TipoAVC? _tipoAvc;
  RespostaSimNao? _admissaoJanela;
  RespostaSimNaoSemIndicacao? _realizouTrombolise;
  RespostaSimNaoSemIndicacao? _realizouTrombectomia;
  RespostaSimNao? _ventilacaoMecanica;
  RespostaSimNao? _foiIntubado;
  RespostaSimNao? _foiTraqueostomizado;
  Desfecho? _desfecho;
  RespostaSimNao? _altaPrescritoMedicamento;
  RespostaSimNao? _medicamentoUsoDiario;
  String? _atividadeFisica;
  String? _tabagismo;
  String? _consumoAlcool;

  // Mapas para os grupos de checkboxes
  final Map<String, bool> _medicamentosUtilizados = { 'Antiagregante plaquetário': false, 'Anticoagulante': false, 'Trombolítico': false, 'Estatina': false, 'Anti-hipertensivo': false, 'Diurético': false, 'Anticonvulsivante': false, };
  final Map<String, bool> _sequelas = { 'Disfagia': false, 'Parestesia parcial': false, 'Parestesia total': false, 'Paralisia parcial': false, 'Paralisia total': false, 'Perda da memória': false, 'Perda da visão': false, 'Afasia': false, };
  final Map<String, bool> _comorbidades = { 'Diabetes': false, 'Hipertensão': false, 'Obesidade': false, 'Infarto agudo do miocárdio': false, 'Insuficiência cardíaca': false, 'AVC': false, };
  final Map<String, bool> _historicoFamiliar = { 'Diabetes': false, 'Hipertensão': false, 'Sedentarismo': false, 'Obesidade': false, 'Infarto agudo do miocárdio': false, 'Insuficiência cardíaca': false, 'Etilista': false, 'Fumante': false, 'AVC': false, };
  final Map<String, bool> _alimentacao = { 'Frituras': false, 'Embutidos': false, 'Comidas muito salgadas': false, 'Doces em excesso': false, };

  @override
  void initState() {
    super.initState();
    if (widget.initialCpf != null) {
      _cpfController.text = _cpfMaskFormatter.maskText(widget.initialCpf!);
    }
  }

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
    // Incluindo os controladores de nome e cpf
    _nomeController.dispose();
    _cpfController.dispose();

    _inicioSintomasController.dispose();
    _dataAvcController.dispose();
    _tempoVmController.dispose();
    _sequelasOutrasController.dispose();
    _altaMedicamentoController.dispose();
    _histFamiliarOutrasController.dispose();
    _usoDiarioMedicamentoController.dispose();
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
          // Decoração de fundo
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
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Identificação'),

                          // Campos de Nome e CPF
                          _buildTextField('Nome do Paciente:', _nomeController),
                          _buildTextField(
                            'CPF:',
                            _cpfController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [_cpfMaskFormatter],
                          ),

                          _buildRadioGroup<Sexo>(
                            options: {'Feminino': Sexo.feminino, 'Masculino': Sexo.masculino},
                            groupValue: _sexo,
                            onChanged: (value) => setState(() => _sexo = value),
                          ),
                          _buildDropdown('Faixa etária:', [ 'até 18 anos', '19–25 anos', '26–35 anos', '36–45 anos', '46–55 anos', '56–65 anos', 'acima de 65 anos'], _faixaEtaria, (val) => setState(() => _faixaEtaria = val)),
                          
                          _buildSectionTitle('Dados Clínicos'),
                          _buildDateField('Data de início dos sintomas:', _inicioSintomasController),
                          _buildDateField('Data do AVC:', _dataAvcController),
                          _buildRadioGroup<TipoAVC>(title: 'Tipo de AVC:', options: {'Isquêmico': TipoAVC.isquemico, 'Hemorrágico': TipoAVC.hemorragico}, groupValue: _tipoAvc, onChanged: (val) => setState(() => _tipoAvc = val)),
                          _buildRadioGroup<RespostaSimNao>(title: 'Admissão dentro da janela terapêutica?', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _admissaoJanela, onChanged: (val) => setState(() => _admissaoJanela = val)),
                          
                          _buildSectionTitle('Tratamento'),
                          _buildRadioGroup<RespostaSimNaoSemIndicacao>(title: 'Realizou trombólise?', options: {'Sim': RespostaSimNaoSemIndicacao.sim, 'Não': RespostaSimNaoSemIndicacao.nao, 'Sem indicação': RespostaSimNaoSemIndicacao.semIndicacao}, groupValue: _realizouTrombolise, onChanged: (val) => setState(() => _realizouTrombolise = val)),
                          _buildRadioGroup<RespostaSimNaoSemIndicacao>(title: 'Realizou trombectomia?', options: {'Sim': RespostaSimNaoSemIndicacao.sim, 'Não': RespostaSimNaoSemIndicacao.nao, 'Sem indicação': RespostaSimNaoSemIndicacao.semIndicacao}, groupValue: _realizouTrombectomia, onChanged: (val) => setState(() => _realizouTrombectomia = val)),
                          _buildCheckboxGroup('Medicamentos utilizados:', _medicamentosUtilizados),
                          
                          _buildSectionTitle('Evolução'),
                          _buildRadioGroup<RespostaSimNao>(title: 'Ventilação mecânica?', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _ventilacaoMecanica, onChanged: (val) => setState(() => _ventilacaoMecanica = val)),
                          if (_ventilacaoMecanica == RespostaSimNao.sim) _buildTextField('Se sim, quanto tempo?', _tempoVmController),
                          _buildRadioGroup<RespostaSimNao>(title: 'Foi intubado?', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _foiIntubado, onChanged: (val) => setState(() => _foiIntubado = val)),
                          _buildRadioGroup<RespostaSimNao>(title: 'Foi traqueostomizado?', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _foiTraqueostomizado, onChanged: (val) => setState(() => _foiTraqueostomizado = val)),
                          _buildCheckboxGroup('Sequelas:', _sequelas),
                          _buildTextField('Outras sequelas:', _sequelasOutrasController),
                          _buildDropdown('Desfecho:', ['Internado', 'Transferido', 'Alta', 'Óbito'], _desfecho?.name, (val) => setState(() => _desfecho = Desfecho.values.firstWhere((e) => e.name == val))),
                          if (_desfecho == Desfecho.alta) ...[
                             _buildRadioGroup<RespostaSimNao>(title: 'Se recebeu alta, foi prescrito algum medicamento?', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _altaPrescritoMedicamento, onChanged: (val) => setState(() => _altaPrescritoMedicamento = val)),
                             if (_altaPrescritoMedicamento == RespostaSimNao.sim) _buildTextField('Se sim, qual?', _altaMedicamentoController),
                          ],

                          _buildSectionTitle('Histórico e Hábitos'),
                          _buildCheckboxGroup('Comorbidades/Fatores de risco:', _comorbidades),
                          _buildCheckboxGroup('Histórico familiar:', _historicoFamiliar),
                          _buildTextField('Outros:', _histFamiliarOutrasController),
                          _buildRadioGroup<RespostaSimNao>(title: 'Medicamento de uso diário:', options: {'Sim': RespostaSimNao.sim, 'Não': RespostaSimNao.nao}, groupValue: _medicamentoUsoDiario, onChanged: (val) => setState(() => _medicamentoUsoDiario = val)),
                          if (_medicamentoUsoDiario == RespostaSimNao.sim) _buildTextField('Se sim, qual?', _usoDiarioMedicamentoController),
                          _buildCheckboxGroup('Alimentação – consome com frequência:', _alimentacao),
                          _buildDropdown('Atividade física:', ['Não pratica', '2x/semana', '3x/semana', 'Mais de 4x/semana'], _atividadeFisica, (val) => setState(() => _atividadeFisica = val)),
                          _buildDropdown('Tabagismo:', ['Nunca fumou', 'Ex-fumante', 'Fumante ocasional', 'Fumante diário'], _tabagismo, (val) => setState(() => _tabagismo = val)),
                          _buildDropdown('Consumo de álcool:', ['Não consome', 'Ocasionalmente', 'Regularmente'], _consumoAlcool, (val) => setState(() => _consumoAlcool = val)),

                        ],
                      ),
                    ),
                  ),
                ),
                
                // Botão Confirmar
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, foregroundColor: vibrantBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    ),
                    onPressed: () { /* Aqui é a Lógica para salvar os dados do formulário */ },
                    child: const Text('Confirmar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          
          // Botão Voltar
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

  Widget _buildTextField(
    String label, 
    TextEditingController controller, 
    {TextInputType keyboardType = TextInputType.text,
     List<TextInputFormatter>? inputFormatters}
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
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