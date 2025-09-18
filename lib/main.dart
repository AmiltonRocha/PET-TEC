import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Pacientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      home: const FormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final dataNascController = TextEditingController();
  final telefoneController = TextEditingController();
  final leitoController = TextEditingController();
  final queixaController = TextEditingController();
  final obsController = TextEditingController();

  String? sexoSelecionado;
  String? tipoAvcSelecionado;
  int? idade;

  // Selecionar data com DatePicker
  Future<void> _selecionarData() async {
    DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (dataSelecionada != null) {
      dataNascController.text = DateFormat('dd/MM/yyyy').format(dataSelecionada);
      _calcularIdade(dataSelecionada);
    }
  }

  void _calcularIdade(DateTime dataNasc) {
    final hoje = DateTime.now();
    int anos = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month ||
        (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      anos--;
    }
    setState(() {
      idade = anos;
    });
  }

  // Validação CPF
  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (cpf.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int resto = (soma * 10) % 11;
    if (resto == 10) resto = 0;
    if (resto != int.parse(cpf[9])) return false;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    resto = (soma * 10) % 11;
    if (resto == 10) resto = 0;
    if (resto != int.parse(cpf[10])) return false;

    return true;
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final dados = {
        "nome": nomeController.text,
        "cpf": cpfController.text,
        "data_nascimento": dataNascController.text,
        "idade": idade,
        "sexo": sexoSelecionado,
        "telefone": telefoneController.text,
        "leito": leitoController.text,
        "queixa": queixaController.text,
        "observacoes": obsController.text,
        "tipo_avc": tipoAvcSelecionado,
      };

      print("Paciente registrado: $dados");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registro salvo (simulado)!")),
      );

      _formKey.currentState!.reset();
      setState(() {
        sexoSelecionado = null;
        tipoAvcSelecionado = null;
        idade = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verifique os campos inválidos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Paciente")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nome
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: "Nome do paciente",
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Informe o nome" : null,
                      ),
                      const SizedBox(height: 16),

                      // CPF
                      TextFormField(
                        controller: cpfController,
                        decoration: InputDecoration(
                          labelText: "CPF",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [MaskedInputFormatter('000.000.000-00')],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Informe o CPF";
                          if (!validarCPF(value)) return "CPF inválido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Data de nascimento + idade
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dataNascController,
                              decoration: InputDecoration(
                                labelText: "Data de Nascimento",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: _selecionarData,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [MaskedInputFormatter('00/00/0000')],
                              onChanged: (val) {
                                try {
                                  final data =
                                      DateFormat('dd/MM/yyyy').parseStrict(val);
                                  _calcularIdade(data);
                                } catch (_) {
                                  setState(() {
                                    idade = null;
                                  });
                                }
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty ? "Informe a data" : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (idade != null)
                            Text(
                              "$idade anos",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Sexo
                      DropdownButtonFormField<String>(
                        value: sexoSelecionado,
                        decoration: const InputDecoration(labelText: "Sexo"),
                        items: const [
                          DropdownMenuItem(value: "Masculino", child: Text("Masculino")),
                          DropdownMenuItem(value: "Feminino", child: Text("Feminino")),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            sexoSelecionado = valor;
                          });
                        },
                        validator: (value) =>
                            value == null || value.isEmpty ? "Selecione o sexo" : null,
                      ),
                      const SizedBox(height: 16),

                      // Telefone
                      TextFormField(
                        controller: telefoneController,
                        decoration: const InputDecoration(labelText: "Telefone"),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [MaskedInputFormatter('(00) 00000-0000')],
                      ),
                      const SizedBox(height: 16),

                      // Quarto/Leito
                      TextFormField(
                        controller: leitoController,
                        decoration: const InputDecoration(labelText: "Quarto/Leito"),
                      ),
                      const SizedBox(height: 16),

                      // Queixa principal
                      TextFormField(
                        controller: queixaController,
                        decoration: const InputDecoration(labelText: "Queixa principal"),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Observações
                      TextFormField(
                        controller: obsController,
                        decoration: const InputDecoration(labelText: "Observações"),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Tipo de AVC
                      DropdownButtonFormField<String>(
                        value: tipoAvcSelecionado,
                        decoration: const InputDecoration(labelText: "Tipo de AVC"),
                        items: const [
                          DropdownMenuItem(value: "Isquêmico", child: Text("Isquêmico")),
                          DropdownMenuItem(value: "Hemorrágico", child: Text("Hemorrágico")),
                        ],
                        onChanged: (valor) {
                          setState(() {
                            tipoAvcSelecionado = valor;
                          });
                        },
                        validator: (value) =>
                            value == null || value.isEmpty ? "Selecione o tipo de AVC" : null,
                      ),
                      const SizedBox(height: 24),

                      // Botão salvar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _salvar,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text("Salvar Registro"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
