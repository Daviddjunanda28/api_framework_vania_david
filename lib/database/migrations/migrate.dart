import 'dart:io';
import 'package:vania/vania.dart';
import 'create_users_table.dart';
import 'create_customers_table.dart';
import 'create_orders_table.dart';
import 'create_order_items_table.dart';
import 'create_product_notes_table.dart';
import 'create_products_table.dart';
import 'create_vendor_table.dart';
import 'create_personal_access_tokens_table.dart';
import 'create_todos_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateCustomersTable().up();
		 await CreateOrdersTable().up();
		 await CreateOrderItemsTable().up();
		 await CreateProductNotesTable().up();
		 await CreateProductsTable().up();
		 await CreateVendorTable().up();
		 await CreatePersonalAccessTokensTable().up();
		 await CreateTodosTable().up();
	}

  dropTables() async {
		 await CreateTodosTable().down();
		 await CreatePersonalAccessTokensTable().down();
		 await CreateVendorTable().down();
		 await CreateProductsTable().down();
		 await CreateProductNotesTable().down();
		 await CreateOrderItemsTable().down();
		 await CreateOrdersTable().down();
		 await CreateCustomersTable().down();
	 }
}
