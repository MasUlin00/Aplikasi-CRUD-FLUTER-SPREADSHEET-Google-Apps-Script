import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Flutter & Google Apps Script',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/tambah': (context) => const TambahPage(),
        '/lihat': (context) => const LihatPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tambah');
              },
              child: const Text('Tambah Buku'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/lihat');
              },
              child: const Text('Lihat Data Buku'),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  _TambahPageState createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController penulisController = TextEditingController();
  TextEditingController penerbitController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController kurikulumController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController kelasController = TextEditingController();

  Future<void> tambahData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzVHzyc7Kl50Pu3avPSNERr82C-2pjJ7Ddvx6fbbMvIR8OcJNUHHAFzBWV_hqjIQIWc/exec?tambahDataBuku=${judulController.text}&${penulisController.text}&${penerbitController.text}&${hargaController.text}&${kurikulumController.text}&${semesterController.text}&${kelasController.text}'));

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Gagal menambahkan data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: penulisController,
              decoration: const InputDecoration(labelText: 'Penulis'),
            ),
            TextField(
              controller: penerbitController,
              decoration: const InputDecoration(labelText: 'Penerbit'),
            ),
            TextField(
              controller: hargaController,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: kurikulumController,
              decoration: const InputDecoration(labelText: 'Kurikulum'),
            ),
            TextField(
              controller: semesterController,
              decoration: const InputDecoration(labelText: 'Semester'),
            ),
            TextField(
              controller: kelasController,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                tambahData();
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      ),
    );
  }
}

class LihatPage extends StatefulWidget {
  const LihatPage({super.key});

  @override
  _LihatPageState createState() => _LihatPageState();
}

class _LihatPageState extends State<LihatPage> {
  List<List<dynamic>> _bookData = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzVHzyc7Kl50Pu3avPSNERr82C-2pjJ7Ddvx6fbbMvIR8OcJNUHHAFzBWV_hqjIQIWc/exec'));

    if (response.statusCode == 200) {
      setState(() {
        _bookData = List<List<dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Gagal memuat data dari API');
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Buku'),
      ),
      body: _bookData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bookData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_bookData[index][0]),
                  subtitle: Text(_bookData[index][1]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      hapusData(index + 1);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePage(
                          judul: _bookData[index][0],
                          penulis: _bookData[index][1],
                          penerbit: _bookData[index][2],
                          harga: _bookData[index][3],
                          kurikulum: _bookData[index][4],
                          semester: _bookData[index][5],
                          kelas: _bookData[index][6],
                          index: index + 1,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> hapusData(int index) async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzVHzyc7Kl50Pu3avPSNERr82C-2pjJ7Ddvx6fbbMvIR8OcJNUHHAFzBWV_hqjIQIWc/exec?hapusDataBuku=$index'));

    if (response.statusCode == 200) {
      fetchData();
    } else {
      throw Exception('Gagal menghapus data');
    }
  }
}

class UpdatePage extends StatefulWidget {
  final String judul;
  final String penulis;
  final String penerbit;
  final String harga;
  final String kurikulum;
  final String semester;
  final String kelas;
  final int index;

  const UpdatePage({
    super.key,
    required this.judul,
    required this.penulis,
    required this.penerbit,
    required this.harga,
    required this.kurikulum,
    required this.semester,
    required this.kelas,
    required this.index,
  });

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController penulisController = TextEditingController();
  TextEditingController penerbitController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController kurikulumController = TextEditingController();
  TextEditingController semesterController = TextEditingController();
  TextEditingController kelasController = TextEditingController();

  @override
  void initState() {
    judulController.text = widget.judul;
    penulisController.text = widget.penulis;
    penerbitController.text = widget.penerbit;
    hargaController.text = widget.harga;
    kurikulumController.text = widget.kurikulum;
    semesterController.text = widget.semester;
    kelasController.text = widget.kelas;
    super.initState();
  }

  Future<void> updateData() async {
    final response = await http.get(Uri.parse(
        'https://script.google.com/macros/s/AKfycbzVHzyc7Kl50Pu3avPSNERr82C-2pjJ7Ddvx6fbbMvIR8OcJNUHHAFzBWV_hqjIQIWc/exec?perbaruiDataBuku=${widget.index}&${judulController.text}&${penulisController.text}&${penerbitController.text}&${hargaController.text}&${kurikulumController.text}&${semesterController.text}&${kelasController.text}'));

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Gagal memperbarui data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbarui Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: penulisController,
              decoration: const InputDecoration(labelText: 'Penulis'),
            ),
            TextField(
              controller: penerbitController,
              decoration: const InputDecoration(labelText: 'Penerbit'),
            ),
            TextField(
              controller: hargaController,
              decoration: const InputDecoration(labelText: 'Harga'),
            ),
            TextField(
              controller: kurikulumController,
              decoration: const InputDecoration(labelText: 'Kurikulum'),
            ),
            TextField(
              controller: semesterController,
              decoration: const InputDecoration(labelText: 'Semester'),
            ),
            TextField(
              controller: kelasController,
              decoration: const InputDecoration(labelText: 'Kelas'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateData();
              },
              child: const Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }
}
