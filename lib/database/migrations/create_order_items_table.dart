import 'package:vania/vania.dart';

class CreateOrderItemsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('order_items', () {
      string('order_item'); 
      string('order_num', length: 50); 
      string('prod_id', length: 50); 
      decimal('quantity', precision: 10, scale: 2);
      string('size', length: 20); 
      timeStamps(); 
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('order_items');
  }
}
