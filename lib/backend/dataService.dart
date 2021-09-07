import 'package:flutter/material.dart';
import 'package:gesk_app/core/colors.dart';
import 'package:gesk_app/models/car.dart';
import 'package:gesk_app/models/park.dart';
import 'package:gesk_app/models/reservation.dart';
import 'package:gesk_app/models/tpa.dart';
import 'package:gesk_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class DataService {
  final String _setInfoUrl = "https://www.erenkomurcu.com/setInfo/";
  final String _getInfoUrl = "https://www.erenkomurcu.com/getInfo/";

  Future<User> registerUser(
      {String name, String password, String phone, String mail}) async {
    Uri _uri = Uri.parse(_setInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "register": {
        "name": name,
        "password": password,
        "phone": phone,
        "mail": mail
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _user = User.fromJson(_responseJson["register"]);

    return _user;
  }

  Future<Car> addCar(
      {String userId,
      String plate,
      String modelYear,
      String color,
      String size}) async {
    Uri _uri = Uri.parse(_setInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "addCar": {
        "ownerId": int.parse(userId),
        "plate": plate,
        "modelYear": modelYear,
        "color": color,
        "carSize": size
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _car = Car.fromJson(_responseJson["addCar"]);

    return _car;
  }

  Future<String> deleteCar({int carId}) async {
    Uri _uri = Uri.parse(_setInfoUrl);

    Map<String, dynamic> _payloadBody = {
      "deleteCar": {"carId": carId}
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    return _responseJson["deleteCar"];
  }

  Future<Car> editCar(
      {int carId,
      String plate,
      String modelYear,
      String color,
      String carSize}) async {
    Uri _uri = Uri.parse(_setInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "editCar": {
        "carId": carId,
        "plate": plate,
        "modelYear": modelYear,
        "color": color,
        "carSize": carSize
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _car = Car.fromJson(_responseJson["editCar"][0]);

    return _car;
  }

  Future<Park> addPark(
      {int userId,
      bool isClosedPark,
      bool isWithCam,
      bool isWithSecurity,
      bool isWithElectricity,
      String name,
      double price,
      int status,
      int parkSpace,
      int filledParkSpace,
      double longitude,
      double latitude,
      String location}) async {
    Uri _uri = Uri.parse(_setInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "addPark": {
        "ownerId": userId, //TODO: Bütün ıd ler int olcak
        "isClosedPark": isClosedPark,
        "isWithCam": isWithCam,
        "isWithSecurity": isWithSecurity,
        "isWithElectricity": isWithElectricity,
        "name": name,
        "status": 0,
        "parkSpace": 1,
        "filledParkSpace": 0,
        "longtitude": longitude,
        "latitude": latitude,
        "location": location
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);
    var _responseJson = convert.jsonDecode(_response.body)["addPark"] as List;

    if (_responseJson.first is String) {
      print(_responseJson.first);
    } else {
      
    List<Park> _parks = List<Park>();

    _responseJson.forEach((element) {
      _parks.add(Park.fromJson(element));
    });

    var _park = _parks.last;

    return _park;
    }
  }

  Future<String> deletePark({
    int parkId,
    @required BuildContext context,
  }) async {
    Uri _uri = Uri.parse(_setInfoUrl);

    Map<String, dynamic> _payloadBody = {
      "deletePark": {"parkId": parkId}
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    return _responseJson["deletePark"];
  }

  Future editPark(
      {@required BuildContext context,
      String userId,
      String parkId,
      bool isClosedPark,
      bool isWithCam,
      bool isWithSecurity,
      bool isWithElectricity,
      String name,
      double price,
      int status,
      int parkSpace,
      int filledParkSpace,
      double longitude,
      double latitude,
      String location}) async {
    Uri _uri = Uri.parse(_setInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "editPark": {
        "parkId": int.parse(parkId),
        "ownerId": int.parse(userId),
        "isClosedPark": isClosedPark,
        "isWithCam": isWithCam,
        "isWithSecurity": isWithSecurity,
        "isWithElectricity": isWithElectricity,
        "name": name,
        "price": price,
        "status": status,
        "parkSpace": parkSpace,
        "filledParkSpace": filledParkSpace,
        "longitude": longitude,
        "latitude": latitude,
        "location": location,
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    if (_responseJson["editPark"] is String) {
      Navigator.pop(context);
      showBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(color: yellow100),
              child: Text(_responseJson["login"]),
            );
          });
    } else {
      var _park = Park.fromJson(_responseJson["editPark"]);

      return _park;
    }
  }

  Future login(
      {String phoneNumber,
      String password,
      @required BuildContext context}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "login": {
        "password": password,
        "phoneNumber": phoneNumber,
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    if (_responseJson["login"] is String) {
      Navigator.pop(context);
      showBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(color: yellow100),
              child: Text(_responseJson["login"]),
            );
          });
    } else {
      var _user = User.fromJson(_responseJson["login"]);

      return _user;
    }
  }

  Future<List<Car>> getCars({List<int> carsId}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "getUserCars": {
        "carsId": carsId,
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _carsJson = _responseJson["getuserCars"] as List;

    List<Car> _cars =
        _carsJson.map((carJson) => Car.fromJson(carJson)).toList();

    return _cars;
  }

  Future<Car> getCar({String carId}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "getCar": {
        "carId": int.parse(carId),
      }
    };
    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _car = Car.fromJson(_responseJson["getCar"][0]);

    return _car;
  }

  Future<User> getUser({int userId}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "getUser": {
        "userId": userId,
      }
    };
    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _user = User.simpleFromJson(_responseJson["getUser"][0]);

    return _user;
  }

  Future<Park> getPark({int parkId}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "getPark": {
        "parkId": parkId,
      }
    };
    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _park = Park.fromJson(_responseJson["getPark"][0]);

    return _park;
  }

  Future<bool> confirm({int userId}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "confirm": {
        "userId": userId,
      }
    };
    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _status = _responseJson["confirm"]["status"];

    return _status;
  }

  Future<Map<String, dynamic>> getUserInstance({int userId}) async {
    Uri _uri = Uri.parse(_getInfoUrl);
    Map<String, dynamic> _payloadBody = {
      "getUserInstance": {
        "userId": userId,
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _refcars = _responseJson["getUserInstance"]["cars"] as List;
    List<Car> _cars = List<Car>();
    List<Park> _parks = List<Park>();
    var _refparks = _responseJson["getUserInstance"]["parks"] as List;

    _refcars.forEach((element) {
      _cars.add(Car.fromJson(element));
    });
    _refparks.forEach((element) {
      _parks.add(Park.fromJson(element));
    });

    Map<String, dynamic> _result = {"cars": _cars, "parks": _parks};
    return _result;
  }

  Future<Tpa> addTpa(
      {int parkId,
      String tpaName,
      double hourlyPrice,
      String maxCarSize}) async {
    Uri _uri = Uri.parse(_setInfoUrl);

    print(parkId);
    print(tpaName);
    print(hourlyPrice);
    print(maxCarSize);

    Map<String, dynamic> _payloadBody = {
      "addTpa": {
        "parkId": parkId,
        "tpaName": tpaName,
        "hourlyPrice": hourlyPrice,
        "maxCarSize": maxCarSize
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    return Tpa.fromJson(_responseJson["addTpa"][0]);
  }

  Future<Tpa> editTpa(
      {int tpaId,
      int parkId,
      String tpaName,
      double hourlyPrice,
      String maxCarSize}) async {
    Uri _uri = Uri.parse(_setInfoUrl);

    Map<String, dynamic> _payloadBody = {
      "editTpa": {
        "tpaId": tpaId,
        "parkId": parkId,
        "tpaName": tpaName,
        "hourlyPrice": hourlyPrice,
        "maxCarSize": maxCarSize
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    return Tpa.fromJson(_responseJson["editTpa"]);
  }

  Future<String> deleteTpa({int tpaId}) async {
    Uri _uri = Uri.parse(_setInfoUrl);

    Map<String, dynamic> _payloadBody = {
      "deleteTpa": {
        "tpaId": tpaId,
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    return _responseJson["deleteTpa"];
  }

  Future<List<Tpa>> getTpas(int parkId) async {
    Uri _uri = Uri.parse(_getInfoUrl);

    Map<String, dynamic> _payloadBody = {
      "getTpas": {
        "command": "partial",
        "parkId": parkId,
      }
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    var _ref = _responseJson["getTpas"] as List;

    List<Tpa> _tpas = List<Tpa>();

    _ref.forEach((element) {
      _tpas.add(Tpa.fromJson(element));
    });

    return _tpas;
  }

  Future getNearParks({double lat, double lng}) async {
    List<Park> _parks = List<Park>();
    Uri _uri = Uri.parse(_getInfoUrl);

    Map<String, dynamic> _payloadBody = {
      "getParksWithDistance": {"lat": lat, "lon": lng, "range": 500}
    };

    var _postJson = convert.jsonEncode(_payloadBody);

    var _response = await http.post(_uri, body: _postJson);

    var _responseJson = convert.jsonDecode(_response.body);

    if (_responseJson["getParksWithDistance"] is String) {
      print(_responseJson["getParksWithDistance"]);
    } else {
      var _ref = _responseJson["getParksWithDistance"] as List;
      _ref.forEach((element) {
        _parks.add(Park.fromJson(element));
      });
      return _parks;
    }
  }
}
