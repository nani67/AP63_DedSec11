import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:googleapis/dialogflow/v2.dart';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';


/**
 * 
 * 
 * 
 * 
 * 
 * 
 * curl -X POST \
     -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
     -H "Content-Type: application/json; charset=utf-8" \
     --data "{
  'config': {
    'encoding': 'LINEAR16',
    'sampleRateHertz': 16000,
    'languageCode': 'en-US',
    'enableWordTimeOffsets': false
  },
  'audio': {
    'content': '/9j/7QBEUGhvdG9zaG9...base64-encoded-audio-content...fXNWzvDEeYxxxzj/Coa6Bax//Z'
  }
}" "https://speech.googleapis.com/v1/speech:recognize"
  
 */




final _credentials = new ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "smart-india-hackathon-2020",
  "private_key_id": "96c04011ffe705adec6876d3efb1a365a1919995",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC3iB2AMGRIHG/h\nswzyxaz1Ndo9MCXXv3v7PiX8MKIZ031YD5YKHEaDtqTBWpIpSh8XGa2Wx0L2jR8d\nmLn3LKY2k93Xv21pbyYcUPQ9jIcH74qgYK2lg1mjfcIZRR1okWBtsTFPpSbhLXUu\nzdZvsrm4LH3kKWL9g94M5OhjwAVPPn7Q2V1eJqWX2RCXlNtagtyAMrzWQuhN2KeI\nn3qiMFk8Oy39+wiF8fB6saWfgvc/FDyXFIcR+b40LesT9rWMpMFpiBVNTzu2tlGG\nvkeN/5nnGgSaRRjNK6VRrh2vV9L/4c2YK+jIQe8zo1Io7JcJaZCsBYtd6HJqD5Nd\ncy+CNP5zAgMBAAECggEAGI2+zfgWFSmsyYgaqt4fD2fm1yR6Y5ysGcb3mP+T/Zre\n8ZRAPAEKvrNa471aFukM3hp4MAG05+b7FeAUEnP9lrP99s/BnlyZlNSQddg3oSxU\nd7QHd0BqkntlfNuoyA/EVAM5OCZoXFwoXxx4XFWPut/vmxdIYDyvTTqmC+D+34TK\n/0MBrT3E1KA2aTX3rByN7+JJBdquugnLmpMg47pi5JP1WfIDTLO98CML2B2xb2fo\n0YptK+RN6hfcGd2l6hrBYk6JeDkyU8b0Fm7tuv4Wf//5itLDij3DxamG+5nZ1FYv\nAOZJBgqqkvpDrSF5s23Zr3ns2Vh3Yr3JGqGEsfkZVQKBgQDkTLvKbv/NHaPt8KtH\nrTcRscpwy25PsO31e3rC1xgywrotky5IviJmzQrFcDH5jnPVfsIauYebonTovgzG\n8nby/UP6C2uSOCj0PntkfJCs24p5DQO97Q6La3yvCMuegy6SH2vvJ5go2JeWCj4Z\n/eVP1+iRTnnWiiIoHNj2MA8n3QKBgQDNzNUGRa91kY8+OL+YFV6JIgNiDGLzo86I\n/RjwD7Xgk5dq8VT1bMVw6ZwSud9mpJAQoK6vuW5tf4tFLU/kSINXVWvTn4Qy7apT\n2FJqVBULzqK/BzqtdfdtFJ0LrTRo5q/pzu7R8X3FRqfwDQg1PbXxu3yTMGlMQuSF\n5wo8aUYCjwKBgQCGjRbskwjd+ccguAQqhVL8cb1vRuYnv44vbOwIIz8Ww594ttLD\nepPJ5LShcqNxglyQilmZ6JicyF2AwmnDYylpwoyqtMpcbg7tDFoq+iNGTUnKWDpJ\nWIqG7v2YJ2XicUwkQLKbS8mo4SZN/pFlPjdFHGnsIcU7BURmQcI5Lk/wXQKBgF2Q\nCS0v00RNJ+Vu4VQgKvmHeChEX1xLFaPcBVFmoxZ1ozpge3KUv/LEkktFK9a7bC/T\nDXgggp7PhJ6vqgmsGeJDmKD+fZi1ymESEO38ShEzIXRdsgSYhCOYYomjdhdXAZT3\nmkXiV36vz7voANpLswMybMFyGf0s0D48OsAaUFTrAoGBAKbms8IoPZa7evb9fC3H\njRWELzhrsGwJzXsXT9q8ZvoUfiXDNdBdmql0msI0F+1rx1KAu1cVnMVtQcnbAJl7\n6JxlH8M8obGUJy6dRLodbxlaLXiJezf+iRgpLjJqLiBt72/RBB/ZglXfWwJ4Vak+\nG6nwf1jvKIFlJBq+bdxhBS6L\n-----END PRIVATE KEY-----\n",
  "client_email": "dialogflow-grfjjk@smart-india-hackathon-2020.iam.gserviceaccount.com",
  "client_id": "107468111272121389431",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dialogflow-grfjjk%40smart-india-hackathon-2020.iam.gserviceaccount.com"
}
''');

const _SCOPES = const [SpeechApi.CloudPlatformScope];

void speechActivation(String audioString) {  

  clientViaServiceAccount(_credentials, _SCOPES).then((http_client) {
    var x = new DialogflowApi(http_client);
    final session = "projects/smart-india-hackathon-2020/agent/sessions/123456789:detectIntent";
     // `data:audio/webm;codecs=opus;base64,
    final _json = {
  "queryInput": {
    "audioConfig": {
      "languageCode": "en-US"
    }
  },
  "inputAudio": "$audioString"
};

final _requestObj = GoogleCloudDialogflowV2DetectIntentRequest.fromJson(_json);
x.projects.agent.sessions.detectIntent(_requestObj, session).then((value) {
  
        print(value.toJson().toString());
});
  });
}