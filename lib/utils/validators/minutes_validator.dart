String validateMinutes(String minute) {
  if (minute.trim().isEmpty) return "Empty";
  if (int.parse(minute) > 59) return "Max is 59";
  return null;
}
