import 'package:get/get.dart';

class SignUpPersonalInformationController extends GetxController {
  var firstName = ''.obs;
  var lastName = ''.obs;
  var phoneNumber = ''.obs;
  var landlineNumber = ''.obs;

  void saveInformation(
      String fName, String lName, String phone, String landline) {
    firstName.value = fName;
    lastName.value = lName;
    phoneNumber.value = phone;
    landlineNumber.value = landline;

    // Print to debug console
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Phone Number: $phoneNumber');
    print('Landline Number: $landlineNumber');
  }
}
