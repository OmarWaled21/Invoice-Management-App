import 'package:facturation_intuitive/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var profileDetails = ProfileModel(
    name: '',
    address: '',
    address2: '',
    city: '',
    postalCode: '',
    country: '',
    tvaNumber: '',
    email: '',
    phone: '',
    image: '',
    siret: '',
    iban: '',
    swift: '',
  ).obs;

  // Load profile details from shared preferences
  Future<void> loadProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch saved data
    final name = prefs.getString('name') ?? '';
    final address = prefs.getString('address') ?? '';
    final address2 = prefs.getString('address2') ?? '';
    final city = prefs.getString('city') ?? '';
    final postalCode = prefs.getString('postalCode') ?? '';
    final country = prefs.getString('country') ?? '';
    final tvaNumber = prefs.getString('tvaNumber') ?? '';
    final email = prefs.getString('email') ?? '';
    final phone = prefs.getString('phone') ?? '';
    final siret = prefs.getString('siret') ?? '';
    final image = prefs.getString('image') ?? '';
    final iban = prefs.getString('iban') ?? '';
    final swift = prefs.getString('swift') ?? '';

    // Update profile model with fetched data
    profileDetails.value = ProfileModel(
      name: name,
      address: address,
      address2: address2,
      city: city,
      postalCode: postalCode,
      country: country,
      tvaNumber: tvaNumber,
      email: email,
      phone: phone,
      siret: siret,
      image: image,
      iban: iban,
      swift: swift,
    );
  }

  // Save profile details to shared preferences
  Future<void> saveProfileDetails(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', profile.name);
    await prefs.setString('address', profile.address);
    await prefs.setString('address2', profile.address2 ?? '');
    await prefs.setString('city', profile.city ?? '');
    await prefs.setString('postalCode', profile.postalCode ?? '');
    await prefs.setString('country', profile.country);
    await prefs.setString('tvaNumber', profile.tvaNumber ?? '');
    await prefs.setString('email', profile.email ?? '');
    await prefs.setString('phone', profile.phone ?? '');
    await prefs.setString('siret', profile.siret ?? '');
    await prefs.setString('image', profile.image ?? '');
    await prefs.setString('iban', profile.iban ?? '');
    await prefs.setString('swift', profile.swift ?? '');

    updateProfileDetails(profile); // Update the controller's profile details
  }

  void updateProfileDetails(ProfileModel updatedProfile) {
    profileDetails.value = updatedProfile;
  }
}
