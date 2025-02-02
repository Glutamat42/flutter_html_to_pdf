import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/file_utils.dart';

/// HTML to PDF Converter
class FlutterHtmlToPdf {
  static const MethodChannel _channel =
      const MethodChannel('flutter_html_to_pdf');

  /// Creates PDF Document from HTML content
  static Future<File> convertFromHtmlContent(String htmlContent, String targetDirectory, String targetName, int pageLength) async {
    var temporaryCreatedHtmlFile = await FileUtils.createFileWithStringContent(htmlContent, "$targetDirectory/$targetName.html");
    var generatedPdfFilePath = await _convertFromHtmlFilePath(temporaryCreatedHtmlFile.path, pageLength);
    var generatedPdfFile = FileUtils.copyAndDeleteOriginalFile(generatedPdfFilePath, targetDirectory, targetName);
    temporaryCreatedHtmlFile.delete();

    return generatedPdfFile;
  }

  /// Creates PDF Document from File that contains HTML content
  static Future<File> convertFromHtmlFile(File htmlFile, String targetDirectory, String targetName, int pageLength) async {
    var generatedPdfFilePath = await _convertFromHtmlFilePath(htmlFile.path, pageLength);
    var generatedPdfFile = FileUtils.copyAndDeleteOriginalFile(generatedPdfFilePath, targetDirectory, targetName);

    return generatedPdfFile;
  }

  /// Creates PDF Document from path to File that contains HTML content
  static Future<File> convertFromHtmlFilePath(String htmlFilePath, String targetDirectory, String targetName, int pageLength) async {
    var generatedPdfFilePath = await _convertFromHtmlFilePath(htmlFilePath, pageLength);
    var generatedPdfFile = FileUtils.copyAndDeleteOriginalFile(generatedPdfFilePath, targetDirectory, targetName);

    return generatedPdfFile;
  }
  
  static Future<String> _convertFromHtmlFilePath(String htmlFilePath, int pageLength) async {
    return await _channel.invokeMethod('convertHtmlToPdf', <String, dynamic>{
      'htmlFilePath': htmlFilePath,
      'pageLength': pageLength
    });
  }
}
