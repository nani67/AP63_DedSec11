import 'dart:math';

import 'package:doctors_voice_mobile/payment_successful.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

import 'curvesAnimation.dart';
import 'dashboard.dart';


class UpiPaymentStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: UpiPaymentStateful(),
      ),
    );
  }
}

class UpiPaymentStateful extends StatefulWidget {
  @override
  UpiPaymentState createState() => UpiPaymentState();
}

class UpiPaymentState extends State<UpiPaymentStateful> {

  final _upiAddressController = TextEditingController(text: 
    "8801853078@paytm",);
  final _amountController = TextEditingController(
    text: "100.00",
  );

  bool _isUpiEditable = false;
  Future<List<ApplicationMeta>> _appsFuture;

  @override
  void initState() {
    super.initState();

    _appsFuture = UpiPay.getInstalledUpiApplications();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _upiAddressController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

             
      body: SingleChildScrollView(
        child: Stack(
          children: [




        CustomPaint(
      painter: NewPatientPainter(),
      size: MediaQuery.of(context).size,
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
              IconButton(icon: Icon(Icons.chevron_left, color: Colors.white), onPressed: () {
                Navigator.of(globalContext).pop();
        },),
            ],
          ),
          ),
        
        
            Padding(

            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Text("Payment",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
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
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("Payment info", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),




                  
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [



            Row(
              children: <Widget>[

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                    controller: _upiAddressController,
                    enabled: false,
                    style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                      hintText: 'address@upi',
                      labelText: 'Receiving UPI Address',
                      ),
                  ),
                  ),
                ),

              ],
            ),
 




            Row(
              children: <Widget>[
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextFormField(
                    controller: _amountController,
                    enabled: _isUpiEditable,
                    style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                      labelText: 'Amount',
                      ),
                  ),
                  ),
                ),
              ],
            ),


          ],
        ),
      ),

                ]),
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
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("Payment options", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),




                  
                FutureBuilder<List<ApplicationMeta>>(
                  future: _appsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container();
                    } 

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      
                      itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: FlatButton(
                            color: Colors.white,
                            onPressed: () async {
                                await UpiPay.initiateTransaction(
                                amount: "10.00",
                                app: snapshot.data[index].upiApplication,
                                receiverName: "Doctor's Voice",
                                receiverUpiAddress: "8801853078@paytm",
                                 /// unique ID for the transaction
                                 /// use your business / use case specific ID generation logic here
                                 transactionRef: 'ORD1215236',

                                  /// there are some other optional parameters like
                                  /// [url], [merchantCode] and [transactionNode]                          
                                  /// url can be used share some additional data related to the transaction like invoice copy, etc.
                                  url: 'www.johnshop.com/order/ORD1215236',

                                  /// this is code that identifies the type of the merchant
                                  /// if you have a merchant UPI VPA as the receiver address
                                  /// add the relevant merchant code for seamless payment experience
                                  /// some application may reject payment intent if merchant code is missing
                                  /// when making a P2M (payment to merchant VPA) transaction
                                  merchantCode: "1032",
                                  transactionNote: 'Test transaction'
                                ).then((value) {
                                  print(value.txnRef);
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => PaymentInformation(value)));
                                  return value;
                                });
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: 
                                      Image.memory(
                                        snapshot.data[index].icon,
                                        width: 48.0,
                                        height: 48.0,
                                      ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4),
                                        child: Text(
                                          snapshot.data[index].upiApplication.getAppName(),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          );
                      },
                    ),
                    );

                  },
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

String _validateUpiAddress(String value) {
  if (value.isEmpty) {
    return 'UPI Address is required.';
  }

  if (!UpiPay.checkIfUpiAddressIsValid(value)) {
    return 'UPI Address is invalid.';
  }

  return null;
}