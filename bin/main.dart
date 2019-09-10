import 'dart:io';
import 'package:mongo_db/mongo_db.dart' as mongo_db;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:http_server/http_server.dart';
import 'package:mongo_db/peoplemanager.dart';
main(List<String> arguments) async {
  Db db =  Db("mongodb://localhost:27017/mydb");
  await db.open();
  print('database connected');

  var coll = db.collection('people');
var port =8988;
var server = await HttpServer.bind('localhost', port);
            server.transform(HttpBodyHandler()).listen((HttpRequestBody requestBody){
              if(requestBody.request.uri.path=='/'){
              var res=  requestBody.request.response..write('hello world');
                res.close();
              } else if (requestBody.request.uri.path=='/people'){

                PeopleController(requestBody,db);
              }

            });


print(await coll.find().toList());

}
