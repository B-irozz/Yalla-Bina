class EndPoints {
  static const String baseUrl = "https://authchatapp-production.up.railway.app";
  static const String socketUrl = "wss://exammatchingapp-production.up.railway.app";

  /// end points
  static const String signup = "/auth/signup";
  static const String verifyRegister = "/api/verify";
  static const String reSendCodeRegister = "/api/verify/code";
  static const String login = "/auth/login";
  static const String forgetPassword = "/auth/forgetPasswordOTP";
  // static const String checkForgetCode = "/auth/resetPasswordOTP";
  static const String resetPassword = "/auth/resetPasswordOTP";

  static const String editPassword = "/api/auth/profile/change-password";
  static const String editProfileData = "/api/auth/profile";
  static const String logout = "/api/auth/logout";
  static const String verifyEmail = "/auth/confirmOTP";
}