String validateEmail(String email) {
  if (!email.contains('@')) return "Please, enter a valid email.";
  if (email.lastIndexOf('@') > email.lastIndexOf('.'))
    return "Please, enter a valid email.";
  if (email.lastIndexOf('@') != email.indexOf('@'))
    return "Please, enter a valid email.";
  if (email.length < 10) return "Email is too short.";
  if (email.indexOf('@') == 0 || email.lastIndexOf('.') == email.length - 1)
    return "Please, enter a valid email.";

  return null;
}
