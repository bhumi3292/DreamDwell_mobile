

class LoginAuth {
  static bool authenticate({
    required String email,
    required String password,
    required String? stakeholder,
  }) {
    return email == 'admin123@gmail.com' &&
        password == 'admin123' &&
        stakeholder != null;
  }
}

