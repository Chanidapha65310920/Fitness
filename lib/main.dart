import 'package:flutter/material.dart';
import 'package:account/formScreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:account/model/transaction.dart';
import 'package:account/provider/transactionProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ],
        child: MaterialApp(
          title: 'Account',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade300),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormScreen()),
                );
                if (result != null && result is Map<String, dynamic>) {
                  Provider.of<TransactionProvider>(context, listen: false)
                      .addTransaction(Transaction(
                          title: result['title'],
                          amount: result['amount'],
                          dateTime: DateTime.now()));
                }
              },
            ),
          ],
        ),
        body: Consumer(
          builder: (context, TransactionProvider provider, Widget? child) {
            return ListView.builder(
                itemCount: provider.transactions.length,
                itemBuilder: (context, int index) {
                  Transaction data = provider.transactions[index];
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ListTile(
                      title: Text(data.title, style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(data.dateTime)),
                      leading: CircleAvatar(
                        child: FittedBox(
                          child: Text(data.amount.toString()),
                        ),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
