import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// amanda bueno

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'IMC Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // globals
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // consts
  static const _iconSize = 120.0;
  static const _textFormFieldWidth = 350.0;
  static const _buttonHeight = 35.0;
  static const IconData refresh = IconData(0xe514, fontFamily: 'MaterialIcons');

  // variables
  static String _infoText = "Informe seus dados";
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // functions
  void _resetFields() {
    _formKey = GlobalKey<FormState>();
    _weightController.text = "";
    _heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados";
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text)/100;
      double imc = weight/(height*height);
      _infoText = _mapIMCValueToInfo(imc);
    });
  }

String _mapIMCValueToInfo(imc) {
    try {
      if(imc < 18.5) {
        return'Abaixo do peso';
      } else if(imc >= 18.5 && imc <= 24.9) {
        return "Peso normal (${imc.toStringAsPrecision(4)})";
      } else if(imc > 25 && imc <= 29.9) {
        return "Sobrepeso (${imc.toStringAsPrecision(4)})";
      } else if(imc > 30 && imc <= 34.9) {
        return "Obesidade grau 1 (${imc.toStringAsPrecision(4)})";
      } else if(imc > 35 && imc <= 39.9) {
        return "Obesidade grau 2 (${imc.toStringAsPrecision(4)})";
      } else {
        return "Obesidade grau 3 (${imc.toStringAsPrecision(4)})";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar( centerTitle: true,
          title: Text(widget.title,
          style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          ),
        ),
          actions: <Widget>[
            IconButton(
                onPressed: _resetFields,
                icon: const Icon(refresh))
          ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.person_outline_outlined,
                  size: _iconSize,
                ),
              ),
              SizedBox(
                width: _textFormFieldWidth,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: "Peso (kg)",
                  ),
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Digite um peso válido";
                    }
                    if (double.parse(value) > 500){
                      return "Digite um peso válido";
                    }
                    if (double.parse(value) < 0){
                      return "Digite um peso válido";
                    }
                  },
                ),
              ),
              SizedBox(
                width: _textFormFieldWidth,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: "Altura (cm)",
                  ),
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Digite uma altura válida";
                    }
                    if (double.parse(value) > 300){
                      return "Digite uma altura válida";
                    }
                    if (double.parse(value) < 0){
                      return "Digite uma altura válida";
                    }
                  },
                ),
              ),
              Container(
                width: _textFormFieldWidth,
                height: _buttonHeight,
                margin: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()) {
                      _calculate();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,),
                  child: const Text("Calcular"),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                child: const Text("Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(_infoText),
              ),
            ],
          ),
        )
      )
    );
  }
}