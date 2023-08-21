import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jengapp/utils/api.dart';
import 'package:jengapp/utils/constants.dart';

import '../controllers/homescreen-controller.dart';
import '../utils/helpers.dart';

class PromotionsSlider extends StatelessWidget {
  final HomeScreenController dashController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          //height: ScreenUtil().setHeight(300.0),
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  //Get.toNamed('/order-place');
                },
                child: Container(
                  width: ScreenUtil().setWidth(320.0),
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
                              imageUrl: apiEndpoints.promotionImages +
                                  dashController
                                      .promotionList[index].promotionImage,
                              fit: BoxFit.cover,
                              //width: 110,
                              height: 310,
                              placeholder: (context, url) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 40,
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
                            "${dashController.promotionList[index].promotionName}",
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
                                "${forCurrencyString(dashController.promotionList[index].promotionCost.toString())}",
                                style: TextStyle(
                                  color: Constants.secondaryColor,
                                  fontSize: 20.0,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                dashController
                                        .promotionList[index].promotionName
                                        .toString()
                                        .contains("Duvet")
                                    ? "/piece"
                                    : dashController
                                            .promotionList[index].promotionName
                                            .toString()
                                            .contains("Load")
                                        ? "/load"
                                        : dashController.promotionList[index]
                                                .promotionName
                                                .toString()
                                                .contains("Package")
                                            ? "/month"
                                            : "",
                                style: TextStyle(
                                  color: Constants.primaryColor,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          if (dashController.promotionList[index].machineService
                                  .toString()
                                  .compareTo("1") ==
                              0)

                          SizedBox(
                            height: 2,
                          ),
                          Text(
                              dashController
                                  .promotionList[index].promotionDuration,
                              style: TextStyle(
                                color: Constants.primaryColor,
                                fontSize: 16.0,
                              )),
                          Text(
                            dashController
                                .promotionList[index].promotionDescription,
                            style: TextStyle(
                              color: Constants.deepOrangeColor,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            dashController.promotionList[index].moreDescription,
                            style: TextStyle(
                              color: Constants.deepOrangeColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 15.0,
              );
            },
            itemCount: dashController.promotionList.length,
          ),
        ));
  }
}
