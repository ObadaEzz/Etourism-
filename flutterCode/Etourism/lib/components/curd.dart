// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_tourism/components/statusrequest.dart';
import 'package:path/path.dart';
import 'package:dartz/dartz.dart';

getRequest(String url, [Map<String, String>? map]) async {
  try {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var responsebody = jsonDecode(response.body);
      return responsebody;
    } else {
      print("Error ${response.statusCode}");
    }
  } catch (e) {
    print("Error Catch $e @@ $url");
    debugPrint("Error Catch $e @@ $url");
  }
}

Future<dynamic> postRequest(String url, Map<String, dynamic> data) async {
  try {
    print(json.encode(data));
    print('Uri ${Uri.parse(url)}');

    var response = await http.post(Uri.parse(url), body: data);

    print('Response statusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print('Response body: $responseBody');
      return responseBody;
    } else {
      print("Error ${response.statusCode}");
      return response.statusCode;
    }
  } catch (e) {
    print("Error Catch postRequest: $e @@ $url");
    return "Error: $e";
  }
}

postRequestWithFile(String url, Map data, File file) async {
  // print("postRequestWithFile");
  // print(Uri.parse(url));
  // print(data);
  // print("the file is : $file");
  var request = http.MultipartRequest("POST", Uri.parse(url));
  // print('request $request');
  var stream = http.ByteStream(file.openRead());
  // print("stream $stream");
  //var myFileName = basename(file.path);
  // print("myFileName $myFileName");

  // print("length began ...");
  var length = await file.length();
  // print("length $length");
  var multiRequestFile =
      http.MultipartFile("file", stream, length, filename: basename(file.path));
  // var multiRequestFile =
  //     await http.MultipartFile.fromPath("file", file.path);
  request.files.add(multiRequestFile);
  data.forEach((key, value) {
    request.fields[key] = value;
  });
  // print("data $data");
  var myrequest = await request.send();
  var response = await http.Response.fromStream(myrequest);

  if (myrequest.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Error ${myrequest.statusCode}');
  }
}

Future<Either<StatusRequest, Map>> postData(String linkurl, Map data) async {
  // if (await checkInternet()) {
  if (true) {
    print("check internet is true");
    var response = await http.post(Uri.parse(linkurl), body: data);
    print(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map responsebody = jsonDecode(response.body);
      print(responsebody);
      return Right(responsebody);
    } else {
      return const Left(StatusRequest.serverfailure);
    }
    // ignore: dead_code
  } else {
    print("check internet is false");
    return const Left(StatusRequest.offlinefailure);
  }
}
