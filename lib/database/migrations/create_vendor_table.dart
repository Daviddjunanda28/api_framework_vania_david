import 'package:vania/vania.dart';

class CreateVendorTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('vendor', () {
      string('vend_id'); 
      string('vend_name', length: 100); 
      string('vend_address', length: 255); 
      string('vend_kota', length: 50); 
      string('vend_state', length: 50); 
      string('vend_zip', length: 20); 
      string('vend_country', length: 50); 
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendor');
  }
}
