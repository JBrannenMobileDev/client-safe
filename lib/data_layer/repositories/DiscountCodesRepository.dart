import 'dart:async';

import 'package:dandylight/data_layer/local_db/daos/DiscountCodesDao.dart';
import 'package:dandylight/models/Code.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/currentWeather/CurrentWeatherResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/forecastFiveDay/ForecastFiveDayResponse.dart';
import 'package:dandylight/models/rest_models/AccuWeatherModels/hourlyForecast/HourWeather.dart';
import 'package:dandylight/utils/UidUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../models/DiscountCodes.dart';
import '../../utils/StringUtils.dart';
import '../api_clients/AccuWeatherClient.dart';

class DiscountCodesRepository {
  Future<String> generateAndSaveCode(String type) async {
    DiscountCodes discounts = await DiscountCodesDao.getDiscountCodesByType(type);
    Code code = Code();
    code.id = StringUtils.generateRandomString(6);
    
    // check if discount type exist in firebase
    if(discounts == null) {
      List<Code> codeList = [];
      codeList.add(code);
      discounts = DiscountCodes(codes: codeList, type: type);
    } else {
      //Generate new codes until there is no duplicate
      while(await doesCodeAlreadyExist(code.id)) {
        code.id = StringUtils.generateRandomString(6).toUpperCase();
      }
      discounts.codes.add(code);
    }

    await DiscountCodesDao.insertOrUpdate(discounts);
    return code.id;
  }

  Future<bool> doesCodeAlreadyExist(String code) async {
    List<DiscountCodes> discounts = await DiscountCodesDao.getAll();
    List<Code> codes = [];
    discounts.forEach((discount) {
      codes.addAll(discount.codes);
    });

    return codes.map((item) => item.id.toUpperCase()).toList().contains(code.toUpperCase());
  }

  Future<String> getMatchingDiscount(String inputCode) async {
    String response = '';
    List<DiscountCodes> discounts = await DiscountCodesDao.getAll();
    List<Code> lifetimeCodes = [];
    List<Code> fiftyPercentCodes = [];
    discounts.forEach((discount) {
      if(discount.type == DiscountCodes.LIFETIME_FREE) {
        lifetimeCodes.addAll(discount.codes);
      }
      if(discount.type == DiscountCodes.FIFTY_PERCENT_TYPE) {
        fiftyPercentCodes.addAll(discount.codes);
      }
    });

    lifetimeCodes.forEach((code) {
      if(code.id.toUpperCase() == inputCode.toUpperCase() && (code.uid == null || code.uid.isEmpty)) {
        response = DiscountCodes.LIFETIME_FREE;
      }
    });

    fiftyPercentCodes.forEach((code) {
      if(code.id.toUpperCase() == inputCode.toUpperCase() && (code.uid == null || code.uid.isEmpty)) {
        response = DiscountCodes.FIFTY_PERCENT_TYPE;
      }
    });
    return response;
  }

  //Returns false if code is already assigned
  Future<bool> assignUserToCode(String code, String uid) async {
    bool result = false;
    List<DiscountCodes> discounts = await DiscountCodesDao.getAll();

    discounts.forEach((discount) {
      discount.codes.forEach((discountCode) async {
        if(discountCode.id.toUpperCase() == code.toUpperCase()) {
          if(discountCode.uid == null || discountCode.uid.isEmpty) {
            result = true;
            int matchingIndex = discount.codes.indexWhere((item) => item.id.toUpperCase() == discountCode.id.toUpperCase());
            if(matchingIndex != -1) {
              discount.codes[matchingIndex].uid = uid;
            }
            await DiscountCodesDao.update(discount);
            return result;
          } else {
            result = false;
          }
        }
      });
    });

    return result;
  }
}