import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../../core/constants/api_constants.dart';
import '../../models/purchase/goods_receiving_note_model.dart';
import '../../models/purchase/gr_note.dart';
import '../../services/api_service.dart';
import 'gnr_details.dart';

class GRNListPage extends StatefulWidget {
  const GRNListPage({super.key});

  @override
  State<GRNListPage> createState() => _GRNListPageState();
}

class _GRNListPageState extends State<GRNListPage> {
  final ApiService _apiService = ApiService();
  List<GoodsReceivingNote> _grns = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchGRNs();
  }

  Future<void> _fetchGRNs() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dynamic response = await _apiService.get(ApiConstants.grns);

      if (response is List) {
        setState(() {
          _grns = response.map((e) => GoodsReceivingNote.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Receiving History"),
        actions: [
          IconButton(onPressed: _fetchGRNs, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 16),
            Text("Connection Error", style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_errorMessage!, textAlign: TextAlign.center),
            TextButton(onPressed: _fetchGRNs, child: const Text("Try Again"))
          ],
        ),
      );
    }

    if (_grns.isEmpty) {
      return Center(child: Text("No receipts found."));
    }

    return RefreshIndicator(
      onRefresh: _fetchGRNs,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _grns.length,
        itemBuilder: (context, index) => _buildGRNCard(_grns[index], theme),
      ),
    );
  }

  Widget _buildGRNCard(GoodsReceivingNote grn, ThemeData theme) {
    final bool isPosted = grn.status == "Posted";

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GRNDetailPage(grn: grn)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(grn.tracker!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  _statusBadge(grn.status, isPosted ? Colors.green : Colors.orange),
                ],
              ),
              const SizedBox(height: 12),

              // Reference to PO
              _infoRow(Icons.description_outlined, "PO Ref: ${grn.purchaseOrderTracker}"),
              const SizedBox(height: 6),

              // Receiver Info
              _infoRow(Icons.person_outline, "Received by: ${grn.receivedByName}"),
              const SizedBox(height: 6),

              // Date Info
              if (grn.receivedDate != null)
                _infoRow(Icons.calendar_today_outlined, DateFormat('MMM dd, yyyy • hh:mm a').format(grn.receivedDate!)),

              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${grn.items.length} Line Items", style: TextStyle(color: Colors.grey.shade600)),
                  Text(
                    NumberFormat.currency(symbol: "ETB ").format(grn.grandTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}