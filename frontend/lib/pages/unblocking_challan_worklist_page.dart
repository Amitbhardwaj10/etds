import 'package:flutter/material.dart';
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
                      Text("Deductor Name"),
                      InputField(hintText: "Enter Name"),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text("Deductor TAN"),
                      InputField(hintText: "Enter TAN"),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Text("Application ID"),
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
                      Text("Application Date (from-to)"),
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
                      Text("Deductor's Response"),
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
                      Text("Assigned To Sub-User"),
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
                      Text("Status"),
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
                      Text("Date of Hearing (from - to)"),
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
                      Text("Ageing"),
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
                    Button(text: "Delegate"),
                    Button(text: "Reassign"),
                    Button(text: "Recall"),
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
                    DataColumn(label: Text("Date Of Application")),
                    DataColumn(label: Text("Status")),
                    DataColumn(label: Text("Ageing (Days)")),
                    DataColumn(label: Text("Deductor's Response")),
                    DataColumn(label: Text("Date of Hearing")),
                    DataColumn(label: Text("Assigned to Sub-User")),
                  ],

                  source: _source,
                  rowsPerPage: _rowsPerPage,
                  availableRowsPerPage: const [10, 20, 50, 100],

                  onRowsPerPageChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _rowsPerPage = value;
                    });
                  },

                  showCheckboxColumn: true,
                  columnSpacing: 70,
                  horizontalMargin: 16,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 72,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
