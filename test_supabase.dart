import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  var url = Uri.parse('https://olifzzukugzbckppxnke.supabase.co/rest/v1/products?select=*&limit=5');
  var response = await http.get(url, headers: {
    'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9saWZ6enVrdWd6YmNrcHB4bmtlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NTcyNzksImV4cCI6MjA3NTAzMzI3OX0.kAMMFVWCJLphep5BB3QgeXRhpGd0qdmFGgtJcn6d3NM',
    'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9saWZ6enVrdWd6YmNrcHB4bmtlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0NTcyNzksImV4cCI6MjA3NTAzMzI3OX0.kAMMFVWCJLphep5BB3QgeXRhpGd0qdmFGgtJcn6d3NM'
  });
  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');
}
