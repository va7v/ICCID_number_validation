import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

CellOperator? operator = CellOperator.Tele2;

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

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// State class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // global key uniquely identifies the Form widget and allows validation of the form.
  // a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>.
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
              FilteringTextInputFormatter.digitsOnly // фильтр - только числа
            ],
            validator: (value) {
              print('cmp $operator');
              if (value == null ||
                  value.isEmpty ||
                  value.length > 24 ||
                  !isValidLuhn(value) && operator != CellOperator.Bee) {
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
                        const SnackBar(content: Text('Внесение карты в систему... ')),
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
  //java Character.getNumericValue(value.charAt(value.length() - 1));
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

enum CellOperator { Tele2, Bee, Mega, Mts, Rtk, Motiv }

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
            value: CellOperator.Tele2,
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
            value: CellOperator.Bee,
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
            value: CellOperator.Mega,
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
            value: CellOperator.Mts,
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
            value: CellOperator.Rtk,
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
