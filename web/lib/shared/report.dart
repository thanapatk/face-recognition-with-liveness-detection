import 'dart:collection';
import 'dart:convert';
import 'dart:html';

import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:web/models/log.dart';
import 'package:web/models/user.dart';

Future<void> downloadExcelFile({
  required int period,
  required DateTime dateTime,
  required String classroom,
  required List<UserLog> userLogs,
  required HashMap<String, UserData> userDatas,
}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  sheet.showGridlines = false;

  // define global style
  Style globalStyle = workbook.styles.add('style');
  globalStyle.fontName = 'TH Sarabun New';
  globalStyle.fontSize = 16;
  globalStyle.hAlign = HAlignType.center;
  globalStyle.vAlign = VAlignType.center;

  // set column width
  sheet.getRangeByName('A1:B1').columnWidth = 8.43;
  sheet.getRangeByName('C1:D1').columnWidth = 17;
  sheet.getRangeByName('E1:F1').columnWidth = 12.57;

  // create header
  Range header1 = sheet.getRangeByName('A1:F1');
  header1.merge();
  header1.cellStyle = globalStyle;
  header1.cellStyle.borders.all.lineStyle = LineStyle.thin;
  sheet.getRangeByName('A1').setText('รายงานการเข้าชั้นเรียน');

  Range header2 = sheet.getRangeByName('A2:F2');
  header2.cellStyle = globalStyle;
  sheet.getRangeByName('D2').cellStyle.hAlign = HAlignType.left;
  _applyOuterBorder(sheet, header2, LineStyle.thin);
  sheet.getRangeByName('A2').setText('คาบ');
  sheet.getRangeByName('B2').setText(period.toString());
  sheet.getRangeByName('C2').setText('วันที่');
  sheet
      .getRangeByName('D2')
      .setText(dateTime.toLocal().toString().split(' ').first);
  sheet.getRangeByName('E2').setText('ห้อง');
  sheet.getRangeByName('F2').setText(classroom);

  Range header3SchoolNum = sheet.getRangeByName('A3');
  header3SchoolNum.cellStyle = globalStyle;
  header3SchoolNum.cellStyle.borders.all.lineStyle = LineStyle.thin;
  header3SchoolNum.setText('รหัส');

  Range header3Name = sheet.getRangeByName('B3:D3');
  header3Name.merge();
  header3Name.cellStyle = globalStyle;
  header3Name.cellStyle.borders.all.lineStyle = LineStyle.thin;
  sheet.getRangeByName('B3').setText('ชื่อ-สกุล');

  Range header3Status = sheet.getRangeByName('E3');
  header3Status.cellStyle = globalStyle;
  header3Status.cellStyle.borders.all.lineStyle = LineStyle.thin;
  header3Status.setText('สถานะ');

  Range header3Time = sheet.getRangeByName('F3');
  header3Time.cellStyle = globalStyle;
  header3Time.cellStyle.borders.all.lineStyle = LineStyle.thin;
  header3Time.setText('เวลา');

  // รหัส	| ชื่อ-นามสกุล | สถานะ | เวลา
  userLogs.asMap().forEach((int i, UserLog log) {
    int row = i + 4;

    Range sidRange = sheet.getRangeByName("A$row");
    sidRange.cellStyle = globalStyle;
    sidRange.cellStyle.borders.all.lineStyle = LineStyle.thin;
    sidRange.setText(log.sid);

    Range nameRange = sheet.getRangeByName('B$row:D$row');
    nameRange.cellStyle = globalStyle;
    _applyOuterBorder(sheet, nameRange, LineStyle.thin);
    sheet.getRangeByName('C$row:D$row').cellStyle.hAlign = HAlignType.left;

    sheet.getRangeByName("B$row").setText(userDatas[log.sid]?.prefix);
    sheet.getRangeByName("C$row").setText(userDatas[log.sid]?.firstname);
    sheet.getRangeByName("D$row").setText(userDatas[log.sid]?.lastname);

    Range statusAndTimeRange = sheet.getRangeByName('E$row:F$row');
    statusAndTimeRange.cellStyle = globalStyle;
    statusAndTimeRange.cellStyle.borders.all.lineStyle = LineStyle.thin;

    sheet
        .getRangeByName('E$row')
        .setText(['เข้าเรียน', 'สาย'][log.status?.index ?? 0]);
    sheet.getRangeByName('F$row').setText(log.time);
  });

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  AnchorElement(
    href:
        "data:application/octet-stream;charset=utf-8;base64,${base64.encode(bytes)}",
  )
    ..setAttribute('download', 'report.xlsx')
    ..click();
}

void _applyOuterBorder(Worksheet sheet, Range range, LineStyle lineStyle) {
  range.cellStyle.borders.top.lineStyle = lineStyle;
  range.cellStyle.borders.bottom.lineStyle = lineStyle;

  sheet
      .getRangeByIndex(range.row, range.column)
      .cellStyle
      .borders
      .left
      .lineStyle = lineStyle;
  sheet
      .getRangeByIndex(range.lastRow, range.lastColumn)
      .cellStyle
      .borders
      .right
      .lineStyle = lineStyle;
}
