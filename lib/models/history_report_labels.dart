/// Already-localized wording for the human-readable history reports.
///
/// The export service builds PDF and text reports but must not hold UI
/// strings, so the screen passes this in with the words already chosen.
class HistoryReportLabels {
  final String reportHeading;
  final String reportTitle;
  final String exportDateLabel;
  final String totalScansLabel;
  final String scanNumberLabel;
  final String idLabel;
  final String timestampLabel;
  final String formatLabel;
  final String categoryLabel;
  final String safetyScoreLabel;
  final String starredLabel;
  final String starredYes;
  final String starredNo;
  final String locationLabel;
  final String notesLabel;
  final String contentLabel;
  final String columnDateTime;
  final String columnFormat;
  final String columnCategory;
  final String columnSafety;
  final String columnContent;
  final String columnNotes;

  const HistoryReportLabels({
    required this.reportHeading,
    required this.reportTitle,
    required this.exportDateLabel,
    required this.totalScansLabel,
    required this.scanNumberLabel,
    required this.idLabel,
    required this.timestampLabel,
    required this.formatLabel,
    required this.categoryLabel,
    required this.safetyScoreLabel,
    required this.starredLabel,
    required this.starredYes,
    required this.starredNo,
    required this.locationLabel,
    required this.notesLabel,
    required this.contentLabel,
    required this.columnDateTime,
    required this.columnFormat,
    required this.columnCategory,
    required this.columnSafety,
    required this.columnContent,
    required this.columnNotes,
  });
}
