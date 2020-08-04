import 'dart:io';


import 'package:expenses_app/widgets/chart.dart';
import 'package:expenses_app/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';


void main() {
 // WidgetsFlutterBinding.ensureInitialized();
 // SystemChrome.setPreferredOrientations([ //to set only portrait mode for app content
 //   DeviceOrientation.portraitUp,
 //    DeviceOrientation.portraitDown,
  //  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:  "Personal Expenses",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.black,
        errorColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [];
  
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount,DateTime chosenDate){
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id){
      setState(() {
            _userTransaction.removeWhere((tx){
                return  tx.id == id;
            });
      });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
   final isLandscape =  MediaQuery.of(context).orientation == Orientation.landscape;
    final PreferredSizeWidget appBar= Platform.isIOS 
       ?CupertinoNavigationBar(
         middle:Text("Personal Expenses"),
         trailing:Row(
           mainAxisSize: MainAxisSize.min,
           children: [
            GestureDetector(
           child: Icon(CupertinoIcons.add) ,
           onTap: ()=>_startAddNewTransaction(context) ,
           )
         ],) ,
       )
       :AppBar(
        title: Text("Personal Expenses"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
          ),
        ],
      ); 
      final txListWidget =  Container(
               height: (mediaQuery.size.height
                                -appBar.preferredSize.height
                                -mediaQuery.padding.top //to romove the status bar height
                                )*0.7,
              child: TransactionList(_userTransaction,_deleteTransaction)
              );
   
     final pageBody = SafeArea(child:  SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Text("show chart"),
            Switch.adaptive( //adaptive ios and android look
              value: _showChart, 
              onChanged:(val){
                   setState(() {
                     _showChart = val;
                   });
            }  ),
            ],
          ),
          if(!isLandscape)
           Container(
              height: (mediaQuery.size.height
                         -appBar.preferredSize.height
                         -mediaQuery.padding.top
                         )*0.3,
              child: Chart(_recentTransactions)
              ),
          if(!isLandscape) txListWidget,
          if(isLandscape)  _showChart ? Container(
              height: (mediaQuery.size.height
                         -appBar.preferredSize.height
                         -mediaQuery.padding.top
                         )*0.7,
              child: Chart(_recentTransactions)
              ):
          txListWidget,
          ],
        ),
      )
      );        
    return Platform.isIOS
     ?CupertinoPageScaffold(
       child: pageBody,
       navigationBar: appBar,
       )
     :Scaffold(
      appBar: appBar,
      body:pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS 
          ? Container()
          :FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context)),
    );
  }
}
