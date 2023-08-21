import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';
import 'package:jengapp/utils/helpers.dart';
import 'package:open_file_safe/open_file_safe.dart';
//import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/order-invoice-viewer-controller.dart';

class OrderInvoiceViewer extends StatelessWidget {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final OrderViewerController orderViewerController =
      Get.put(OrderViewerController());
  final orderID = Get.arguments[0]['orderID'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: 0.0,
                top: -20.0,
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    "assets/images/background.png",
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Constants.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 15.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Order Invoice",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 100.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Obx(
                          () => Column(
                            children: [
                              if (!orderViewerController.pdfLoading.value)
                                myAdminButton("Download Invoice", 10, 15, () {
                                  downloadFile(
                                      apiEndpoints.orderInvoice +
                                          "?orderID=" +
                                          orderID,
                                      orderID);
                                }),
                              if (orderViewerController
                                          .percentageDownloaded.value >
                                      1 &&
                                  orderViewerController
                                          .percentageDownloaded.value <
                                      100)
                                Container(
                                  alignment: Alignment.center,
                                  width: ScreenUtil().setWidth(80.0),
                                  height: ScreenUtil().setHeight(80.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Constants.secondaryColor,
                                  ),
                                  child: Text(orderViewerController
                                      .percentageDownloaded.value
                                      .toString()+"%",style: TextStyle(color: Constants.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                //width: 200,
                                child: SfPdfViewerTheme(
                                    data: SfPdfViewerThemeData(
                                        backgroundColor: Constants.whiteColor,
                                        progressBarColor:
                                            Constants.secondaryColor),
                                    child: SfPdfViewer.network(
                                        apiEndpoints.orderInvoice +
                                            "?orderID=" +
                                            orderID,
                                        enableTextSelection: true,
                                        initialZoomLevel: 1,
                                        enableDoubleTapZooming: true,
                                        onDocumentLoaded: (details) {
                                      orderViewerController.updateDocumentBytes(
                                          details.document.saveSync());
                                      orderViewerController.setPDFNotLoading();
                                    },
                                        enableHyperlinkNavigation: true,
                                        pageLayoutMode:
                                            PdfPageLayoutMode.continuous,
                                        key: _pdfViewerKey,
                                        canShowScrollHead: true,
                                        canShowScrollStatus: true)),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //)
  //   : Center(
  // child: Text("No notifications...",
  //     style: TextStyle(fontSize: 18)),
  //)
  // Let's create an order model

  downloadFile(uri, oID) async {
    if (!orderViewerController.downloadPermissionGranted.value) {
      requestWritePermission();
    }
    Directory directory = await getTemporaryDirectory();
    String path = directory.path;
    //Create the empty file.
    File file = File('$path/' + oID + '.pdf');
    //Write the PDF data retrieved from the SfPdfViewer.
    // await file.writeAsBytes(orderViewerController.documentBytes.value!, flush: true);
    //progress = 0.0;
    //DialogBuilder(context).showLoadingIndicator(
    //"Please wait as file is downloaded..$progress", "Transaction");
    // setState(() {
    //   downloading = true;
    // });

    // String savePath = await getFilePath();
    // await savePath.writeAsBytes(_documentBytes!, flush: true);
    Dio dio = Dio();
    //
    print(uri.toString());
    dio.download(
      uri,
      file.path,
      onReceiveProgress: (rcv, total) async {
        orderViewerController
            .updatePercentageDownloaded(((rcv / total) * 100).toInt());
        if (rcv == total) {
          if(Platform.isAndroid)
          OpenFile.open(file.path);
        }
      },
      options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
      deleteOnError: true,
    ).then((_) {});
  }

  // Future<File> getFilePath() async {
  //   String path = '';
  //   Directory dir = await getTemporaryDirectory();
  //   path = '${dir.path}/FriendsChama.pdf';
  //   return path;
  // }

  requestWritePermission() async {
    if (await Permission.storage.request().isGranted) {
      orderViewerController.updateDownloadPermissionStatus(true);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }
}
