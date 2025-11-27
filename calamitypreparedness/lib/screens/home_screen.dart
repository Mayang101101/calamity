import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/emergency_provider.dart';
import '../widgets/item_card.dart';
import 'add_edit_item_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps_rounded},
    {'name': 'Food', 'icon': Icons.lunch_dining_rounded},
    {'name': 'Water', 'icon': Icons.water_drop_rounded},
    {'name': 'Medicine', 'icon': Icons.medication_rounded},
    {'name': 'Tools', 'icon': Icons.handyman_rounded},
    {'name': 'Documents', 'icon': Icons.folder_rounded},
    {'name': 'Clothing', 'icon': Icons.dry_cleaning_rounded},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<EmergencyProvider>().fetchItems());
  }

  String get _selectedCategoryName => _categories[_selectedCategory]['name'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 700;
    final isDesktop = screenWidth > 1100;
    final horizontalPadding = isDesktop ? 48.0 : (isTablet ? 32.0 : 20.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(screenWidth < 360 ? 8 : 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDC2626),
                                  borderRadius: BorderRadius.circular(screenWidth < 360 ? 10 : 14),
                                ),
                                child: Icon(Icons.shield_rounded, color: Colors.white, size: screenWidth < 360 ? 20 : 26),
                              ),
                              SizedBox(width: screenWidth < 360 ? 10 : 14),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Calamity Preparedness',
                                      style: TextStyle(
                                        fontSize: screenWidth < 360 ? 16 : (screenWidth < 400 ? 18 : 22),
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Emergency Kit Checklist',
                                      style: TextStyle(
                                        fontSize: screenWidth < 360 ? 12 : 14,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => context.read<EmergencyProvider>().fetchItems(),
                          icon: const Icon(Icons.refresh_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(screenWidth < 360 ? 8 : 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Stats Cards
            SliverToBoxAdapter(
              child: Consumer<EmergencyProvider>(
                builder: (context, provider, child) {
                  final readyPercent = provider.totalItemsCount > 0
                      ? (provider.readyCount / provider.totalItemsCount * 100).round()
                      : 0;
                  
                  return Padding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 0),
                    child: isDesktop
                        ? Row(
                            children: [
                              Expanded(child: _buildStatCard('Total Items', provider.totalItemsCount.toString(), Icons.inventory_2_rounded, const Color(0xFF3B82F6))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('Ready', provider.readyCount.toString(), Icons.check_circle_rounded, const Color(0xFF10B981))),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard('Pending', provider.notReadyCount.toString(), Icons.pending_rounded, const Color(0xFFF59E0B))),
                              const SizedBox(width: 16),
                              Expanded(flex: 2, child: _buildProgressCard(readyPercent)),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildStatCard('Total', provider.totalItemsCount.toString(), Icons.inventory_2_rounded, const Color(0xFF3B82F6))),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildStatCard('Ready', provider.readyCount.toString(), Icons.check_circle_rounded, const Color(0xFF10B981))),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildStatCard('Pending', provider.notReadyCount.toString(), Icons.pending_rounded, const Color(0xFFF59E0B))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildProgressCard(readyPercent),
                            ],
                          ),
                  );
                },
              ),
            ),

            // Category Pills
            SliverToBoxAdapter(
              child: Container(
                height: screenWidth < 360 ? 48 : 56,
                margin: const EdgeInsets.only(top: 24),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategory == index;
                    final isSmallScreen = screenWidth < 360;
                    return Padding(
                      padding: EdgeInsets.only(right: isSmallScreen ? 6 : 10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        child: Material(
                          color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                          child: InkWell(
                            onTap: () => setState(() => _selectedCategory = index),
                            borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 12 : 18,
                                vertical: isSmallScreen ? 8 : 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _categories[index]['icon'],
                                    size: isSmallScreen ? 16 : 20,
                                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                                  ),
                                  SizedBox(width: isSmallScreen ? 6 : 8),
                                  Text(
                                    _categories[index]['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isSmallScreen ? 12 : 14,
                                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Items',
                      style: TextStyle(
                        fontSize: screenWidth < 360 ? 16 : 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Consumer<EmergencyProvider>(
                      builder: (context, provider, child) {
                        final items = provider.getItemsByCategory(_selectedCategoryName);
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 360 ? 10 : 12,
                            vertical: screenWidth < 360 ? 4 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${items.length} items',
                            style: TextStyle(
                              fontSize: screenWidth < 360 ? 11 : 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Items List/Grid
            Consumer<EmergencyProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF0F172A), strokeWidth: 3),
                    ),
                  );
                }

                if (provider.error != null) {
                  return SliverFillRemaining(
                    child: _buildErrorState(provider),
                  );
                }

                final items = provider.getItemsByCategory(_selectedCategoryName);

                if (items.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState());
                }

                if (isDesktop) {
                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 120),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ItemCard(item: items[index]),
                        childCount: items.length,
                      ),
                    ),
                  );
                } else if (isTablet) {
                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 120),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ItemCard(item: items[index]),
                        childCount: items.length,
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ItemCard(item: items[index]),
                      ),
                      childCount: items.length,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: screenWidth < 360 ? 12 : 16),
        child: screenWidth < 360
            ? FloatingActionButton(
                onPressed: () => AddEditItemScreen.show(context),
                backgroundColor: const Color(0xFF0F172A),
                elevation: 4,
                child: const Icon(Icons.add_rounded, color: Colors.white),
              )
            : FloatingActionButton.extended(
                onPressed: () => AddEditItemScreen.show(context),
                backgroundColor: const Color(0xFF0F172A),
                elevation: 4,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text('Add Item', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 6 : 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isSmallScreen ? 6 : 10),
            ),
            child: Icon(icon, color: color, size: isSmallScreen ? 16 : 22),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 26,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 13,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int percent) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    Color progressColor = percent >= 80 ? const Color(0xFF10B981) : percent >= 50 ? const Color(0xFFF59E0B) : const Color(0xFFDC2626);
    String status = percent >= 80 ? 'Excellent! You\'re well prepared' : percent >= 50 ? 'Good progress, keep going!' : 'Needs more preparation';
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Preparedness Level',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isSmallScreen ? 13 : 15,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 10 : 12,
                  vertical: isSmallScreen ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percent%',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isSmallScreen ? 13 : 14,
                    color: progressColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 10 : 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: isSmallScreen ? 8 : 10,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Text(
            status,
            style: TextStyle(
              fontSize: isSmallScreen ? 11 : 13,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.inventory_2_outlined, size: 48, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          const Text('No items yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          const Text('Start adding items to your emergency kit', style: TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _buildErrorState(EmergencyProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFFDC2626)),
          ),
          const SizedBox(height: 24),
          const Text('Something went wrong', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          const SizedBox(height: 8),
          const Text('Failed to load items', style: TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => provider.fetchItems(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
