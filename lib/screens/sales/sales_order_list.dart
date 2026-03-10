import 'package:flutter/material.dart';
import 'package:mfco/screens/sales/sales_order_creation.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../../../models/purchase/po/purchase_order_model.dart';
import '../../../widgets/purchase/po_list_widget.dart';
import 'sales_order_details.dart';
import 'purchase_order_creation.dart';

class SalesOrderListPage extends StatefulWidget {
  const SalesOrderListPage({super.key});

  @override
  State<SalesOrderListPage> createState() => _SalesOrderListPageState();
}

class _SalesOrderListPageState extends State<SalesOrderListPage> {
  final ApiService _apiService = ApiService();
  List<PurchaseOrder> _orders = [];
  PurchaseOrder? _selectedOrder;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final List<dynamic> data = await _apiService.get(ApiConstants.purchaseOrders);
      if (!mounted) return;
      setState(() {
        _orders = data.map((e) => PurchaseOrder.fromJson(e)).toList();
        if (_selectedOrder != null) {
          _selectedOrder = _orders.firstWhere((o) => o.id == _selectedOrder!.id, orElse: () => _orders.first);
        } else if (_orders.isNotEmpty) {
          _selectedOrder = _orders.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Purchase Management"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final result = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CreateSalesOrderPage()));
                  if (result == true) _fetchOrders();
                },
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : isLandscape ? _buildMasterDetail() : _buildMobileList(),
        );
      },
    );
  }

  Widget _buildMobileList() => POListView(
    orders: _orders,
    onRefresh: _fetchOrders,
    onOrderSelected: (order) async {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => SODetailPage(initialOrder: order,showAppBar: true,)));
      _fetchOrders();
    },
  );

  Widget _buildMasterDetail() => Row(
    children: [
      SizedBox(width: 350, child: POListView(
        orders: _orders,
        selectedOrderId: _selectedOrder?.id,
        onRefresh: _fetchOrders,
        isMasterDetail: true,
        onOrderSelected: (order) => setState(() => _selectedOrder = order),
      )),
      const VerticalDivider(width: 1),
      Expanded(child: _selectedOrder == null
          ? const Center(child: Text("Select an order"))
          : SODetailPage(
        key: ValueKey(_selectedOrder!.id),
        initialOrder: _selectedOrder!,
        onOrderUpdated: _fetchOrders,
          showAppBar: false
      )),
    ],
  );
}