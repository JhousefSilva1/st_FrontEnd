class StPersonRequest {
  final String PersonName;
  final String personSurname;
  final DateTime personBirthdate;
  final String personWhatsappNumber;
  final String personEmail;
  final String personPassword;
  final String personDni;
  final String personAddress;
  final int personAge;
  final int idGender;
  final int idPersonType;
  final int idCountry;
  final int idCity;

  StPersonRequest({
    required this.PersonName,
    required this.personSurname,
    required this.personBirthdate,
    required this.personWhatsappNumber,
    required this.personEmail,
    required this.personPassword,
    required this.personDni,
    required this.personAddress,
    required this.personAge,
    required this.idGender,
    required this.idPersonType,
    required this.idCountry,
    required this.idCity,
  });
  Map<String, dynamic> toJson() {
    return {
      'personName': PersonName,
      'personSurname': personSurname,
      'personBirthdate': personBirthdate.toIso8601String(),
      'personWhatsappNumber': personWhatsappNumber,
      'personEmail': personEmail,
      'personPassword': personPassword,
      'personDni': personDni,
      'personAddress': personAddress,
      'personAge': personAge,
      'idGender': idGender,
      'idPersonType': idPersonType,
      'idCountry': idCountry,
      'idCity': idCity,
    };
  }

  debugPrint(){
    print('''personName: $PersonName
    personSurname: $personSurname
    personBirthdate: $personBirthdate
    personWhatsappNumber: $personWhatsappNumber
    personEmail: $personEmail
    personPassword: $personPassword
    personDni: $personDni
    personAddress: $personAddress
    personAge: $personAge
    idGender: $idGender
    idPersonType: $idPersonType
    idCountry: $idCountry
    idCity: $idCity''');
  }
  

}