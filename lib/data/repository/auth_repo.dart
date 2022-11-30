import 'package:fooddelivery_backend/models/signup_body.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_constants.dart';
import 'package:fooddelivery_backend/utils/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences
  });
  
  Future<Response> registration(SignUpBody signUpBody)async{
    return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<String> getUserToken()async{
    return await sharedPreferences.getString(AppConstants.TOKEN)??"NONE";
  }

  Future<Response> login(String phone,String password)async{
    return await apiClient.postData(AppConstants.LOGIN_URI, {"phone": phone,"password":password});
  }

  Future<bool> saveUserToken(String token)async{
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<void> saveUserNumberAndPassword(String number,String password) async{
    try{
      await sharedPreferences.setString(AppConstants.PHONE, number);
      await sharedPreferences.setString(AppConstants.PASSWORD, password);
    }catch(e){
      throw e;
    }
  }

  bool clearShareData(){
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PASSWORD);
    sharedPreferences.remove(AppConstants.PHONE);
    apiClient.token='';
    apiClient.updateHeader('');
    return true;
  }

}