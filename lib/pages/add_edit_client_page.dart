import 'package:flutter/material.dart';
import 'package:registro_de_usuarios/model/client_model.dart';
import 'package:registro_de_usuarios/database/database.dart';
import 'package:registro_de_usuarios/pages/home_page.dart';
import 'package:registro_de_usuarios/widgets/text_form_field.dart';

class AddEditClientPage extends StatefulWidget {
  static const String route = 'add_edit_client';

  final bool edit;
  final Client? client;

  // ignore: use_key_in_widget_constructors
  const AddEditClientPage(this.edit, {this.client})
      : assert(edit == true || client == null);

  @override
  _AddEditClientPageState createState() => _AddEditClientPageState();
}

class _AddEditClientPageState extends State<AddEditClientPage> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      nameEditingController.text = widget.client!.name;
      addressEditingController.text = widget.client!.address;
      phoneEditingController.text = widget.client!.phone;
      emailEditingController.text = widget.client!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? 'Editar Cliente' : 'Añadir Cliente'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                const FlutterLogo(size: 200),
                const SizedBox(height: 20.0),
                textFormField(
                  nameEditingController,
                  'Nombre',
                  'Introduzca el nombre',
                  Icons.person,
                  widget.edit ? widget.client!.name : "Nombre",
                  TextInputType.text,
                ),
                const SizedBox(height: 10.0),
                textFormField(
                  addressEditingController,
                  'Dirección',
                  'Introduzca la dirección',
                  Icons.home,
                  widget.edit ? widget.client!.address : "Dirección",
                  TextInputType.text,
                ),
                const SizedBox(height: 10.0),
                textFormField(
                  phoneEditingController,
                  'Teléfono',
                  'Introduzca el teléfono',
                  Icons.phone,
                  widget.edit ? widget.client!.phone : "Teléfono",
                  TextInputType.phone,
                ),
                const SizedBox(height: 10.0),
                textFormField(
                  emailEditingController,
                  'Correo electrónico',
                  'Introduzca el correo electrónico',
                  Icons.email,
                  widget.edit ? widget.client!.email : "Correo electrónico",
                  TextInputType.emailAddress,
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(18.0),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      const Size(380, 50),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dato(s) inválido(s)'),
                        ),
                      );
                    } else if (widget.edit == true) {
                      await ClientDatabaseProvider.db.updateClient(
                        client(true),
                      );
                      _changeAndRemovePage(context, HomePage.route);
                    } else {
                      int consulta =
                          await ClientDatabaseProvider.db.addClientToDatabase(
                        client(false),
                      );
                      if (consulta == -1) {
                        _showAlert(context);
                        return;
                      }
                      _changeAndRemovePage(context, HomePage.route);
                    }
                  },
                ),
                const SizedBox(height: 60.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Center(child: Text('¡El usuario ya existe!')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              const Text('Cambie de correo por favor'),
              const FlutterLogo(
                size: 100.0,
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Client client(bool update) {
    return Client(
      name: nameEditingController.text,
      address: addressEditingController.text,
      phone: phoneEditingController.text,
      email: emailEditingController.text,
      id: update ? widget.client!.id : null,
    );
  }

  _changeAndRemovePage(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
  }
}
