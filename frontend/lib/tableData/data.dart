import 'package:flutter/material.dart';
import 'package:frontend/models/challan_record.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/widgets/custom_badge.dart';

class ChallanDataSource extends DataTableSource {
  final List<ChallanRecord> records;

  ChallanDataSource(this.records);

  int get selectedCount => records.where((record) => record.selected).length;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= records.length) {
      return null;
    }

    final record = records[index];

    return DataRow.byIndex(
      index: index,
      selected: record.selected,
      onSelectChanged: (value) {
        record.selected = value ?? false;
        notifyListeners();
      },

      color: (index % 2 != 0 && index > 0)
          ? WidgetStatePropertyAll(AppTheme.secondaryBg)
          : WidgetStatePropertyAll(AppTheme.primaryWhite),
      cells: [
        DataCell(
          Text(
            record.applicationId,
            style: const TextStyle(
              color: AppTheme.hyperText,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.hyperText,
              decorationThickness: 1.5,
            ),
          ),
        ),
        DataCell(Text(record.deductorTan)),
        DataCell(Text(record.deductorName)),
        DataCell(Text(record.dateOfApplication)),
        DataCell(
          SizedBox(
            width: 150,
            child: Text(
              record.status,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (record.ageingDays > 30)
                StatusBadge(
                  text: "${record.ageingDays}",
                  color: AppTheme.errorColor,
                  backgroundColor: AppTheme.errorHiglight,
                )
              else if (record.ageingDays <= 30 && record.ageingDays >= 25)
                StatusBadge(
                  text: "${record.ageingDays}",
                  color: AppTheme.warningColor,
                  backgroundColor: AppTheme.warningHighlight,
                )
              else
                StatusBadge(text: "${record.ageingDays}"),
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 150,
            child: Text(
              record.deductorResponse,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(record.dateOfHearing)),
        DataCell(Text(record.assignedTo)),
      ],
    );
  }

  @override
  int get rowCount => records.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => selectedCount;

  void sort<T>(
    Comparable<T> Function(ChallanRecord record) getField,
    bool ascending,
  ) {
    records.sort((a, b) {
      final result = Comparable.compare(getField(a), getField(b));
      return ascending ? result : -result;
    });
    notifyListeners();
  }
}
