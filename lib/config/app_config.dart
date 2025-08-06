import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static final String LOGIN_URL =
      "https://clustering.comtech-alliance.org/login.php";
  static final String USER_INFO_URL =
      "https://clustering.comtech-alliance.org/api/user/info";
  static final String REGISTER_URL =
      "https://clustering.comtech-alliance.org/register.php";
  static final String UPDATE_PROFILE_URL =
      "https://clustering.comtech-alliance.org/api/update/profile";
  static final String CHANGE_PASSWORD_URL =
      "https://clustering.comtech-alliance.org/api/change/password";
  static final String FORGOT_PASSWORD_URL =
      "https://clustering.comtech-alliance.org/api/forgot-password";
  static final String REGIONS_URL =
      "https://clustering.comtech-alliance.org/api/regions";
  static final String WARDS_URL =
      "https://clustering.comtech-alliance.org/api/districts/";
  static final String QUESTIONS_URL =
      "https://clustering.comtech-alliance.org/api/questions";
  static final String MILKS_URL =
      "https://clustering.comtech-alliance.org/api/milks";
  static final String ADD_MILK =
      "https://clustering.comtech-alliance.org/api/milks";
  static final String FEATURES_URL =
      "https://clustering.comtech-alliance.org/api/features";
  static final String POST_URL =
      "https://clustering.comtech-alliance.org/api/posts";
  static final String USER_FEATURES_URL =
      "https://clustering.comtech-alliance.org/api/get/features/users";
  static final String GET_CLUSTER_USERS =
      "https://clustering.comtech-alliance.org/api/users/clusters";
  static final String CLUSTER_URL =
      "https://clustering.comtech-alliance.org/api/clusters";
  static final String UPDATE_CHOICE_URL =
      "https://clustering.comtech-alliance.org/api/update/features/";
  static final String MESSAGE_URL =
      "https://clustering.comtech-alliance.org/api/cluster-chats";
  static final String SEND_MESSAGE_URL =
      "https://clustering.comtech-alliance.org/api/send/message";

  static Future<String?> getAccessToken() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    String? accessToken = _sharedPreferences.getString("access_token");
    return accessToken;
  }
}
