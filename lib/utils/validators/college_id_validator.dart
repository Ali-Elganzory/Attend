String validateCollegeId(String collegeId) {
  if (collegeId.trim().length < 5) {
    return "College id must be 4 characters at least";
  }
  return null;
}
