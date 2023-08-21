import 'package:get/get.dart';

class OrderViewerController extends GetxController {
  final pdfLoading = true.obs;
  final downloadPermissionGranted = false.obs;
  final documentBytes = <int>[].obs;
  final percentageDownloaded = 0.obs;

  setPDFNotLoading() {
    pdfLoading.value = false;
  }

  updateDownloadPermissionStatus(perm) {
    downloadPermissionGranted.value = perm;
  }

  updateDocumentBytes(data) {
    documentBytes.value = data;
  }

  updatePercentageDownloaded(perc) {
    percentageDownloaded.value = perc;
  }
}
