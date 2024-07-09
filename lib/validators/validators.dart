class Validators {
  String? validateEmail({required String email}) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return "Email Field cannot be empty";
    } else if (!emailRegExp.hasMatch(email)) {
      return "Enter valid Email address";
    }
    return null;
  }

  String? validatePassword({required String password}) {
    if (password.isEmpty) {
      return "Password can't be empty";
    } else if (password.length < 6) {
      return "Invalid Password! Please retry";
    }

    return null;
  }

  String? validateName({required String name}) {
    if (name.isEmpty) {
      return "Enter your name";
    } else if (name.length < 3) {
      return "Nice name, but should be at least 3 chars long";
    }
    return null;
  }
}
