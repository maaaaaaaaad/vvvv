class SignUpRequest {
  final String businessNumber;
  final String phoneNumber;
  final String nickname;
  final String email;
  final String password;

  const SignUpRequest({
    required this.businessNumber,
    required this.phoneNumber,
    required this.nickname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessNumber': businessNumber,
      'phoneNumber': phoneNumber,
      'nickname': nickname,
      'email': email,
      'password': password,
    };
  }
}
