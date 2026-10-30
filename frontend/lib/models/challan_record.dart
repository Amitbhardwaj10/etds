class ChallanRecord {
  final String applicationId;
  final String deductorTan;
  final String deductorName;
  final String dateOfApplication;
  final String status;
  final int ageingDays;
  final String deductorResponse;
  final String dateOfHearing;
  final String assignedTo;

  bool selected;

  ChallanRecord({
    required this.applicationId,
    required this.deductorTan,
    required this.deductorName,
    required this.dateOfApplication,
    required this.status,
    required this.ageingDays,
    required this.deductorResponse,
    required this.dateOfHearing,
    required this.assignedTo,
    this.selected = false,
  });
}
