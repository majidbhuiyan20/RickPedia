import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/search_filter_provider.dart';

class SearchFilterWidget extends ConsumerWidget {
  const SearchFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(searchFilterProvider);
    final availableStatuses = ref.watch(availableStatusProvider);
    final availableSpecies = ref.watch(availableSpeciesProvider);
    final hasFilters =
        filterState.searchQuery.isNotEmpty ||
        filterState.statusFilter != null ||
        filterState.speciesFilter != null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search field with filter icon
          _buildSearchField(ref, filterState),
        ],
      ),
    );
  }

  Widget _buildSearchField(WidgetRef ref, SearchFilterState filterState) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                ref.read(searchFilterProvider.notifier).updateSearchQuery(value);
              },
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name...',
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, color: Colors.blue[300], size: 22.sp),
                suffixIcon: filterState.searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          ref
                              .read(searchFilterProvider.notifier)
                              .updateSearchQuery('');
                        },
                        child: Icon(
                          Icons.clear_rounded,
                          color: Colors.red[300],
                          size: 20.sp,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1F2A47),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.blue[300]!, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // Filter icon button
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: ref.context,
              backgroundColor: const Color(0xFF0F1419),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              builder: (context) => FilterPanelWidget(ref: ref),
            );
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2A47),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[700]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.tune_rounded,
              color: Colors.blue[300],
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }






}

/// Separate widget for filter panel to ensure proper rebuilding
class FilterPanelWidget extends ConsumerWidget {
  final WidgetRef ref;

  const FilterPanelWidget({super.key, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(searchFilterProvider);
    final availableStatuses = ref.watch(availableStatusProvider);
    final availableSpecies = ref.watch(availableSpeciesProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (filterState.searchQuery.isNotEmpty ||
                    filterState.statusFilter != null ||
                    filterState.speciesFilter != null)
                  GestureDetector(
                    onTap: () {
                      ref.read(searchFilterProvider.notifier).clearFilters();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 24.h),

            // Status Filter
            Text(
              'Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: availableStatuses.map((status) {
                final isSelected = filterState.statusFilter == status;
                return GestureDetector(
                  onTap: () {
                    ref.read(searchFilterProvider.notifier).updateStatusFilter(
                          isSelected ? null : status,
                        );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue[600]!.withOpacity(0.3)
                          : const Color(0xFF1F2A47),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? Colors.blue[600]! : Colors.grey[700]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.blue[300] : Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 24.h),

            // Species Filter
            Text(
              'Species',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: availableSpecies.map((species) {
                final isSelected = filterState.speciesFilter == species;
                return GestureDetector(
                  onTap: () {
                    ref.read(searchFilterProvider.notifier).updateSpeciesFilter(
                          isSelected ? null : species,
                        );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.purple[600]!.withOpacity(0.3)
                          : const Color(0xFF1F2A47),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? Colors.purple[600]!
                            : Colors.grey[700]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      species,
                      style: TextStyle(
                        color: isSelected ? Colors.purple[300] : Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
