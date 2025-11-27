import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emergency_item.dart';
import '../providers/emergency_provider.dart';

class AddEditItemScreen extends StatefulWidget {
  final EmergencyItem? item;

  const AddEditItemScreen({super.key, this.item});

  static void show(BuildContext context, {EmergencyItem? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEditItemScreen(item: item),
    );
  }

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _quantityController;
  
  String _selectedCategory = 'Food';
  bool _isReady = false;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food', 'icon': Icons.lunch_dining_rounded, 'color': const Color(0xFFF59E0B)},
    {'name': 'Water', 'icon': Icons.water_drop_rounded, 'color': const Color(0xFF3B82F6)},
    {'name': 'Medicine', 'icon': Icons.medication_rounded, 'color': const Color(0xFFDC2626)},
    {'name': 'Tools', 'icon': Icons.handyman_rounded, 'color': const Color(0xFF6B7280)},
    {'name': 'Documents', 'icon': Icons.folder_rounded, 'color': const Color(0xFF8B5CF6)},
    {'name': 'Clothing', 'icon': Icons.dry_cleaning_rounded, 'color': const Color(0xFFEC4899)},
  ];

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.item?.itemName ?? '');
    _quantityController = TextEditingController(text: widget.item?.quantity.toString() ?? '1');
    _selectedCategory = widget.item?.category ?? 'Food';
    _isReady = widget.item?.isReady ?? false;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = EmergencyItem(
        id: widget.item?.id ?? '',
        itemName: _itemNameController.text.trim(),
        category: _selectedCategory,
        quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
        isReady: _isReady,
        createdAt: widget.item?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.item == null) {
        await context.read<EmergencyProvider>().addItem(item);
      } else {
        await context.read<EmergencyProvider>().updateItem(widget.item!.id, item);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(widget.item == null ? 'Item added successfully!' : 'Item updated!'),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: const Color(0xFFDC2626)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                children: [
                  // Handle Bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.item == null ? Icons.add_rounded : Icons.edit_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item == null ? 'Add New Item' : 'Edit Item',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                              ),
                              const Text(
                                'Fill in the details below',
                                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: Colors.grey[200]),

                  // Form Content
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(24),
                        children: [
                          // Item Name
                          const Text('Item Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A))),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _itemNameController,
                            decoration: const InputDecoration(
                              hintText: 'e.g., Flashlight, Canned Goods',
                              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter item name' : null,
                          ),
                          const SizedBox(height: 24),

                          // Category
                          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A))),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _categories.map((cat) {
                              final isSelected = _selectedCategory == cat['name'];
                              return GestureDetector(
                                onTap: () => setState(() => _selectedCategory = cat['name']),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? (cat['color'] as Color) : const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? (cat['color'] as Color) : const Color(0xFFE2E8F0),
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        cat['icon'] as IconData,
                                        size: 18,
                                        color: isSelected ? Colors.white : const Color(0xFF64748B),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cat['name'] as String,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? Colors.white : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Quantity
                          const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A))),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Enter quantity',
                              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) return 'Please enter quantity';
                              if (int.tryParse(value) == null) return 'Please enter a valid number';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Ready Status
                          const Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0F172A))),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => setState(() => _isReady = !_isReady),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: _isReady ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _isReady ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                                  width: _isReady ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: _isReady ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _isReady ? Icons.check_rounded : Icons.close_rounded,
                                      color: _isReady ? Colors.white : const Color(0xFF94A3B8),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _isReady ? 'Ready' : 'Not Ready',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: _isReady ? const Color(0xFF10B981) : const Color(0xFF64748B),
                                          ),
                                        ),
                                        Text(
                                          _isReady ? 'Item is prepared and packed' : 'Item still needs to be prepared',
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveItem,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text(
                                      widget.item == null ? 'Add Item' : 'Save Changes',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
