import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Transport Sync', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> db = {'settings': {'currency':'BDT'}, 'vehicles':[], 'income':[], 'expenses':[]};

  @override
  void initState() {
    super.initState();
    loadDB();
  }

  loadDB() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('transport_sync_db') ?? '';
    if(s.isNotEmpty) {
      setState((){ db = jsonDecode(s); });
    }
  }

  saveDB() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transport_sync_db', jsonEncode(db));
  }

  addVehicle(Map v) {
    setState(() {
      db['vehicles'].add(v);
    });
    saveDB();
  }

  addIncome(Map r) {
    setState(() {
      db['income'].add(r);
    });
    saveDB();
  }

  addExpense(Map r) {
    setState(() {
      db['expenses'].add(r);
    });
    saveDB();
  }

  @override
  Widget build(BuildContext context) {
    double income = 0, expenses = 0;
    db['income'].forEach((i){ income += (i['amount'] ?? 0); });
    db['expenses'].forEach((e){ expenses += (e['amount'] ?? 0); });
    return Scaffold(
      appBar: AppBar(title: Text('Transport Sync')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          Text('Income: \$${income.toStringAsFixed(2)}  Expenses: \$${expenses.toStringAsFixed(2)}'),
          SizedBox(height:10),
          ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AddVehiclePage(onAdd: addVehicle))), child: Text('Add Vehicle')),
          ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AddIncomePage(vehicles: db['vehicles'], onAdd: addIncome))), child: Text('Add Income')),
          ElevatedButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> AddExpensePage(vehicles: db['vehicles'], onAdd: addExpense))), child: Text('Add Expense')),
        ]),
      ),
    );
  }
}

class AddVehiclePage extends StatefulWidget {
  final Function onAdd;
  AddVehiclePage({required this.onAdd});
  @override _AddVehiclePageState createState() => _AddVehiclePageState();
}
class _AddVehiclePageState extends State<AddVehiclePage> {
  final regC = TextEditingController();
  final modelC = TextEditingController();
  final driverC = TextEditingController();
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Vehicle')),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          TextField(controller: regC, decoration: InputDecoration(labelText: 'Reg No')),
          TextField(controller: modelC, decoration: InputDecoration(labelText: 'Model')),
          TextField(controller: driverC, decoration: InputDecoration(labelText: 'Driver')),
          SizedBox(height:10),
          ElevatedButton(onPressed: () {
            if(regC.text.isEmpty) return;
            widget.onAdd({'id': DateTime.now().millisecondsSinceEpoch.toString(), 'reg': regC.text, 'model': modelC.text, 'driver': driverC.text});
            Navigator.pop(context);
          }, child: Text('Save')),
        ]),
      ),
    );
  }
}

class AddIncomePage extends StatefulWidget {
  final List vehicles; final Function onAdd;
  AddIncomePage({required this.vehicles, required this.onAdd});
  @override _AddIncomePageState createState() => _AddIncomePageState();
}
class _AddIncomePageState extends State<AddIncomePage> {
  String? vehicleId; final amtC = TextEditingController();
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Income')),
      body: Padding(padding: EdgeInsets.all(12), child: Column(children: [
        DropdownButton<String>(value: vehicleId, hint: Text('Select Vehicle'), items: widget.vehicles.map<DropdownMenuItem<String>>((v)=>DropdownMenuItem(child: Text(v['reg']), value: v['id'])).toList(), onChanged: (v)=> setState(()=>vehicleId=v)),
        TextField(controller: amtC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount')),
        ElevatedButton(onPressed: (){ if(vehicleId==null || amtC.text.isEmpty) return; widget.onAdd({'id': DateTime.now().millisecondsSinceEpoch.toString(), 'vehicleId': vehicleId, 'amount': double.parse(amtC.text)}); Navigator.pop(context);}, child: Text('Save')),
      ])),
    );
  }
}

class AddExpensePage extends StatefulWidget {
  final List vehicles; final Function onAdd;
  AddExpensePage({required this.vehicles, required this.onAdd});
  @override _AddExpensePageState createState() => _AddExpensePageState();
}
class _AddExpensePageState extends State<AddExpensePage> {
  String? vehicleId; final amtC = TextEditingController();
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(padding: EdgeInsets.all(12), child: Column(children: [
        DropdownButton<String>(value: vehicleId, hint: Text('Select Vehicle'), items: widget.vehicles.map<DropdownMenuItem<String>>((v)=>DropdownMenuItem(child: Text(v['reg']), value: v['id'])).toList(), onChanged: (v)=> setState(()=>vehicleId=v)),
        TextField(controller: amtC, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount')),
        ElevatedButton(onPressed: (){ if(vehicleId==null || amtC.text.isEmpty) return; widget.onAdd({'id': DateTime.now().millisecondsSinceEpoch.toString(), 'vehicleId': vehicleId, 'amount': double.parse(amtC.text)}); Navigator.pop(context);}, child: Text('Save')),
      ])),
    );
  }
}
