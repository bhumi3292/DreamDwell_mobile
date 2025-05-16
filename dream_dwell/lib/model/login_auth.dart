

class LoginAuth {
  static bool authenticate({
    required String email,
    required String password,
    required String? stakeholder,
  }) {
    return email == 'admin' &&
        password == 'admin123' &&
        stakeholder != null;
  }
}

