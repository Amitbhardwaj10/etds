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
  final _applicationStartDateController = TextEditingController();
  final _applicationEndDateController = TextEditingController();
  final _hearingStartDateController = TextEditingController();
  final _hearingEndDateController = TextEditingController();
  final _deductorNameController = TextEditingController();
  final _deductorTanController = TextEditingController();
  final _applicatioIdController = TextEditingController();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
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

    if (picked == null) return;

    controller.text = DateFormat('dd/MM/yyyy').format(picked);
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

  void onSearch() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.reset();
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
    return;
  }

  String? dateValidator(
    TextEditingController startController,
    TextEditingController endController, {
    required bool isStartDate,
  }) {
    final startText = startController.text.trim();
    final endText = endController.text.trim();

    if (startText.isEmpty || endText.isEmpty) {
      return null;
    }

    final startDate = DateFormat("dd/MM/yyyy").parseStrict(startText);
    final endDate = DateFormat('dd/MM/yyyy').parseStrict(endText);

    if (isStartDate && startDate.isAfter(endDate)) {
      return "Start date cannot be after end date";
    }

    if (!isStartDate && endDate.isBefore(startDate)) {
      return "End date cannot be before sart date";
    }

    return null;
  }

  @override
  void dispose() {
    _applicationStartDateController.dispose();
    _applicatioIdController.dispose();
    _hearingStartDateController.dispose();
    _hearingEndDateController.dispose();
    _deductorNameController.dispose();
    _applicatioIdController.dispose();
    _deductorTanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Form(
        autovalidateMode: _autovalidateMode,
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
                      TextFormField(
                        controller: _deductorNameController,
                        decoration: InputDecoration(
                          hint: Text("Enter Name"),
                          border: OutlineInputBorder(),
                        ),

                        maxLength: 125,
                        buildCounter: (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) => null,
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
                        "Deductor TAN",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: _deductorTanController,
                        decoration: InputDecoration(
                          hint: Text("Enter TAN"),
                          border: OutlineInputBorder(),
                        ),

                        validator: (value) {
                          final regExp = RegExp(
                            r'^[A-Za-z]{4}[0-9]{5}[A-Za-z]$',
                          );

                          if (value != null &&
                              value.isNotEmpty &&
                              !regExp.hasMatch(value)) {
                            return "Please enter a valid TAN number";
                          }

                          return null;
                        },
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
                        "Application ID",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        controller: _applicatioIdController,
                        decoration: InputDecoration(
                          hint: Text("Enter Application ID"),
                          border: OutlineInputBorder(),
                        ),

                        maxLength: 11,
                        buildCounter: (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) => null,

                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.trim().length != 11) {
                            return 'Application ID must be 11 characters';
                          }
                          return null;
                        },
                      ),
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
                              controller: _applicationStartDateController,
                              validator: (value) => dateValidator(
                                _applicationStartDateController,
                                _applicationEndDateController,
                                isStartDate: true,
                              ),
                              onTap: () => _selectDate(
                                context,
                                _applicationStartDateController,
                              ),
                            ),
                          ),

                          Expanded(
                            child: InputField(
                              hintText: "End date",
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              controller: _applicationEndDateController,
                              validator: (value) => dateValidator(
                                _applicationStartDateController,
                                _applicationEndDateController,
                                isStartDate: false,
                              ),
                              onTap: () =>
                                  (_applicationStartDateController
                                      .text
                                      .isNotEmpty)
                                  ? _selectDate(
                                      context,
                                      _applicationEndDateController,
                                    )
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppTheme.errorColor,
                                        content: Text(
                                          "Select start date first",
                                        ),
                                      ),
                                    ),
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
                              controller: _hearingStartDateController,
                              validator: (value) => dateValidator(
                                _hearingStartDateController,
                                _hearingEndDateController,
                                isStartDate: true,
                              ),
                              onTap: () => _selectDate(
                                context,
                                _hearingStartDateController,
                              ),
                            ),
                          ),

                          Expanded(
                            child: InputField(
                              hintText: "End date",
                              readOnly: true,
                              suffixIcon: Icon(Icons.calendar_today_outlined),
                              controller: _hearingEndDateController,
                              validator: (value) => dateValidator(
                                _hearingStartDateController,
                                _hearingEndDateController,
                                isStartDate: false,
                              ),
                              onTap: () =>
                                  (_hearingStartDateController.text.isNotEmpty)
                                  ? _selectDate(
                                      context,
                                      _hearingEndDateController,
                                    )
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: AppTheme.errorColor,
                                        content: Text(
                                          "Select start date first",
                                        ),
                                      ),
                                    ),
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
                  onPressed: onSearch,
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
