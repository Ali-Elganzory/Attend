String validateClassroomCode(String code) {
  if (code.trim().length != 20) return "Code must be 20 characters.";
  return null;
}
