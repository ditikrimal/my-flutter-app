import 'package:email_otp/email_otp.dart';

EmailOTP SendOTP(String email) {
  EmailOTP myauth = EmailOTP();
  myauth.setSMTP(
      host: "smtp.gmail.com",
      auth: true,
      username: "rml.ditik69@gmail.com",
      password: "puoorapmqqunupdh",
      secure: "TLS",
      port: 587);

  myauth.setConfig(
      appEmail: "rml.ditik69@gmail.com",
      appName: "My Notes",
      userEmail: email,
      otpLength: 6,
      otpType: OTPType.digitsOnly);
  if (myauth.sendOTP() == true) {
    return myauth;
  }
  return myauth;
}
