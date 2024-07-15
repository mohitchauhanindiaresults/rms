import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

// Assume this widget is part of your UI
class HtmlTableDisplay extends StatelessWidget {
  final String htmlData; // HTML data to parse

  HtmlTableDisplay({required this.htmlData});

  @override
  Widget build(BuildContext context) {
    List<TableRow> tableRows = _parseHtmlToTableRows(htmlData);

    return Table(
      border: TableBorder.all(width: 1.0, color: Colors.grey), // Optional border decoration
      children: [
        // Header row, if needed
        // TableRow(
        //   children: [
        //     TableCell(
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //           'Header Column 1',
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ),
        //     TableCell(
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Text(
        //           'Header Column 2',
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // Data rows
        ...tableRows,
      ],
    );
  }
  List<TableRow> _parseHtmlToTableRows(String htmlData) {
    var document = parse(htmlData);
    var rows = document.getElementsByTagName('tr');

    return rows.map((row) {
      var cells = row.getElementsByTagName('td');
      if (cells.isEmpty) {
        cells = row.getElementsByTagName('th'); // Handle header row
      }

      return TableRow(
        children: cells.map((cell) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            // child: Text(
            //   cell.text.trim(),
            //   style: TextStyle(fontSize: 14),
            // ),
          );
        }).toList(),
      );
    }).toList();
  }

}
