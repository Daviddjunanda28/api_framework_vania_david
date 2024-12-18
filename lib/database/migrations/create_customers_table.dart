import 'package:vania/vania.dart';

class CreateCustomersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('customers', () {
      string('cust_id'); 
      string('cust_name', length: 100); 
      string('cust_address', length: 255); 
      string('cust_city', length: 50); 
      string('cust_state', length: 50); 
      string('cust_zip', length: 20); 
      string('cust_country', length: 50); 
      string('cust_telp', length: 20); 
      timeStamps(); 
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('customers');
  }
}
