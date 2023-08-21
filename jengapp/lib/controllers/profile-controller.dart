import 'package:get/get.dart';

import '../models/profilemodel.dart';
class ProfileController extends GetxController {
  final profileList = <ProfileData>[].obs;
  final profileLoading = true.obs;
  final imageUploadLabel = "Update Image".obs;
  final selectedImage = "".obs;
  final editDetails=false.obs;
  final updatePassword=false.obs;

  updateAllProfiles(allProfileData) {
    profileList.value = allProfileData;
  }

  setProfilesNotLoading() {
    profileLoading.value = false;
  }

  updateImageUploadLabel(label) {
    imageUploadLabel.value = label;
  }

  updateSelectedImage(image) {
    selectedImage.value = image;
  }
  updateEditDetails(choice) {
    editDetails.value = choice;
  }
  updateUserPassword(choice) {
    updatePassword.value = choice;
  }

}
