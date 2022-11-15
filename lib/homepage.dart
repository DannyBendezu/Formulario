import 'package:flutter/material.dart';
import 'package:sqlite_crud/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All data
  List<Map<String, dynamic>> myData = [];
  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData(); // Loading the data when the app starts
  }

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _fechanaciController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _creditoController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showMyForm(int? id) async {
    // id == null -> create new item
    // id != null -> update an existing item
    if (id != null) {
      final existingData = myData.firstWhere((element) => element['id'] == id);
      _nombreController.text = existingData['title'];
      _apellidosController.text = existingData['description'];
      _fechanaciController.text = existingData['title'];
      _direccionController.text = existingData['description'];
      _estadoController.text = existingData['title'];
      _creditoController.text = existingData['description'];
    } else {
      _nombreController.text = "";
      _apellidosController.text = "";
      _fechanaciController.text = "";
      _direccionController.text = "";
      _estadoController.text = "";
      _creditoController.text = "";
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              // prevent the soft keyboard from covering the text fields
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    validator: formValidator,
                    decoration: const InputDecoration(hintText: 'Nombre'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: formValidator,
                    controller: _apellidosController,
                    decoration: const InputDecoration(hintText: 'Apellidos'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _fechanaciController,
                    validator: formValidator,
                    decoration:
                        const InputDecoration(hintText: 'Fecha de Nacimiento'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _direccionController,
                    validator: formValidator,
                    decoration: const InputDecoration(hintText: 'Direccion'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _estadoController,
                    validator: formValidator,
                    decoration: const InputDecoration(hintText: 'Estado'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _creditoController,
                    validator: formValidator,
                    decoration: const InputDecoration(hintText: 'Credito'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Salir")),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (id == null) {
                              await addItem();
                            }

                            if (id != null) {
                              await updateItem(id);
                            }

                            // Clear the text fields
                            setState(() {
                              _nombreController.text = '';
                              _apellidosController.text = '';
                              _fechanaciController.text = '';
                              _direccionController.text = '';
                              _estadoController.text = '';
                              _creditoController.text = '';
                            });

                            // Close the bottom sheet
                            Navigator.pop(context);
                          }
                          // Save new data
                        },
                        child: Text(id == null ? 'Crear' : 'Update'),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Complete sus Datos';
    return null;
  }

// Insert a new data to the database
  Future<void> addItem() async {
    await DatabaseHelper.createItem(
      _nombreController.text,
      _apellidosController.text,
      _fechanaciController.text,
      _direccionController.text,
      _estadoController.text,
      _creditoController.text,
    );
    _refreshData();
  }

  // Update an existing data
  Future<void> updateItem(int id) async {
    await DatabaseHelper.updateItem(
      id,
      _nombreController.text,
      _apellidosController.text,
      _fechanaciController.text,
      _direccionController.text,
      _estadoController.text,
      _creditoController.text,
    );
    _refreshData();
  }

  // Delete an item
  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'), backgroundColor: Colors.green));
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FORMULARIO'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : myData.isEmpty
              ? const Center(child: Text("DATOS GUARDADOS"))
              : ListView.builder(
                  itemCount: myData.length,
                  itemBuilder: (context, index) => Card(
                    color: index % 2 == 0 ? Colors.green : Colors.green[200],
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                        title: Text(myData[index]['title']),
                        subtitle: Text(myData[index]['description']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    showMyForm(myData[index]['id']),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    deleteItem(myData[index]['id']),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showMyForm(null),
      ),
    );
  }
}
