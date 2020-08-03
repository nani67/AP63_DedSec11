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
  "project_id": "apple-e53bb",
  "private_key_id": "b46287c59024ff171ef015318a169f7a65614ba0",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCSwXGiueWi7GpW\nQUAOVEM5t9iog3pHDNRguV2MtFOAubhXa8BH5cyc8ouNBsl4ZLgT1jUtAwLilAkv\nLIR7S3oLcX2yV0E6QwK88H3MiiCXbu8dO42sZF2UMV3El0nBFWWTso7J4cqhKe72\nn/yqrGeFK5VjHJZkkIxV4IBNwOTg+YAkej4q6NfsAu6Lqr/pv9b6WhOUxlaQZ+8N\n6WShD4005fJHlISqx3ejPH9aXyfEwbKo3Jf4uXMuGesFq40KlfAs+qxbs/7QaGsx\nu8DL4IizMvcJhGx10aePMDz4DmMFJweluMqeVJTveIBrLdNicgkRkIrYQV+bnEsG\nN3BFX3tjAgMBAAECggEARDVcl4FHVd4D3msdVoubYywrqsbRAkzYOMxuyoLVfLLV\nFuyhxcjsvNWOPtG0uhw14iJhPLZ1lNGxIxfRy2xdIQxym30qd+XFVAOCtJpOY5PP\n1wpi4okTZVk8d67JPNCxEWCgNPyYrSdMRZw+VyUiSCblm9chn0P/tbpOZ9ULi/Q2\nemfLArKQpJZzcMDsgffzzfVXypWcau47/FU647zKgaJvZAuMkSW4EqF0bo0Op8ae\nvfxH6qGAHDanZX/SvozLRgYtRyyUIquRTyJNdCg3DrolcbibmSckZnJZo19aFhOT\ndHIio8+DrvrkvOGS91KmSusE37gu53x6CrludxCVYQKBgQDG3/kXnI1Ahg+H285s\nF83lmMhS4tME0qTEqbrz7clWG5z4sXTzFIffmZMSZTlenvlTe/PGJ3r/F7GpHqa0\nfZDZKz92Gd9G2EjxsSvdtfjIBMaIzfH9ae68EW++BYymTYT5pLztV1zQod4hjjN0\nY/U7Eo2ufoWplc8a4FzW0T/kTQKBgQC86PGoXgkh4JiqkW71Oo9cRRXbL8U0OGDG\ndR1V1Nx33Cjtss7qEDHeGCwBWMdGmjloUHxAZUj8hywEezaH8utj981FReISGuLl\nOYfhjVXkMNEuj8R6zEIlb1++M53DIFa0RxBPzAJcVfPDSBlEZRNdkJleoV0wbZXF\n43aK7TB2bwKBgQCleHuoIrEAi8rmToRNOe0t6NZc6K+NJrrDizmrdiD8TVNpNTXK\nfz2iVQSi3KhES1/GD69AI19aWluPDJrGOGfJ2gsed95n8tOWjcSi36LUwexyrXB4\nWqixwIxJ/hIN2RgYIvKzQ+pNCTFqmAfGAtlrQj+yfUE3XheJFD8K2eYgTQKBgQCn\nBTF7kcBzQlbYH4NBr8fGZZJgW0j41YvCixMnqu5Nzsok9n14dl8QpMBrZGmzo3F0\nKAzjBmnUU1J4l9NruTujBBlp0NKC/WB0GDxqEALLoNmhWBz4ERW+cUzuJkaqmTHv\nbBEg7Bd+OcQueNVWIiNQCyN+hh6VTZ4o+uX5CKJbYwKBgCyKFZLksuIlglc/4ape\nDmw05uhxlvRwO5gwO+T/ozjilp6MTltpVMmtM5WC5ukV5r5VL3DTHXOSpMejhG3C\nf1zl9CQeEID21HMOsjVGAMG4MLR1yscOdQUx6DzG83LT9ezdD5+2ooppMxa0BEPo\nOkNF1pHr2RNwEKAEFdBiA6dn\n-----END PRIVATE KEY-----\n",
  "client_email": "dialogflow-khondy@apple-e53bb.iam.gserviceaccount.com",
  "client_id": "112415079515698420561",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/dialogflow-khondy%40apple-e53bb.iam.gserviceaccount.com"
}
''');

const _SCOPES = const [SpeechApi.CloudPlatformScope];
Map<String, dynamic> jsonObject;

Future<GoogleCloudDialogflowV2DetectIntentResponse> speechActivation(String audioString) async {  

  var jsonObj = clientViaServiceAccount(_credentials, _SCOPES).then((http_client) async {
    var x = new DialogflowApi(http_client);
    final session = "projects/apple-e53bb/agent/sessions/123456789:detectIntent";
    final _json = {
      "queryInput": {
        "audioConfig": {
          "languageCode": "en-US",
        }
      },
        "inputAudio": "$audioString"
      };

    final _requestObj = GoogleCloudDialogflowV2DetectIntentRequest.fromJson(_json);
    var obj = await x.projects.agent.sessions.detectIntent(_requestObj, session);
    return obj;
  });

  return jsonObj;
}