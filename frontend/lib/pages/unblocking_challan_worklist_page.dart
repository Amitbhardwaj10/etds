import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final ValueNotifier<String?> selectedDeductorResp = ValueNotifier(null);
  final ValueNotifier<String?> selectedSubUser = ValueNotifier(null);
  final ValueNotifier<String?> selectedStatus = ValueNotifier(null);
  final ValueNotifier<String?> selectedAgeing = ValueNotifier(null);

  late final List<ChallanRecord> _allRecords;
  late final ChallanDataSource _source;

  @override
  void initState() {
    super.initState();
    _allRecords = List<ChallanRecord>.of(MockData.challanData);
    _source = ChallanDataSource(_allRecords);
  }

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
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
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked == null) return;

    setState(() {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }

  double get width => MediaQuery.of(context).size.width;

  // sorting
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

  // on search of filters
  void onSearch() {
    if (_formKey.currentState!.validate()) {
      applyFilters();
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
    return;
  }

  // on reset of filters
  void onReset() {
    _formKey.currentState?.reset();

    _deductorNameController.clear();
    _deductorTanController.clear();
    _applicatioIdController.clear();

    _applicationStartDateController.clear();
    _applicationEndDateController.clear();
    _hearingStartDateController.clear();
    _hearingEndDateController.clear();

    selectedDeductorResp.value = null;
    selectedSubUser.value = null;
    selectedStatus.value = null;
    selectedAgeing.value = null;

    setState(() {
      _autovalidateMode = AutovalidateMode.disabled;
      sortColumnIndex = null;
      sortAscending = true;
    });

    _source.resetData();
  }

  // date validator
  String? dateValidator(
    TextEditingController startController,
    TextEditingController endController, {
    required bool isStartDate,
  }) {
    final startText = startController.text.trim();
    final endText = endController.text.trim();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final startDate = startText.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parseStrict(startText)
        : null;

    final endDate = endText.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parseStrict(endText)
        : null;

    if (isStartDate) {
      if (startDate != null && startDate.isAfter(today)) {
        return "Start date cannot be in the future";
      }

      if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
        return "Start date cannot be after end date";
      }
    } else {
      if (endDate != null && endDate.isAfter(today)) {
        return "End date cannot be in the future";
      }

      if (startDate != null && endDate != null && endDate.isBefore(startDate)) {
        return "End date cannot be before start date";
      }
    }

    return null;
  }

  bool isWithinDateRange(
    String recordDate,
    TextEditingController startController,
    TextEditingController endController,
  ) {
    final date = DateFormat('dd/MM/yyyy').parseStrict(recordDate);

    final startDate = startController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parseStrict(startController.text)
        : null;

    final endDate = endController.text.isNotEmpty
        ? DateFormat('dd/MM/yyyy').parseStrict(endController.text)
        : null;

    if (startDate != null && date.isBefore(startDate)) {
      return false;
    }

    if (endDate != null && date.isAfter(endDate)) {
      return false;
    }

    return true;
  }

  bool isAnyFilterApplied() {
    return _deductorNameController.text.trim().isNotEmpty ||
        _deductorTanController.text.trim().isNotEmpty ||
        _applicatioIdController.text.trim().isNotEmpty ||
        _applicationStartDateController.text.isNotEmpty ||
        _applicationEndDateController.text.isNotEmpty ||
        _hearingStartDateController.text.isNotEmpty ||
        _hearingEndDateController.text.isNotEmpty ||
        selectedDeductorResp.value != null ||
        selectedSubUser.value != null ||
        selectedStatus.value != null ||
        selectedAgeing.value != null;
  }

  bool matchesStatus(String recordStatus, String? selectedStatus) {
    if (selectedStatus == null || selectedStatus == 'All') {
      return true;
    }

    switch (selectedStatus) {
      case 'Pending':
        return recordStatus.toLowerCase() == 'pending';

      case 'Closed':
        return recordStatus.toLowerCase() == 'closed';

      case 'Withdrawn':
        return recordStatus.toLowerCase() == 'application withdrawn';

      case 'Pending With RH':
        return recordStatus.toLowerCase() == 'pending with range head';

      default:
        return true;
    }
  }

  // Apply filters to the data source
  void applyFilters() {
    final deductorName = _deductorNameController.text.trim().toLowerCase();

    final deductorTan = _deductorTanController.text.trim().toLowerCase();

    final applicationId = _applicatioIdController.text.trim().toLowerCase();

    final filteredRecords = _allRecords.where((record) {
      // Deductor name
      if (deductorName.isNotEmpty &&
          !record.deductorName.toLowerCase().contains(deductorName)) {
        return false;
      }

      // Deductor TAN
      if (deductorTan.isNotEmpty &&
          !record.deductorTan.toLowerCase().contains(deductorTan)) {
        return false;
      }

      // Application ID
      if (applicationId.isNotEmpty &&
          !record.applicationId.toLowerCase().contains(applicationId)) {
        return false;
      }

      // Status
      if (!matchesStatus(record.status, selectedStatus.value)) {
        return false;
      }

      // Deductor response
      if (selectedDeductorResp.value != null &&
          record.deductorResponse != selectedDeductorResp.value) {
        return false;
      }

      // Assigned sub-user
      if (selectedSubUser.value != null &&
          record.assignedTo != selectedSubUser.value) {
        return false;
      }

      if (selectedAgeing.value != null) {
        final ageing = record.ageingDays;

        switch (selectedAgeing.value) {
          case '0-15 days':
            if (ageing < 0 || ageing > 15) {
              return false;
            }
            break;

          case '16-30 days':
            if (ageing < 16 || ageing > 30) return false;
            break;

          case '31-60 days':
            if (ageing < 31 || ageing > 60) return false;
            break;

          case '>60 days':
            if (ageing <= 60) return false;
            break;
        }
      }

      // Application date filter
      if (!isWithinDateRange(
        record.dateOfApplication,
        _applicationStartDateController,
        _applicationEndDateController,
      )) {
        return false;
      }

      // Hearing date filter
      if (!isWithinDateRange(
        record.dateOfHearing,
        _hearingStartDateController,
        _hearingEndDateController,
      )) {
        return false;
      }

      return true;
    }).toList();

    _source.updateData(filteredRecords);
  }

  @override
  void dispose() {
    _applicationStartDateController.dispose();
    _applicatioIdController.dispose();
    _hearingStartDateController.dispose();
    _hearingEndDateController.dispose();
    _deductorNameController.dispose();
    _deductorTanController.dispose();
    selectedDeductorResp.dispose();
    selectedSubUser.dispose();
    selectedStatus.dispose();
    selectedAgeing.dispose();
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
                      InputField(
                        hintText: "Enter Name",
                        controller: _deductorNameController,
                        maxLength: 125,
                        showCounter: false,
                        onChanged: (value) => setState(() {}),
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
                      InputField(
                        controller: _deductorTanController,
                        hintText: "Enter TAN",
                        maxLength: 10,
                        showCounter: false,
                        onChanged: (value) => setState(() {}),
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
                      InputField(
                        controller: _applicatioIdController,
                        hintText: "Enter Application ID",
                        maxLength: 11,
                        showCounter: false,
                        onChanged: (value) => setState(() {}),
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
                              onChanged: (value) => setState(() {}),
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
                              onChanged: (value) => setState(() {}),
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
                        valueListenable: selectedDeductorResp,
                        onChanged: (value) {
                          setState(() {});
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
                        "Assigned To Sub-User",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      CustomDropdown(
                        items: MockData.assignedToSubUser,
                        hintText: "Yes/No",
                        valueListenable: selectedSubUser,
                        onChanged: (value) {
                          setState(() {});
                        },
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
                        valueListenable: selectedStatus,
                        onChanged: (value) {
                          setState(() {});
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
                              onChanged: (value) {
                                setState(() {});
                              },
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
                              onChanged: (value) {
                                setState(() {});
                              },
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
                        valueListenable: selectedAgeing,
                        onChanged: (value) {
                          setState(() {});
                        },
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
                  onPressed: isAnyFilterApplied() ? onSearch : null,
                  bgColor: isAnyFilterApplied()
                      ? AppTheme.primaryColor
                      : AppTheme.primaryColor.withValues(alpha: 0.7),
                  textColor: AppTheme.primaryWhite,
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),

                Button(
                  text: "Reset",
                  onPressed: isAnyFilterApplied() ? onReset : null,
                  textColor: isAnyFilterApplied()
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryText,
                  borderColor: isAnyFilterApplied()
                      ? AppTheme.primaryColor
                      : AppTheme.secondaryText,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => {},
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  child: Row(
                    spacing: 10,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.fileExcel,
                        color: Colors.green,
                        size: 20,
                      ),
                      Text(
                        "Export to Excel",
                        style: TextStyle(
                          color: AppTheme.hyperText,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.hyperText,
                          decorationThickness: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
