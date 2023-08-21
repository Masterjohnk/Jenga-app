import 'package:jengapp/models/order_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDBOperations {
  late Database database;

  CartDBOperations() {
    openDataBase();
  }

  openDataBase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'cart.db');
    // open the database
    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Cart (id INTEGER PRIMARY KEY, serviceID INTEGER, serviceName TEXT, serviceUnits, serviceImage TEXT, approximateQuantity INTEGER, amount REAL, isScheduledDate INTEGER, scheduledDate TEXT)');
    });
  }

  insertRecord(
      {required serviceID,
        required serviceImage,
        required serviceName,
        required serviceUnits,
      required approximateQuantity,
      required amount,
      required isScheduledDate,
      required scheduledDate}) async {
    checkIfExits(serviceID).then((val) async {

      if (val!=null) {
        int count = await database.rawUpdate(
            'UPDATE Cart SET approximateQuantity = approximateQuantity+'+approximateQuantity+', amount = amount+'+amount+' WHERE serviceID = '+serviceID);
      } else {
        await database.transaction((txn) async {
          int id2 = await txn.rawInsert(
              'INSERT INTO Cart(serviceID, serviceName, serviceUnits, serviceImage, approximateQuantity, amount, isScheduledDate, scheduledDate) VALUES(?, ?, ?, ?, ?, ?, ?, ?)',
              [
                serviceID,
                serviceName,
                serviceUnits,
                serviceImage,
                approximateQuantity,
                amount,
                isScheduledDate,
                scheduledDate
              ]);
          print('inserted2: $id2');
        });
      }
    }
    );

  }

  countCartItems() async {
    return Sqflite.firstIntValue(
        await database.rawQuery('SELECT sum(approximateQuantity) FROM Cart'));
  }
  checkIfExits(serviceID) async {
    return Sqflite.firstIntValue(
        await database.rawQuery('SELECT sum(approximateQuantity) FROM Cart where serviceID='+serviceID));
  }
  deleteAll() async {
    await database.rawDelete('DELETE FROM Cart');
  }

  deleteSpecific(itemID) async {
    var res = await database.rawDelete('DELETE FROM Cart where id=' + itemID);
    print(res);
  }

  Future<List<OrderItem>?> getCartItems() async {
    final List<Map<String, dynamic>> cartItemsMap =
        await database.rawQuery('SELECT * FROM Cart');
    return List.generate(cartItemsMap.length, (i) {
      return OrderItem(
        serviceName: cartItemsMap[i]['serviceName'].toString(),
        serviceID: cartItemsMap[i]['serviceID'].toString(),
        serviceUnits:cartItemsMap[i]['serviceUnits'].toString(),
        serviceImage: cartItemsMap[i]['serviceImage'].toString(),
        amount: cartItemsMap[i]['amount'].toString(),
        quantity: cartItemsMap[i]['approximateQuantity'].toString(),
        recID: cartItemsMap[i]['id'].toString(),
        // Same for the other properties
      );
    });
  }
}
