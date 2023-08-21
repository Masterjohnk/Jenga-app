import 'dart:core';

class Service {
  var serviceID;
  var serviceName;
  var serviceCost;
  var serviceDescription;
  var servicePopularity;
  var serviceImage;
  var serviceUnits;
  var machineService;
  var serviceDuration;

  Service(
      {this.serviceID,
      this.serviceName,
      this.serviceCost,
      this.serviceDescription,
      this.servicePopularity,
      this.machineService,
      this.serviceDuration,
      this.serviceUnits,
      this.serviceImage});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
        serviceID: json['serviceID'] ?? '',
        serviceName: json['serviceName'] ?? '',
        serviceImage: json['serviceImage'] ?? 'Blank',
        serviceDescription: json['serviceDescription'] ?? '',
        serviceCost: json['serviceCost'] ?? '',
        serviceDuration: json['serviceDuration'] ?? '',
        serviceUnits: json['serviceUnits'] ?? '',
        machineService: json['machineService'] ?? '',
        servicePopularity: json['servicePopularity'] ?? '');
  }
}
