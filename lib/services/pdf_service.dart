import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/user_model.dart';
import '../models/symptom_model.dart';
import '../models/medication_model.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<void> generateAndPrintReport({
    required UserModel user,
    required List<SymptomModel> symptoms,
    required List<Medication> medications,
  }) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) {
          return [
            _buildHeader(user),
            pw.SizedBox(height: 20),
            _buildPersonalSection(user),
            pw.SizedBox(height: 20),
            _buildMedicationSection(medications),
            pw.SizedBox(height: 20),
            _buildSymptomSection(symptoms),
            pw.SizedBox(height: 40),
            pw.Divider(),
            pw.Text(
              'Ushbu hisobot DGI Health ilovasi tomonidan yaratildi.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'DGI_Health_Hisobot_${user.firstName}.pdf',
    );
  }

  pw.Widget _buildHeader(UserModel user) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'TIBBIY HISOBOT',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
            pw.Text(DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())),
          ],
        ),
        pw.Text(
          'DGI Health',
          style: pw.TextStyle(fontSize: 18, color: PdfColors.blueGrey),
        ),
      ],
    );
  }

  pw.Widget _buildPersonalSection(UserModel user) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Foydalanuvchi ma\'lumotlari',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            pw.Text('Ism: '),
            pw.Text(
              '${user.firstName} ${user.lastName}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.Row(children: [pw.Text('Yosh: '), pw.Text('${user.age}')]),
        pw.Row(
          children: [
            pw.Text('Tashxis: '),
            pw.Text(
              user.diagnosis,
              style: pw.TextStyle(
                color: PdfColors.red,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.Row(
          children: [pw.Text('BMI: '), pw.Text(user.bmi.toStringAsFixed(1))],
        ),
      ],
    );
  }

  pw.Widget _buildMedicationSection(List<Medication> medications) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Qabul qilinayotgan dorilar',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.TableHelper.fromTextArray(
          headers: ['Nomi', 'Dozasi', 'Vaqti', 'Holati'],
          data: medications
              .map(
                (m) => [
                  m.name,
                  m.dose ?? '-',
                  m.times.join(', '),
                  m.reminderEnabled ? 'Yoqilgan' : 'O\'chirilgan',
                ],
              )
              .toList(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
        ),
      ],
    );
  }

  pw.Widget _buildSymptomSection(List<SymptomModel> symptoms) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Semptomlar tarixi (Oxirgi 30 kun)',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        if (symptoms.isEmpty)
          pw.Text('Ma\'lumotlar mavjud emas.')
        else
          pw.TableHelper.fromTextArray(
            headers: ['Sana', 'Semptomlar', 'Og\'riq darajasi'],
            data: symptoms
                .map(
                  (s) => [
                    DateFormat('dd.MM.yyyy').format(s.date),
                    s.symptoms.join(', '),
                    '${s.painLevel}/10',
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
          ),
      ],
    );
  }
}
