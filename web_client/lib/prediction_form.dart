import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:unnames/tools.dart';
import 'constants.dart';
import 'prediction_service.dart';

class PredictionForm extends StatefulWidget {
  const PredictionForm({Key? key}) : super(key: key);

  @override
  _PredictionFormState createState() => _PredictionFormState();
}

class _PredictionFormState extends State<PredictionForm> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController bController = TextEditingController(text: '200');
  // final TextEditingController hController = TextEditingController(text: '200');
  // final TextEditingController tController = TextEditingController(text: '5');
  // final TextEditingController lController = TextEditingController(text: '2000');
  // final TextEditingController fyController = TextEditingController(text: '400');
  // final TextEditingController fcController = TextEditingController(text: '30');

  final TextEditingController bController = TextEditingController();
  final TextEditingController hController = TextEditingController();
  final TextEditingController tController = TextEditingController();
  final TextEditingController lController = TextEditingController();
  final TextEditingController fyController = TextEditingController();
  final TextEditingController fcController = TextEditingController();
  Map<String, dynamic> predictionResult = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppTitle, style: TextStyles.h1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: MyColors.background,
                child: Text(
                  'This is an Artificial Neural Network (ANN) developed by students at the University of Civil Engineering in Basra. It predicts the compressive strength of Rectangular Concrete-Filled Steel Tubes (R_CFST).',
                  style: TextStyles.body1,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: bController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'b (mm)',
                  labelStyle: TextStyles.buttonText1,
                  hintText: '40 < b < 360',
                ),
                validator: (value) => inputChecker(value, 40, 360),
              ),
              TextFormField(
                controller: hController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'h (mm)',
                  labelStyle: TextStyles.buttonText1,
                  hintText: '40 < h < 360',
                ),
                validator: (value) => inputChecker(value, 40, 360),
              ),
              TextFormField(
                controller: tController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 't (mm)',
                  labelStyle: TextStyles.buttonText1,
                  hintText: '0.7 < t < 15',
                ),
                validator: (value) => inputChecker(value, 0.7, 15),
              ),
              TextFormField(
                controller: lController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'L (mm)',
                  labelStyle: TextStyles.buttonText1,
                  hintText: '100 < L < 4500',
                ),
                validator: (value) => inputChecker(value, 100, 4500),
              ),
              TextFormField(
                controller: fyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'fy (MPa)',
                  labelStyle: TextStyles.buttonText1,
                  hintText: '115 < fy < 835',
                ),
                validator: (value) => inputChecker(value, 115, 835),
              ),
              TextFormField(
                controller: fcController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'fc (MPa)',
                  labelStyle: TextStyles.buttonText1,
                  hintText: '10 < fc < 160',
                ),
                validator: (value) => inputChecker(value, 10, 160),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Call the prediction service to get the result
                    double b = double.parse(bController.text);
                    double h = double.parse(hController.text);
                    double t = double.parse(tController.text);
                    double l = double.parse(lController.text);
                    double fy = double.parse(fyController.text);
                    double fc = double.parse(fcController.text);
                    PredictionService predictionService = PredictionService();
                    String result =
                    await predictionService.predict(b, h, t, l, fy, fc);
                    setState(() {
                      predictionResult = jsonDecode(result);
                    });
                  }
                },
                child: Text('Predict', style: TextStyles.h2),
              ),
              const SizedBox(height: 20),
              // Conditionally render DataTable based on data availability
              if (predictionResult.isNotEmpty)
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                              (states) => MyColors.background),
                      columns: const [
                        DataColumn(
                          label: Text('Method',style:TextStyle(fontFamily: Fonts.raleway,fontSize: 15,color: Color(0xFF5E35B1))),
                        ),
                        DataColumn(
                          label:
                          Text('ΦPn',style: TextStyle(fontFamily: Fonts.raleway,fontSize: 15,color: Color(0xFF5E35B1))),
                        ),
                      ],
                      rows: resultRows(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<DataRow> resultRows() {
    return predictionResult.entries.map((entry) {
      return DataRow(
        cells: [
          DataCell(Text(entry.key)),
          DataCell(Text('${entry.value} KN')),
        ],
      );
    }).toList();
  }
}
