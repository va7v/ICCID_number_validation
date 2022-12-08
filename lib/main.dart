import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Данные чипа SIM карты';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: 360,
            child: ListView(
              children: [
                Text(
                  'Выберите сотового оператора SIM карты:',
                  style: TextStyle(fontSize: 16),
                ),
                const RadioBtStatefulWidget(),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Введите номер напечатанный на SIM карте:',
                  style: TextStyle(fontSize: 16),
                ),
                const MyCustomForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.sim_card),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              print('cmp $operator');
              if (value == null ||
                  value.isEmpty ||
                  value.length > 24 ||
                  !isValidLuhn(value) && operator != CellOperator.bee) {
                return 'Проверьте точность указания номера';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: SizedBox(width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Updating...    ${operator?.index} ($operator)')),
                      );
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bool isValidLuhn(String value) {
  int sum = value.codeUnitAt(value.length - 1) - 48;
  int parity = value.length % 2;
  for (int i = value.length - 2; i >= 0; i--) {
    int summand = value.codeUnitAt(i) - 48;
    if (i % 2 == parity) {
      int product = summand * 2;
      summand = (product > 9) ? (product - 9) : product;
    }
    sum += summand;
  }
  return (sum % 10) == 0;
}

enum CellOperator { tele2, bee, mega, mts, rtk, motiv }
CellOperator? operator = CellOperator.tele2;

class RadioBtStatefulWidget extends StatefulWidget {
  const RadioBtStatefulWidget({super.key});

  @override
  State<RadioBtStatefulWidget> createState() => _RadioBtStatefulWidgetState();
}

class _RadioBtStatefulWidgetState extends State<RadioBtStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Tele2'),
          leading: Radio<CellOperator>(
            value: CellOperator.tele2,
            groupValue: operator,
            onChanged: (CellOperator? value) {
              setState(() {
                operator = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Билайн'),
          leading: Radio<CellOperator>(
            value: CellOperator.bee,
            groupValue: operator,
            onChanged: (CellOperator? value) {
              setState(() {
                operator = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Мегафон'),
          leading: Radio<CellOperator>(
            value: CellOperator.mega,
            groupValue: operator,
            onChanged: (CellOperator? value) {
              setState(() {
                operator = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('МТС'),
          leading: Radio<CellOperator>(
            value: CellOperator.mts,
            groupValue: operator,
            onChanged: (CellOperator? value) {
              setState(() {
                operator = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Ростелеком'),
          leading: Radio<CellOperator>(
            value: CellOperator.rtk,
            groupValue: operator,
            onChanged: (CellOperator? value) {
              setState(() {
                operator = value;
              });
            },
          ),
        ),
        // ListTile(
        //    title: const Text('Мотив'),
        //    leading: Radio<CellOperator>(
        //      value: CellOperator.Motiv,
        //      groupValue: operator,
        //      onChanged: (CellOperator? value) {
        //        setState(() {
        //          operator = value;
        //        });
        //      },
        //    ),
        //  ),
      ],
    );
  }
}
