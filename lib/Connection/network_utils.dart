import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkUtils {
  static String productionHost =  'knowy-bot.herokuapp.com';
  static String developmentHost = 'mongodb://mineriaacm:Mineria2019@mineriacluster-shard-00-00-wri2f.mongodb.net:27017,mineriacluster-shard-00-01-wri2f.mongodb.net:27017,mineriacluster-shard-00-02-wri2f.mongodb.net:27017/mineria?ssl=true&replicaSet=MineriaCluster-shard-0&authSource=admin&retryWrites=true&w=majority';
  static String host = developmentHost;
  bool developer = false;

  final JsonDecoder _decoder = new JsonDecoder();

  Map<String, String> headers = {"content-type": "application/json", "Access-Control-Allow-Credentials": "true"};
  Map<String, String> cookies = {};

  NetworkUtils() {
    determinar_ambiente();
  }

  void determinar_ambiente() async {
    if (developer) {
      host = developmentHost;
    } else {
      host = productionHost;
    }
  }

  void _updateCookie(http.Response response) {
    String allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        this.cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += key + "=" + cookies[key];
    }

    return cookie;
  }

  void deleteCookies() {
    cookies = {};
  }

  void deleteHeaders(key) {
    headers.remove(key);
  }

  void addHeaders(String name, String value) {
    headers[name] = value;
  }

  Future<dynamic> get(String url, {params}) {
   var uri = buildUri(url, params: params);
   // addHeaders(HttpHeaders.authorizationHeader,"dAgRtbr2rua23BhdGRHiTg");
    return http.get(uri, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      //_updateCookie(response);

      if (statusCode < 200 || statusCode > 400 && res != null) {
        var msg = handleError(res);
        throw new Exception(msg);
      }
      if (res == null) {
        throw new Exception("Error desconocido");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,{body, encoding, params, jsonBody}) {
    var uri = buildUri(url, params: params);

    return http
        .post(uri, body: jsonBody, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      //_updateCookie(response);

      if (statusCode < 200 || statusCode > 400 && res != null) {
        var msg = handleError(res);
        throw new Exception(msg);
      }
      if (res == null) {
        throw new Exception("Error desconocido");
      }

      return _decoder.convert(res);
    });
  }

  Future<dynamic> post2(String url, {body, encoding, params}) {
    var uri = Uri.http('192.168.43.4:5000', url, params);
    var client = new HttpClient();
    client.post('192.168.43.4', 5000, '/general');
    //client.get(new Uri.http("locahost:8000", "/category"));
    return http
        .post(uri, body: jsonEncode(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode >= 400 && res != null) {
        var msg = handleError(res);
        throw new Exception(msg);
      }
      if (res == null) {
        throw new Exception("Error desconocido");
      }

      return _decoder.convert(res);
    });
  }
  Future<dynamic> postAnotherUrl(String url,{body, encoding, params, jsonBody})async {
   // var uri = buildUri(url, params: params);
    //var socket = await WebSocket.connect('ws://192.168.43.4:5000/general');
    //socket.add(jsonBody);
    var UriAddress = Uri.https("192.168.43.4:5000", url, params);
    return http
        .post(UriAddress, body: jsonBody, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      //_updateCookie(response);

      if (statusCode < 200 || statusCode > 400 && res != null) {
        var msg = handleError(res);
        throw new Exception(msg);
      }
      if (res == null) {
        throw new Exception("Error desconocido");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> update(String url, {body, encoding, params}) {
    var uri = buildUri(url, params: params);

    return http
        .patch(uri, body: jsonEncode(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      //_updateCookie(response);

      if (statusCode < 200 || statusCode > 400 && res != null) {
        var msg = handleError(res);
        throw new Exception(msg);
      }
      if (res == null) {
        throw new Exception("Error desconocido");
      }

      return _decoder.convert(res);
    });
  }


  Future<dynamic> delete(String url, {params}) {
    var uri = buildUri(url, params: params);

    return http.delete(uri, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

     // _updateCookie(response);

      if (statusCode < 200 || statusCode > 400 && res != null) {
        var msg = handleError(res);
        throw new Exception(msg);
      }
      if (res == null) {
        throw new Exception("Error desconocido");
      }
      return _decoder.convert(res);
    });
  }

  Uri buildUri(url, {params}) {
    if (!developer) {
      return params != null
          ? Uri.https(host, url, params)
          : Uri.https(host, url, params);
    } else {
      return params != null
          ? Uri.http(host, url, params)
          : Uri.http(host, url, params);
    }
  }

  showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    if (scaffoldKey != null) {
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(message ?? 'You are offline'),
      ));
    }
  }

  /**
   * decodifica el formato json de error q por defecto manda spring framework
   */
  handleError(String res) {
    var error = _decoder.convert(res);
    var msg = 'Error desconocido';
    try {
      if (error.containsKey('message')) {
        var temp = error['message'];
        if (temp is String) {
          msg = temp;
        }
      }
    } catch (e) {}
    return msg;
  }
}
