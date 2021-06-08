import 'package:flutter/material.dart';
import 'package:registro_de_usuarios/pages/add_edit_client_page.dart';
import 'package:registro_de_usuarios/database/database.dart';
import 'package:registro_de_usuarios/model/client_model.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  static const String route = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de usuarios'),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              ClientDatabaseProvider.db.deleteAllClients();
              setState(() {});
            },
            child: const Text(
              'Borrar todos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Client>>(
        future: ClientDatabaseProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Client item = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (DismissDirection direction) {
                    ClientDatabaseProvider.db.deleteClientWithId(item.id);
                  },
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.phone),
                    leading: CircleAvatar(
                      child: Text(item.id.toString()),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => AddEditClientPage(
                            true,
                            client: item,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddEditClientPage.route);
        },
      ),
    );
  }
}
