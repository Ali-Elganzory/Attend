String validateHours(String hour) {
  if (hour.trim().isEmpty) return "Empty";
  if (int.parse(hour) > 23) return "Max is 23";
  return null;
}
