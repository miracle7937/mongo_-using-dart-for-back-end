
import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

class PeopleController{
  HttpRequestBody _requestBody;
  HttpRequest request;
  DbCollection store;
  PeopleController(this._requestBody,Db db):
      request=_requestBody.request,
      store = db.collection('people'){
    HandleTrascation();
  }

  void HandleTrascation() async {
    switch(request.method){
      case 'GET':
        await getHandler();
        break;
      case 'POST':
        await postHandler();
        break;
      case 'PUT':
        await putHandler();
        break;
      case 'DELETE':
        await deleteHandler();
        break;
      case 'PATCH':
        await patchHandler();
        break;
        default:
          request.response.statusCode= 450;

    }
  }

  void getHandler() async{
    request.response.write(await store.find().toList());
  }

  void postHandler() async{
    request.response.write(await store.save(_requestBody.body));
  }

  void putHandler()async {
var id = int.parse(request.uri.queryParameters['id']);
var itemToadd =await store.findOne(where.eq('id', id));
if(itemToadd==null){
request.response.write(await store.save(_requestBody.body)
);
}else{
 request.response.write( await store.update(itemToadd, _requestBody.body));
}
  }

  void deleteHandler() async{
    var id = int.parse(request.uri.queryParameters['id']);
    var itemToadd =await store.findOne(where.eq('id', id));
    if(itemToadd==null){
      request.response.write(await store.remove(itemToadd));
    }
  }

  void patchHandler()async{
    var id = int.parse(request.uri.queryParameters['id']);
    var itemToadd =await store.findOne(where.eq('id', id));
     request.response.write(await store.update(itemToadd,  {
       r'$set': _requestBody.body
     }));

  }
}