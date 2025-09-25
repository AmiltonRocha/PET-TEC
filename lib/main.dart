import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

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

  bool _isProcessing = false;
  bool _isSuccess = false;

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
    if (anos > 110) {
      anos = -1; // invalida
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

  Future<void> _salvar() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isProcessing = true;
    _isSuccess = false;
  });

  final dados = {
    "nome": nomeController.text,
    "cpf": cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    "data_nascimento": dataNascController.text,
    "idade": idade,
    "sexo": sexoSelecionado,
    "telefone": telefoneController.text,
    "quarto_leito": leitoController.text,
    "queixa_principal": queixaController.text,
    "observacoes": obsController.text,
    "tipo_avc": tipoAvcSelecionado,
  };

  try {
    final url = Uri.parse("http://127.0.0.1:8000/pacientes"); // localhost
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dados),
    );

    await Future.delayed(const Duration(seconds: 2)); // bolinha girando 2s

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        _isSuccess = true;
      });
      await Future.delayed(const Duration(seconds: 1)); // check 1s

      // Limpar todos os campos
      nomeController.clear();
      cpfController.clear();
      dataNascController.clear();
      telefoneController.clear();
      leitoController.clear();
      queixaController.clear();
      obsController.clear();

      setState(() {
        sexoSelecionado = null;
        tipoAvcSelecionado = null;
        idade = null;
        _isProcessing = false;
        _isSuccess = false;
      });
    } else {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar: ${response.body}")),
      );
    }
  } catch (e) {
    setState(() {
      _isProcessing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro de conexão: $e")),
    );
  }
}

  bool get _showIdade => dataNascController.text.length == 10;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                          TextFormField(
                            controller: nomeController,
                            decoration: const InputDecoration(
                                labelText: "Nome do paciente"),
                            validator: (value) => value == null || value.isEmpty
                                ? "Informe o nome"
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: cpfController,
                            decoration: const InputDecoration(
                              labelText: "CPF",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskedInputFormatter('000.000.000-00')
                            ],
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Informe o CPF";
                              if (!validarCPF(value)) return "CPF inválido";
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
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
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    MaskedInputFormatter('00/00/0000')
                                  ],
                                  onChanged: (val) {
                                    if (_showIdade) {
                                      try {
                                        final data = DateFormat('dd/MM/yyyy')
                                            .parseStrict(val);
                                        _calcularIdade(data);
                                      } catch (_) {
                                        setState(() {
                                          idade = null;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        idade = null;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return "Informe a data";
                                    if (idade == -1) return "Idade inválida (>110)";
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (_showIdade && idade != null && idade != -1)
                                Text(
                                  "$idade anos",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: sexoSelecionado,
                            decoration:
                                const InputDecoration(labelText: "Sexo"),
                            items: const [
                              DropdownMenuItem(
                                  value: "Masculino", child: Text("Masculino")),
                              DropdownMenuItem(
                                  value: "Feminino", child: Text("Feminino")),
                            ],
                            onChanged: (valor) {
                              setState(() {
                                sexoSelecionado = valor;
                              });
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? "Selecione o sexo"
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: telefoneController,
                            decoration:
                                const InputDecoration(labelText: "Telefone"),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              MaskedInputFormatter('(00) 00000-0000')
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: leitoController,
                            decoration:
                                const InputDecoration(labelText: "Quarto/Leito"),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: queixaController,
                            decoration:
                                const InputDecoration(labelText: "Queixa principal"),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: obsController,
                            decoration:
                                const InputDecoration(labelText: "Observações"),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: tipoAvcSelecionado,
                            decoration:
                                const InputDecoration(labelText: "Tipo de AVC"),
                            items: const [
                              DropdownMenuItem(
                                  value: "Isquêmico", child: Text("Isquêmico")),
                              DropdownMenuItem(
                                  value: "Hemorrágico", child: Text("Hemorrágico")),
                            ],
                            onChanged: (valor) {
                              setState(() {
                                tipoAvcSelecionado = valor;
                              });
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? "Selecione o tipo de AVC"
                                : null,
                          ),
                          const SizedBox(height: 24),
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
        ),
        // Overlay de carregamento
        if (_isProcessing || _isSuccess)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: _isSuccess
                  ? const Icon(Icons.check_circle,
                      color: Colors.green, size: 80)
                  : const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4,
                    ),
            ),
          ),
      ],
    );
  }
}
                                  
