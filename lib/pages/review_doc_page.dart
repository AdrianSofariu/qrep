import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:qrep/models/checklist_item.dart';
// ignore: library_prefixes
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/pdf.dart';

// ignore: must_be_immutable
class ReviewPDF extends StatefulWidget {
  List<ListItem> items = [];
  ReviewPDF({super.key, required this.items});

  @override
  State<ReviewPDF> createState() => _ReviewPDFState();
}

class _ReviewPDFState extends State<ReviewPDF> {
  final List<ListItem> _checkedItems = [];
  final TextEditingController _titleController = TextEditingController();

  //function to create the quiz as pdf
  Future<void> createDocument() async {
    //create the pdf variable
    final pdf = pdfWidgets.Document();
    final myfont = await PdfGoogleFonts.montserratRegular();

    //add content to the pdf
    pdf.addPage(
      pdfWidgets.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          //add the pdf title
          pdfWidgets.Row(
            mainAxisAlignment: pdfWidgets.MainAxisAlignment.center,
            children: [
              pdfWidgets.Text(
                _titleController.text,
                style: pdfWidgets.TextStyle(
                  font: myfont,
                  fontWeight: pdfWidgets.FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ],
          ),

          pdfWidgets.SizedBox(height: 20),

          //add title and text for each post
          for (int index = 0; index < _checkedItems.length; index++)
            pdfWidgets.Column(
              crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
              children: [
                pdfWidgets.Text(
                  '${index + 1}. ${_checkedItems[index].post.title}',
                  style: pdfWidgets.TextStyle(
                    font: myfont,
                    fontWeight: pdfWidgets.FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                pdfWidgets.SizedBox(height: 12),
                pdfWidgets.Text(
                  _checkedItems[index].post.text,
                  style: pdfWidgets.TextStyle(
                    font: myfont,
                    fontSize: 15,
                  ),
                  textAlign: pdfWidgets.TextAlign.justify,
                ),
                pdfWidgets.SizedBox(height: 20),
              ],
            )
        ],
      ),
    );

    // Preview the PDF document
    await Printing.layoutPdf(
      onLayout: (_) => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review the PDF'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Select the final batch of questions to add to your new quiz!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              //build a list of selectable items
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      title: Text(
                        widget.items[index].post.title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      value: widget.items[index].isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.items[index].isChecked = value!;
                        });
                      },
                      side: const BorderSide(color: Colors.green),
                    );
                  },
                ),
              ),
              //quiz title
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'quiz title...',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 40),
              //create the pdf on button click
              ElevatedButton(
                onPressed: () {
                  _checkedItems.clear();
                  for (var item in widget.items) {
                    if (item.isChecked) {
                      _checkedItems.add(item);
                    }
                  }
                  createDocument();
                },
                child: const Text(
                  'Create Quiz!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
