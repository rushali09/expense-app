import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



  class NewTransaction extends StatefulWidget {
   
    final Function addTx;

    NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
    
    final _titleController= TextEditingController();
    final _amountController= TextEditingController();

     DateTime _selectDate;

    void _submitData(){
       if(_amountController.text.isEmpty){
         return;
       }
      final enteredTitle= _titleController.text;
      final enteredAmount= double.parse(_amountController.text);
      
      if (enteredTitle.isEmpty || enteredAmount<=0 || _selectDate==null ){
          return;
      }

      widget.addTx(
        
          enteredTitle,
          enteredAmount,       
          _selectDate,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       

                    
      );

      Navigator.of(context).pop(); //automatically closes the model sheet once data is entered
    }

    void _presentDatePicker(){
      showDatePicker(
        context: context,
         initialDate: DateTime.now(), 
         firstDate: DateTime(2020),
          lastDate: DateTime.now(),
      ).then((pickedDate) {
        if(pickedDate==null){
          return;
        }

       setState(() {
           _selectDate = pickedDate;
       });
      
    
    
      });
    }

    @override
    Widget build(BuildContext context) {
      return  Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Title"),
                    controller: _titleController,
                    onSubmitted:(_)=>_submitData ,
                   
                    //onChanged: (val)
                      
                      //titleInput=val;
                   
                    
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Amount"),
                    
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted:(_)=>_submitData ,
                    //onChanged: (val)
                       //amountInput=val;
                    
                  ),
                  
                  Container(
                    height: 70,
                    child: Row(
                      
                      children: [
                        Expanded(
                              child: Text(_selectDate== null ? "no date choosen"
                          :"Picked Date:${DateFormat.yMd().format(_selectDate)}",
                          ),
                        ),
                        FlatButton(
                          onPressed: _presentDatePicker,
                        
                          textColor: Theme.of(context).primaryColor,
                          child: Text("Choose Date",
                           style:TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                           
                          )
    
                      ],
                    ),
                  ),

                   RaisedButton(
                    onPressed: _submitData,
                    child: Text("Add Transaction"),
                    textColor: Colors.pink,
                  ),
                ],
              ),
            ),
          );
    }
}