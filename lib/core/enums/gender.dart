enum Gender {
  male, female, preferNotToSay;

  String get label => switch (this) {
    Gender.male => "Male",
    Gender.female => "Female",
    Gender.preferNotToSay => "Prefer not to say",
  };
}
