import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emergency_item.dart';
import '../providers/emergency_provider.dart';
import '../screens/add_edit_item_screen.dart';

class ItemCard extends StatelessWidget {
  final EmergencyItem item;

  const ItemCard({super.key, required this.item});

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food': return Icons.lunch_dining_rounded;
      case 'Water': return Icons.water_drop_rounded;
      case 'Medicine': return Icons.medication_rounded;
      case 'Tools': return Icons.handyman_rounded;
      case 'Documents': return Icons.folder_rounded;
      case 'Clothing': return Icons.dry_cleaning_rounded;
      default: return Icons.inventory_2_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return const Color(0xFFF59E0B);
      case 'Water': return const Color(0xFF3B82F6);
      case 'Medicine': return const Color(0xFFDC2626);
      case 'Tools': return const Color(0xFF6B7280);
      case 'Documents': return const Color(0xFF8B5CF6);
      case 'Clothing': return const Color(0xFFEC4899);
      default: return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(item.category);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isCompact = screenWidth < 400;
    
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
      child: InkWell(
        onTap: () => AddEditItemScreen.show(context, item: item),
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
            border: Border.all(
              color: item.isReady ? const Color(0xFF10B981).withOpacity(0.3) : const Color(0xFFE2E8F0),
              width: item.isReady ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: isSmallScreen ? 40 : 48,
                height: isSmallScreen ? 40 : 48,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Icon(_getCategoryIcon(item.category), color: categoryColor, size: isSmallScreen ? 20 : 24),
              ),
              SizedBox(width: isSmallScreen ? 10 : 14),
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.itemName,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 6 : 8,
                            vertical: isSmallScreen ? 2 : 3,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 11,
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Qty: ${item.quantity}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 11 : 13,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status Toggle
              GestureDetector(
                onTap: () => context.read<EmergencyProvider>().toggleReady(item.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 8 : 14,
                    vertical: isCompact ? 6 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: item.isReady ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isCompact
                      ? Icon(
                          item.isReady ? Icons.check_rounded : Icons.circle_outlined,
                          size: 18,
                          color: item.isReady ? Colors.white : const Color(0xFF94A3B8),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.isReady ? Icons.check_rounded : Icons.circle_outlined,
                              size: 16,
                              color: item.isReady ? Colors.white : const Color(0xFF94A3B8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.isReady ? 'Ready' : 'Pending',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: item.isReady ? Colors.white : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 4 : 8),
              // More Options
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: const Color(0xFF94A3B8), size: isSmallScreen ? 20 : 24),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onSelected: (value) {
                  if (value == 'edit') {
                    AddEditItemScreen.show(context, item: item);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 20, color: Color(0xFF64748B)),
                        SizedBox(width: 12),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_rounded, size: 20, color: Color(0xFFDC2626)),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: Color(0xFFDC2626))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Item', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to delete "${item.itemName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<EmergencyProvider>().deleteItem(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
