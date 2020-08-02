import 'dart:math';

import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

import 'curvesAnimation.dart';
import 'dashboard.dart';


class PaymentInformation extends StatelessWidget {
  PaymentInformation(this.upiTransactionResponse, {Key key}) : super(key: key);

  final UpiTransactionResponse upiTransactionResponse;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        body: PaymentInformationStateful(upiTransactionResponse: upiTransactionResponse,),
      ),
    );
  }
}

class PaymentInformationStateful extends StatefulWidget {

  PaymentInformationStateful({Key key, this.upiTransactionResponse}) : super(key: key);
  final UpiTransactionResponse upiTransactionResponse;
  @override
  PaymentInformationState createState() => PaymentInformationState();
}

class PaymentInformationState extends State<PaymentInformationStateful> {




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

             
      body: SingleChildScrollView(
        child: Stack(
          children: [




        widget.upiTransactionResponse.status == UpiTransactionStatus.success ? 
              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height,
                child: 
              Align(
                alignment: Alignment.bottomRight,
                child: 
              Icon(Icons.check_box, color: Colors.green, size: 180.00,),
              ),
              ) : 
              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height,
                child: 
              Align(
                alignment: Alignment.topRight,
                child: 
              Icon(Icons.indeterminate_check_box, color: Colors.red, size: 180.00,),
              ),
              ),








            Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [


          Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(),
          ),


          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 4.0),
            child: Row(
            children: [
              IconButton(icon: Icon(Icons.chevron_left, color: Colors.black), onPressed: () {
                Navigator.of(globalContext).pop();
        },),
            ],
          ),
          ),
        
        
            Padding(

            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text("Payment Status",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.black
              ),
            ),

              ),

            


            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [





                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(widget.upiTransactionResponse.rawResponse, style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),





                ]),
                ),









                
                
                
                
                ),






         ]),
         
         
         
           ]),
           
     ),
     
     
      );


  }
}
