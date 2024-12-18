import 'package:vania/vania.dart';

class CreateOrdersTable extends Migration {

  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orders', () {
      string('order_num');  
      date('order_date');  
      string('cust_id', length: 50); 
      timeStamps();  
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orders');
  }
}
