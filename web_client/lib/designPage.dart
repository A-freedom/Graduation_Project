// designPage.dart
import 'package:json_table/json_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'tools.dart';
import 'dataStructure.dart';
import 'filter.dart';

class DesignPage extends StatefulWidget {
  const DesignPage({Key? key});

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {

  @override
  Widget build(BuildContext context) {
    var myJson = Provider.of<JsonManager>(context, listen: true).getJson ;
    var columns = [
      JsonTableColumn('L (mm)', label: 'L (mm)'),
      JsonTableColumn('AISC_Manual_Label', label: 'SECTION NAME'),
      JsonTableColumn('W Kg/m', label: 'W (Kg/m)'),
      JsonTableColumn('b (mm)', label: 'b (mm)'),
      JsonTableColumn('h (mm)', label: 'h (mm)'),
      JsonTableColumn('t (mm)', label: 't (mm)'),
      JsonTableColumn('fc (MPa)', label: 'fc (MPa)'),
      JsonTableColumn('fy (MPa)', label: 'fy (MPa)'),
      JsonTableColumn('ΦP ANN (kN)', label: 'ΦP ANN (kN))'),
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('D E S I G N'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          // child: Form(
          //   key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Consumer<FilterManager>(
                    builder: (context, filterManager, _) {
                      return ListView.builder(
                        itemCount: filterManager.filters.length,
                        itemBuilder: (context, index) {
                          return FilterItem(
                            key: UniqueKey(),
                            filter: filterManager.filters[index],
                            onDelete: () {
                              setState(() {
                                filterManager.removeAt(index);
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                myJson.isEmpty
                    ? const Expanded(
                      child: Center(
                          child: Text('N O  R E S U L T'),
                        ),
                    )
                    : Expanded(
                        flex: 2,
                        child: JsonTable(myJson,
                            // paginationRowCount: 5,
                            columns: columns,
                            showColumnToggle: true,
                            allowRowHighlight: true,
                            rowHighlightColor:
                                Colors.deepOrangeAccent.withOpacity(0.7),
                            filterTitle: '', tableHeaderBuilder: (String? header) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                color: Colors.grey[300]),
                            child: Text(
                              header!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.0,
                                      color: Colors.black87),
                            ),
                          );
                        }, tableCellBuilder: (value) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.grey.withOpacity(0.5))),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontSize: 14.0),
                            ),
                          );
                        }),
                      ),
              ],
            ),
          // ),
        ),
        bottomNavigationBar: const My_GNAV(selectedIndex: 1),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              final availableColumns = Provider.of<FilterManager>(context,
                      listen: false)
                  .columns
                  .where((column) =>
                      !Provider.of<FilterManager>(context, listen: false)
                          .filters
                          .any((filter) => filter.selectedColumn == column))
                  .toList();

              if (availableColumns.isNotEmpty) {
                Provider.of<FilterManager>(context, listen: false).addFilter(
                    Filter(selectedColumn: availableColumns.first));
              }
            }),
      ),
    );
  }
}
