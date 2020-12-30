class Validator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }
}
