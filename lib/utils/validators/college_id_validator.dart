String validateCollegeId(String collegeId) {
  if(collegeId.trim().length != 7) {
    return "College id must be 7 characters";
  }
  return null;
}