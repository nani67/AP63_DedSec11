
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctors_voice_mobile/curvesAnimation.dart';
import 'package:doctors_voice_mobile/dashboard.dart';
import 'package:doctors_voice_mobile/sending_facilities.dart';
import 'package:doctors_voice_mobile/speech_thing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'PDFPreviewScreen.dart';


import 'dart:io' as io;
import 'dart:async';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';


import 'package:http/http.dart' as http;


import 'package:flutter/services.dart' show rootBundle;

Future<ByteData> loadAsset() async {
  return await rootBundle.load('assets/dv.png');
}



class NewPatient extends StatelessWidget {
  NewPatient({Key key, this.firebaseUser,}) : super(key: key);
  final FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doctor's Voice",
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewPatientStateful(),
    );
  }

}

class NewPatientStateful extends StatefulWidget {
  NewPatientStateful({Key key, this.firebaseUser,}) : super(key: key);
  final FirebaseUser firebaseUser;

  @override
  State<StatefulWidget> createState() => new NewPatientState();

}


BuildContext buildContextOfNewPatient;
class NewPatientState extends State<NewPatientStateful> with TickerProviderStateMixin{

  bool isRecording = false;

  final pdf = pw.Document();


  SpeechRecognition _speech;

  String totalTranscript = "";
  String transcription = '';
  String selectedLang = 'en_IN';


String dateTime = DateFormat('yyyy-MM-dd_kk:mm').format(DateTime.now());



  TextEditingController patientNameController = new TextEditingController();
  TextEditingController patientGenderController = new TextEditingController();
  TextEditingController patientAgeController = new TextEditingController();
  TextEditingController uniqueId = new TextEditingController();
  TextEditingController symptomsP = new TextEditingController();
  TextEditingController diagnosisP = new TextEditingController();
  TextEditingController prescP = new TextEditingController();
  TextEditingController advicesP = new TextEditingController();

  Uint8List imageForPdf;

  FirebaseUser firebaseUserThing;

  String hospitalName;


  void initState() {
    super.initState();
    // activateSpeechRecognizer();


    Future.microtask(() {
      _prepare();
    });

    loadAsset().then((value) {
      var buffer = value.buffer;
      imageForPdf = buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
    });

    uniqueId.value = TextEditingValue(
      text: "DV-",
      selection: TextSelection.fromPosition(
        TextPosition(offset: 3),
      ),
    );

    FirebaseAuth.instance.currentUser().then((value) {
        firebaseUserThing = value;

        Firestore.instance.collection('doctors').document(value.email).collection('personal_info').document('data').get().then((value) {
          hospitalName = value['hospitalName'];
        });
        
        
    });


  }
































  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;



  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          await _prepare();
          break;
        }

      default:
        break;
    }

    setState(() {
      _recording.status == RecordingStatus.Recording ? isRecording = true : isRecording = false;
    });
  }

  Future _init() async {
    String customPath = '/flutter_audio_recorder_';
    io.Directory appDocDirectory;
    if (io.Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    // can add extension like ".mp4" ".wav" ".m4a" ".aac"
    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString();

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 16000);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
      });
    } else {
      setState(() {

      });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 100), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
      isRecording = false;
    });

  }













  // void onRecognitionComplete(String ok) => setState(() {
  //    isRecording = false;
  //    transcription = ok;

  //   String actualInfo = "";
  //   List<String> transcriptParsed = transcription.split(" ");
  //   List<String> modString = transcriptParsed.sublist(2);
  //   modString.forEach((element) {
  //     actualInfo = actualInfo  + element + " ";
  //   });

  //     if(transcriptParsed[0] == 'put' || transcriptParsed[0] == 'foot') {


  //     switch(transcriptParsed[1]) {
  //       case 'name': patientNameController.text = actualInfo; break;
  //       case 'age': patientAgeController.text = transcriptParsed[2]; break;
  //       case 'gender': patientGenderController.text = transcriptParsed[2]; break;
  //       case 'symptom': symptomsP.text == "" ? symptomsP.text = actualInfo : symptomsP.text = symptomsP.text + ", " + actualInfo; print(symptomsP.text); break;
  //       case 'diagnosis': diagnosisP.text == "" ? diagnosisP.text = actualInfo : diagnosisP.text = diagnosisP.text + ", " + actualInfo; break;
  //       case 'prescription': prescP.text == "" ? prescP.text = actualInfo : prescP.text = prescP.text + ", " + actualInfo; break;
  //       case 'advice': advicesP.text == "" ? advicesP.text = actualInfo : advicesP.text = advicesP.text + ", " + actualInfo; break;
  //       default : break;
  //     }


  //     } else if(transcriptParsed[0]  == 'remove') {
  //       print("Given order: Removing an element");


  //     switch(transcriptParsed[1]) {
  //       case 'name': patientNameController.text = ""; break;
  //       case 'age': patientAgeController.text = ""; break;
  //       case 'gender': patientGenderController.text = ""; break;
  //       case 'symptoms': symptomsP.text = "";  break;
  //       case 'diagnosis': diagnosisP.text = ""; break;
  //       case 'prescription': prescP.text = ""; break;
  //       case 'advice': advicesP.text = ""; break;
  //       default : break;
  //     }



  //     } else if(transcriptParsed[0]  == "modify") {
  //       print("Given order: modifying the element");


  //     switch(transcriptParsed[1]) {
  //       case 'name': patientNameController.text = actualInfo; break;
  //       case 'age': patientAgeController.text = transcriptParsed[2]; break;
  //       case 'gender': patientGenderController.text = transcriptParsed[2]; break;
  //       case 'symptom': symptomsP.text = actualInfo;  break;
  //       case 'diagnosis': diagnosisP.text = actualInfo; break;
  //       case 'prescription': prescP.text = actualInfo; break;
  //       case 'advice': advicesP.text = actualInfo; break;
  //       default : break;
  //     }

  //     }


  //   // response(transcription);
  // });

  bool uploadingPdfDone = true;

  bool isClicked = false;
  Widget showHelpCard() {
    return Container(
      child: Padding(
      
        padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: Card(
        color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isClicked ? [

            

            // Padding(
            //   padding: EdgeInsets.all(16.0),
            //   child: Text("Basic functions which can be performed", style: TextStyle(fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700)),
            // ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("'put name Nani'", style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("The above statement adds the name 'Nani' into the field 'Patient name'", style: TextStyle( fontSize: 16.0,)),
            ),

//,  and 
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("We can also perform",  style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'put': adds the given value to the respective field", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'remove': Removes everything from a field", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'modify': Erases the whole field and adds the given element", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Fields supported", style: TextStyle(fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'name': Patient Name", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'age': Patient age (only number required)", style: TextStyle( fontSize: 16.0,)),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'gender': Patient gender(male / female)", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'symptom': Symptoms", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'diagnosis': Diagnosis", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'prescription': Prescription", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("'advice': Advices", style: TextStyle( fontSize: 16.0,)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("(fields requiring multiple values should be added one by one)", style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700)),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text("Mobile number can't be typed through voice (as a security measure). Please input mobile number using keyboard.", style: TextStyle( fontFamily: 'Manrope', fontSize: 20.0, fontWeight: FontWeight.w700)),
            ),



          ] : [],
        ),
    ),
      ),
    );
  }

  bool uniqueIdTextError = false;
  @override
  Widget build(BuildContext context) {

    buildContextOfNewPatient = context;

    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        heroTag: "HelpForNewPatientAdd",
        backgroundColor: Colors.green.shade900,
        onPressed: () {
          isClicked = !isClicked;
          setState(() {
            
          });

        },
        child: Icon(Icons.help),
      ),
             
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
              child: Text("New Patient (or) Existing Patient Entry",
            textAlign: TextAlign.start,
              style: TextStyle(fontFamily: 'Manrope',
              
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.white
              ),
            ),

              ),


            AnimatedSize(
              curve: Curves.linear,
              vsync: this,
              key: Key("AnimationOfHelpCard"),
              duration: Duration(milliseconds: 100),
              child: showHelpCard(),
            ),

            
           



            Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: FloatingActionButton.extended(
             isExtended: true,
             elevation: 16.0,
             backgroundColor: isRecording ? Colors.red : Colors.green,
             onPressed: () {
              isRecording = !isRecording;
              if(isRecording) {
                _startRecording();
              } else {
                _stopRecording().whenComplete(() {

                  io.File file = new io.File(_recording.path);
                  var bytesData = file.readAsBytes();
                  bytesData.then((value) {
                    var base64String = base64.encode(value);
                    speechActivation(base64String).then((x) {
                      Map<String, dynamic> y = x.toJson();
                        totalTranscript = totalTranscript + "[DOCTOR]: " + y['queryResult']['queryText'] + "\n";
                        totalTranscript = totalTranscript + "[BOT]: " + y['queryResult']['fulfillmentText'] + "\n";
                        print(y.toString());
                        if(y['queryResult']['parameters'].toString().length < 3) {
                          print("Parameters null");
                          setState(() {
                            
                          });
                        } else {
                          print(y['queryResult']['parameters'].toString());
                          setState(() {
                            
                          });
                        }
                    });

                });





                  });
                  
                  setState(() {
                    isRecording = !isRecording;
                  });
                }
             }, 
             label: isRecording ? Text("Stop", style: TextStyle(
               fontFamily: 'Manrope',
               fontSize: 16.0,
               fontWeight: FontWeight.w700,
              ),
            ) : Text("Recognize", style: TextStyle(
               fontFamily: 'Manrope',
               fontSize: 16.0,
               fontWeight: FontWeight.w700,
              ),
            ),
            icon: isRecording ? Icon(Icons.stop) : Icon(Icons.record_voice_over),
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
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(
                            children: [

                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                            child: isRecording ? Icon(Icons.keyboard_voice): Icon(Icons.play_arrow),
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: isRecording ? Text("Listening", style: TextStyle(fontSize: 18.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),)
                            : Text("Ready to listen", style: TextStyle(fontSize: 18.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                          ),


                            ],
                          ),


                          Padding(
                            padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                            child: 
                             Text("", style: TextStyle(fontSize: 20.0, fontFamily: 'Manrope', fontWeight: FontWeight.w700),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            ),






            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Colors.grey.shade800,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.indigo,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: 
                        Text("Transcript", style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                            ),
                          ),


                        Text(totalTranscript, style: TextStyle(fontSize: 16.0, color: Colors.white,fontFamily: 'Manrope', fontWeight: FontWeight.w300),),

                        

                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),




            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 4.0,
              shadowColor: Colors.black,
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("Information", style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Manrope', fontWeight: FontWeight.w700,), textAlign: TextAlign.center,),
                    ),
                  ),


                          

                  
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [





                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            enabled: true,
                      controller: uniqueId, 
                      onChanged: (text) {
                        if(text.length < 3) {
                          uniqueId.value = TextEditingValue(
                            text: "DV-",
                            selection: TextSelection.fromPosition(
                              TextPosition(offset: 3),
                            ),
                          );
                        }
                      },
                      maxLength: 13,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        errorText: uniqueIdTextError ? "Need a value" : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Unique ID (Mobile number)"
                      ),
                    ),
                        ),






                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: patientNameController,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Patient Name"
                      ),
                    ),
                        ),






                          Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: patientAgeController,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Age"
                      ),
                    ),
                        ),





                          Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: patientGenderController,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Gender"
                      ),
                    ),
                        ),

                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                      controller: symptomsP,
                            maxLines: 5,
                      
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Symptoms (seperate by ,)"
                      ),
                    ),
                        ),



                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                      controller: diagnosisP,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Diagnosis (seperate by ,)"
                      ),
                    ),
                        ),




                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                      controller: prescP,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Prescription (seperate by ,)"
                      ),
                    ),
                        ),




                         Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            maxLines: 5,
                      controller: advicesP,
                      style: TextStyle(
                        fontFamily: 'Manrope',
              fontWeight: FontWeight.w700
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),),
                        prefixIcon: Icon(Icons.person),
                        labelText: "Advices (seperate by ,)"
                      ),
                    ),
                        ),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [


                          Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          color: Colors.green,
                          onPressed: () async {
                            writeOnPdf();
                            savePdf();
                            Directory documentDirectory = await getApplicationDocumentsDirectory();

                            String documentPath = documentDirectory.path;

                            String fullPath = "$documentPath/example.pdf";

                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => PdfPreviewScreen(path: fullPath,)
                            ));
                          },
                          child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Preview", style: TextStyle(color: Colors.white),),
                        ),
                        ),
                      ),



                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: RaisedButton(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          color: Colors.blue,
                          onPressed: () async {

                            if(uniqueId.text.split("-")[1].isEmpty || uniqueId.text.split("-").length == 1) {
                                uniqueIdTextError = true;
                                setState(() {
                                  
                                });
                            } else {

                                uniqueIdTextError = false;
                            writeOnPdf();
                            savePdf();
                            Directory documentDirectory = await getApplicationDocumentsDirectory();

                            String documentPath = documentDirectory.path;

                            String fullPath = "$documentPath/example.pdf";


                            showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Processing"),
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),

          ],
        ),
        
      ),
    );
                            final StorageReference ref =
                                FirebaseStorage.instance.ref().child('pdf').child('${firebaseUserThing.email}_${uniqueId.text}_$dateTime.pdf');
                            StorageUploadTask uploadTask = ref.putFile(
                              File(fullPath),
                              StorageMetadata(
                                contentLanguage: 'en',
                              ),
                            );

await (await uploadTask.onComplete).ref.getDownloadURL().then((value) {



                            Firestore.instance.collection('doctors').document(firebaseUserThing.email).collection('patients_operated').document(dateTime).setData({
                              'patient_uid': uniqueId.text,
                              'pdfLink': value.toString(),
                            }).then((xx) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  SendingFacilities(title: value.toString())));

                            });



    });

                            }




                            

                          },  
                          child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Proceed", style: TextStyle(color: Colors.white),),
                        ),
                        ),
                      ),
                        ],
                      ),


                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),


        ],
      ),
          ],
        ),
      ),
    );
  }



  writeOnPdf() async {
    

  


    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),

        build: (pw.Context context){
          return <pw.Widget>  [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[

                  pw.Padding(
                    padding: pw.EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
                    child: pw.Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          fit: pw.BoxFit.fill,
                          image: PdfImage.file(
                            pdf.document, 
                            bytes: imageForPdf,
                          ),
                        ),
                      ),
                    ),
                  ),


                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: <pw.Widget>[

                        pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 4.0),
                          child: pw.Text("Doctor's Name: ${firebaseUserThing.displayName}", 
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontSize: 16.0,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          ),
                        ),


                        pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 4.0),
                          child: pw.Text("Hospital Name: $hospitalName", 
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          ),
                          ),
                        ),


                        pw.Padding(
                          padding: pw.EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                          child: pw.Text("Email ID: ${firebaseUserThing.email}", 
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                          ),
                          ),
                        ),

                    ]
                  ),

              
                ]
              ),
            ),
            




            pw.Table(
              
              children: <pw.TableRow> [

                  pw.TableRow(
                    
                    children: <pw.Widget>[
                      
                      //Name

                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Name : ${patientNameController.text}"
                      ),
                      ),




                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Date & Time : $dateTime"
                      ),
                      ),


                      ///Date time
                      

                    ]
                  ),




                  pw.TableRow(
                    children: <pw.Widget>[
                      
                      //Age
                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Age / Gender : ${patientAgeController.text} / ${patientGenderController.text}"
                      ),
                      ),






                      pw.Padding(
                        padding: pw.EdgeInsets.all(8.0),
                        child: pw.Text("Unique ID : ${uniqueId.text}"
                      ),
                      ),


                      ///Gender
                      ///
                      ///
                      ///
                      ///Unique ID
                      

                    ]
                  ),



              ]
            ),


            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Symptoms", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),


            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${symptomsP.text}"),
            ),





            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Diagnosis", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),



            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${diagnosisP.text}"),
            ),



            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Prescription", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),


            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${prescP.text}"),
            ),



            pw.Header(
              level: 1,
              child: pw.Padding(
                padding: pw.EdgeInsets.all(8.0),
                child:  pw.Text("Advices", style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold,)),
              ),
            ),



            pw.Padding(
              padding: pw.EdgeInsets.all(8.0),
              child: pw.Text("${advicesP.text}"),
            ),






          ];
        },


      )
    );
  }

  Future savePdf() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(pdf.save());
  }







}
