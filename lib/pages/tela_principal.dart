// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:rmtools/pages/tela_listafichas.dart';
import 'package:rmtools/pages/tela_mestragremmenu.dart';


class TelaPrincipal extends StatelessWidget{

  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(

      //Scafold evita a linha amarela(sublinhado) no que tiver acima(eu acho)
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
        body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                
              //***Titulo*** 
              Text(
                "RMTools",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
                

              //***espaçamento***
              const SizedBox(height: 40),


              //***BOTÃO***
              ElevatedButton(
              
                //tamanho botão
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 100)
                ),

                //função botão
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaListaFicha(),
                    )
                  );
                },
                  
                //texto botão
                child: const Text(
                  "Ficha", 
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),


              //***espaçamento***
              const SizedBox(height: 40),


              //***BOTÃO*** MESTRAGEM
              ElevatedButton(
                  
                //tamanho botão
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 100)
                ),

                //função botão
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaMestragemMenu(),
                    )
                  );
                },
                  
                //texto botão
                child: const Text(
                  "Mestragem", 
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
          

              //***Imagem***
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 71),
                child: Image.asset(
                  'lib/img/logo.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              
            
              //***espaçamento***
              Spacer(),


              //***TEXTO ABAIXO***
              Text(
                "Idealizado e desenvolvido por Neto Porto e Kauã Keven.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500
                ),  
              )
            ],
          ),
        ),
      ),
    );
  }
}