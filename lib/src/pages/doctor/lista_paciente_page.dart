import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_covid_asistencia/src/models/doctor/paciente_model.dart';
import 'package:flutter_covid_asistencia/src/models/doctor/pacientes_model.dart';
//import 'package:flutter_covid_asistencia/src/pages/doctor/lista_vertical.dart';
import 'package:flutter_covid_asistencia/src/providers/doctor/pacientes_provider.dart';

class ListaPacientePage extends StatelessWidget {
  PacientesProvider _pacientesProvider = new PacientesProvider();

  ListaPacientePage(){
    _pacientesProvider.getPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LISTA DE PACIENTES"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _listaPacientes(context),
          ]
        ),
      ),
    );
  }

  Widget _listaPacientes(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          FutureBuilder<List<Paciente>>(
            future: _pacientesProvider.getPacientes(),
            builder: (context, snapshot){
              if( snapshot.hasData ){
                print('SNAPSHOT');
                print(snapshot.data);
                return _listaVertical( context ,pacientes: snapshot.data);
              } else {
                return Center(child: CircularProgressIndicator(),);
              }
            }
          )
        ],
      ),
    );
  }

  Widget _listaVertical( BuildContext context, {List<Paciente> pacientes}) {
    Paciente pacienteUnico = new Paciente();
    final tarjetaPaciente = Container(
      height: 200,
      child: PageView.builder(
          pageSnapping: false,
          controller: PageController(
              viewportFraction: 0.32,
              initialPage: 0
          ),
          itemCount: pacientes.length,
          itemBuilder: (context, index){
            print("Pacientes");
            print(pacientes[index].name);
            pacienteUnico = pacientes[index];
            return Column(
              children: <Widget>[
                Hero(
                  tag: pacientes[index].id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                      image: NetworkImage(pacientes[index].getProfilePath()),
                      placeholder: AssetImage("images/no-image.jpg"),
                      height: 150.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text( pacientes[index].name ),
              ],
            );
          }
      ),
    );

    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "detalle_paciente", arguments: pacienteUnico);
      },
      child: tarjetaPaciente,
    );
  }
}
