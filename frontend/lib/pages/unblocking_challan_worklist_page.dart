import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/challan_record.dart';
import 'package:frontend/tableData/data.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/utils/mock_data.dart';
import 'package:frontend/widgets/custom_badge.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_dropdown.dart';
import 'package:frontend/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class UnblockingChallanWorklistPage extends StatefulWidget {
  const UnblockingChallanWorklistPage({super.key});

  @override
  State<UnblockingChallanWorklistPage> createState() =>
      _UnblockingChallanWorklistPageState();
}

class _UnblockingChallanWorklistPageState
    extends State<UnblockingChallanWorklistPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final _source = ChallanDataSource(MockData.challanData);
  int _rowsPerPage = 10;
  int? sortColumnIndex;
  bool sortAscending = true;

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      initialDate: DateTime.now(),
    );
    setState(() {
      controller.text = DateFormat('dd/MM/yyyy', 'en_IN').format(picked!);
    });
  }

  double get width => MediaQuery.of(context).size.width;

  void onSort<T>(
    int colummIndex,
    Comparable<T> Function(ChallanRecord record) getField,
  ) {
    setState(() {
      if (sortColumnIndex == colummIndex) {
        sortAscending = !sortAscending;
      } else {
        sortColumnIndex = colummIndex;
        sortAscending = true;
      }

      _source.sort(getField, sortAscending);
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 25,

          children: [
            Row(
              spacing: 10,
              children: [
                InkWell(
                  onTap: () => {},
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Text(
                    "Dashboard",
                    style: TextStyle(
                      color: AppTheme.hyperText,
                      decoration: TextDecoration.underline,
                      decorationColor: AppTheme.hyperText,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 12),
                InkWell(
                  onTap: () => {},
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text(
                    "Forms & Applications",
                    style: TextStyle(color: AppTheme.secondaryText),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 12),
                InkWell(
                  onTap: () => {},
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text(
                    "Unblocking of Challan - Worlkist",
                    style: TextStyle(color: AppTheme.secondaryText),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Application for Unblocking of Challan - Worklist",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: width >= 950
                            ? 28
                            : width >= 750
                            ? 20
                            : 16,
                        wordSpacing: 2,
                      ),
                    ),
                    Button(text: "Register"),
                  ],
                ),
                Divider(color: AppTheme.secondaryText, thickness: .5),
              ],
            ),

            // First Row
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Deductor Name",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InputField(hintText: "Enter Name"),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Deductor TAN",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InputField(hintText: "Enter TAN"),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Application ID",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InputField(hintText: "Enter Application ID"),
                    ],
                  ),
                ),
              ],
            ),

            // Second Row
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Application Date (from-to)",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: InputField(
                              hintText: "Start date",
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              controller: _startDateController,
                              onTap: () =>
                                  _selectDate(context, _startDateController),
                            ),
                          ),

                          Expanded(
                            child: InputField(
                              hintText: "End date",
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              controller: _endDateController,
                              onTap: () =>
                                  _selectDate(context, _endDateController),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Deductor's Response",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      CustomDropdown(
                        items: MockData.deductorsResponse,
                        hintText: "Select Deductor Response",
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Assigned To Sub-User",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      CustomDropdown(
                        items: MockData.assignedToSubUser,
                        hintText: "Yes/No",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Third Row
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      CustomDropdown(
                        items: MockData.status,
                        hintText: "Select Status",
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Date of Hearing (from - to)",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: InputField(
                              hintText: "Start date",
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              controller: _startDateController,
                              onTap: () =>
                                  _selectDate(context, _startDateController),
                            ),
                          ),

                          Expanded(
                            child: InputField(
                              hintText: "End date",
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              controller: _endDateController,
                              onTap: () =>
                                  _selectDate(context, _endDateController),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text(
                        "Ageing",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      CustomDropdown(
                        items: MockData.ageing,
                        hintText: "Select Ageing",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Fourth Row
            Row(
              spacing: 16,
              children: [
                Button(
                  text: "Search",
                  onPressed: () => {},
                  bgColor: AppTheme.primaryColor,
                  textColor: AppTheme.primaryWhite,
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),

                Button(
                  text: "Reset",
                  textColor: AppTheme.secondaryText,
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ],
            ),

            Divider(color: AppTheme.secondaryText, thickness: .5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "Pending Applications",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),

                    Row(
                      spacing: 15,
                      children: [
                        StatusBadge(
                          text: "Ageing > 30 Days",
                          color: AppTheme.errorColor,
                          backgroundColor: AppTheme.errorHiglight,
                        ),

                        StatusBadge(
                          text: "Ageing is near to 30 Days",
                          color: AppTheme.warningColor,
                          backgroundColor: AppTheme.warningHighlight,
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  spacing: 15,
                  children: [
                    Button(text: "Delegate", icon: Icons.send_outlined),
                    Button(text: "Reassign", icon: Icons.how_to_reg_outlined),
                    Button(text: "Recall", icon: Icons.refresh),
                  ],
                ),
              ],
            ),

            SizedBox(
              width: double.maxFinite,
              child: DataTableTheme(
                data: DataTableThemeData(
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                  dividerThickness: 0,
                  dataTextStyle: const TextStyle(fontWeight: FontWeight.w500),
                ),

                child: PaginatedDataTable(
                  headingRowHeight: 72,
                  headingRowColor: WidgetStateProperty.all(
                    AppTheme.backgroundColor,
                  ),

                  columns: [
                    DataColumn(label: Text("Application ID")),
                    DataColumn(label: Text("Deductor TAN")),
                    DataColumn(label: Text("Deductor Name")),
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text("Date Of Application", softWrap: true),
                      ),

                      mouseCursor: WidgetStateProperty.all(
                        SystemMouseCursors.click,
                      ),

                      onSort: (columnIndex, ascending) {
                        onSort<DateTime>(
                          columnIndex,
                          (record) =>
                              DateFormat('dd/MM/yyyy')
                                  .parse(record.dateOfApplication),
                        );
                      },
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text("Status", softWrap: true),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text("Ageing (Days)", softWrap: true),
                      ),

                      mouseCursor: WidgetStateProperty.all(
                        SystemMouseCursors.click,
                      ),
                      numeric: true,
                      onSort: (columnIndex, ascending) => onSort<num>(
                        columnIndex,
                        (record) => record.ageingDays,
                      ),
                    ),
                    DataColumn(
                      label: Text("Deductor's Response", softWrap: true),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text("Date Of Hearing", softWrap: true),
                      ),

                      mouseCursor: WidgetStateProperty.all(
                        SystemMouseCursors.click,
                      ),

                      onSort: (columnIndex, ascending) {
                        onSort<DateTime>(
                          columnIndex,
                          (record) =>
                              DateFormat('dd/MM/yyyy')
                                  .parse(record.dateOfHearing),
                        );
                      },
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text("Assigned to Sub-User", softWrap: true),
                      ),
                    ),
                  ],

                  source: _source,
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAscending,
                  availableRowsPerPage: const [10, 20, 50, 100],
                  rowsPerPage: _rowsPerPage,
                  showCheckboxColumn: true,
                  columnSpacing: 50,
                  horizontalMargin: 16,
                  dataRowMinHeight: 56,

                  onRowsPerPageChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _rowsPerPage = value;
                    });
                  },

                  dataRowMaxHeight: 72,
                ),
              ),
            ),
            Row(
              children: [
                Button(
                  text: "Back",
                  icon: Icons.keyboard_arrow_left_outlined,
                  textColor: AppTheme.primaryColor,
                  borderColor: AppTheme.primaryColor,
                  onPressed: () => {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
