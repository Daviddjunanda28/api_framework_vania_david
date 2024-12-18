import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      integer('id', increment: true); // Set auto increment for id
      primary('id'); // ID as the primary key
      string('name', length: 255); // Product name
      decimal('price', precision: 10, scale: 2); // Product price
      text('description'); // Product description
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
