class ApiConstants {
  static const String baseUrl = "http://10.70.27.239:8000";
  // Auth Endpoints (Djoser)
  static const String login = "$baseUrl/auth/jwt/create/";
  static const String signUp = "$baseUrl/auth/users/";
  static const String userProfile = "$baseUrl/auth/users/me/";
  // Core
  static const String companies = "$baseUrl/core/companies/";
  static const String factories = "$baseUrl/core/factories/";
  static const String regions = "$baseUrl/core/admin-regions/";
  static const String cities = "$baseUrl/core/cities/";

  // Sales
  static const String salesOrders = "$baseUrl/sales/orders/";
  static const String salesItems = "$baseUrl/sales/order-items/";
  static const String customers = "$baseUrl/sales/customers/";
  static const String salesTransactions = "$baseUrl/sales/sales-transactions/";

  // Purchase
  static const String purchaseOrders = "$baseUrl/purchase/orders/";
  static const String purchaseItems = "$baseUrl/purchase/order-items/";
  static const String suppliers = "$baseUrl/purchase/suppliers/";

  // good receving Note
  static const String grns = "$baseUrl/goods/grns/";


  // Inventory
  static const String warehouses = "$baseUrl/inventory/warehouses/";
  static const String products = "$baseUrl/inventory/products/";
  static const String stocks = "$baseUrl/inventory/stocks/";
  static const String movements = "$baseUrl/inventory/inventory-movements/";
  static const String transfers = "$baseUrl/inventory/stock-transfers/";
}
