import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/homescreen-controller.dart';
import '../utils/helpers.dart';

class ServicesSlider extends StatelessWidget {
  final HomeScreenController dashController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          //height: ScreenUtil().setHeight(300.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            //scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed('/order-place', arguments: [
                    {
                      "service":
                          dashController.servicesList[index].serviceName ?? ""
                    },
                    {
                      "cost":
                          dashController.servicesList[index].serviceCost ?? ""
                    },
                    {
                      "image":
                          dashController.servicesList[index].serviceImage ?? ""
                    },
                    {
                      "description": dashController
                              .servicesList[index].serviceDescription ??
                          ""
                    },
                    {
                      "unit": dashController.servicesList[index].serviceUnits
                          .toString()
                    },
                    {
                      "duration": dashController
                          .servicesList[index].serviceDuration
                          .toString()
                    },
                    {
                      "serviceID": dashController.servicesList[index].serviceID
                          .toString()
                    }
                  ]);
                },
                child: Card(

                  child: Container(
                    decoration: BoxDecoration(
                      color: Constants.whiteColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(169, 176, 185, 0.42),
                          spreadRadius: 1,
                          blurRadius: 8.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -10.0,
                          top: -10.0,
                          bottom: -10.0,
                          child: Opacity(
                            opacity: 0.89,
                            child: CachedNetworkImage(
                                imageUrl: apiEndpoints.serviceImages +
                                    dashController
                                        .servicesList[index].serviceImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Constants.primaryColor,
                                            strokeWidth: 1,
                                          ),
                                        ),
                                      ],
                                    ),

                                // You can use LinearProgressIndicator or CircularProgressIndicator instead

                                errorWidget: (context, url, error) {
                                  return Image.asset("assets/images/blank.png");
                                }),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${dashController.servicesList[index].serviceName}",
                              style: TextStyle(
                                color: Constants.secondaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${forCurrencyString(dashController.servicesList[index].serviceCost.toString())}",
                                  style: TextStyle(
                                    color: Constants.secondaryColor,
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "/" +
                                      dashController
                                          .servicesList[index].serviceUnits
                                          .toString(),
                                  style: TextStyle(
                                    color: Constants.primaryColor,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                            if (dashController
                                    .servicesList[index].machineService
                                    .toString()
                                    .compareTo("1") ==
                                0)

                            SizedBox(
                              height: 2,
                            ),
                            Text(
                                dashController
                                            .servicesList[index].serviceDuration
                                            .toString()
                                            .compareTo("1") ==
                                        0
                                    ? "Same day delivery"
                                    : dashController
                                            .servicesList[index].serviceDuration
                                            .toString() +
                                        " day delivery",
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontSize: 16.0,
                                )),
                            SizedBox(height: 10,),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              width: 170,
                              child: Text(

                                  dashController
                                      .servicesList[index].serviceDescription
                                      .toString(),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Constants.grayColor,
                                    fontSize: 18.0,
                                  )),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    //height: ScreenUtil().setHeight(190.0),
                                    decoration: BoxDecoration(
                                      color: Constants.primaryColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: Constants.transparentColor,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 5.0),
                                    child: Text(
                                      "View details",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Constants.whiteColor),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            // separatorBuilder: (BuildContext context, int index) {
            //   return SizedBox(
            //     width: 15.0,
            //   );
            // },
            itemCount: dashController.servicesList.length,
          ),
        ));
  }
}
