
import 'package:form_field_validator/form_field_validator.dart';

class Validator{
final nameVal =
      MultiValidator([RequiredValidator(errorText: 'Name is Required')]);

  final emailVal = MultiValidator([
    RequiredValidator(errorText: 'Email is Required'),
    EmailValidator(errorText: 'Email must be a Valid Email')
  ]);

  final passwordVal = MultiValidator([
    RequiredValidator(errorText: 'Password is Required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 Characters')
  ]);

  final amountVal = MultiValidator([
    RequiredValidator(errorText: 'Field is Required'),
    RangeValidator(
        min: 0, max:1000000000, errorText: 'Amount must be in range 0-100')
  ]);

}