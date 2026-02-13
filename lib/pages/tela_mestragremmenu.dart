import 'package:flutter/material.dart';
import 'package:rmtools/pages/tela_principal.dart';
import 'package:rmtools/pages/tela_rolagemsimples.dart';
import 'package:rmtools/pages/tela_rolagemgraduada.dart';

class TelaMestragemMenu extends StatefulWidget{
  const TelaMestragemMenu({super.key});

  @override
  State<TelaMestragemMenu> createState() => _TelaMestragemMenuState();
}

class _TelaMestragemMenuState extends State<TelaMestragemMenu> {
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      body: Column(
        children: [

          Expanded(//<--- isso faz com que eu coloque os widgets normalmente sem me preocupar com o tamanho do nome do personagem, já que ele libera um scroll caso "Falte tela"
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    //***Titulo***
                    Padding(padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        "Tipos Rolagens",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    //***BOTÃO Rolagem Simples***
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
                            builder: (context) => const TelaRolagemSimples(),
                          ),
                        );
                      },
                        
                      //texto botão
                      child: const Text(
                        "Rolagem Simples", 
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ),


                    //***espaçamento***
                    const SizedBox(height: 40),


                    //***BOTÃO Habilidades***
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
                            builder: (context) => const TelaRolagemGraduada(),
                          ),
                        );
                    },
                      
                    //texto botão
                    child: const Text(
                      "Rolagem Graduada", 
                      style: TextStyle(
                        fontSize: 25,
                        ),
                      ),
                    ),
                    

                    //***espaçamento***
                    const SizedBox(height: 40),


                    //***BOTÃO Perícias***
                    ElevatedButton(
                      
                    //tamanho botão
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 100)
                    ),

                    //função botão
                    onPressed: () {
                      
                    },
                      
                    //texto botão
                    child: const Text(
                      "Perícias", 
                      style: TextStyle(
                        fontSize: 25,
                        ),
                      ),
                    ),


                    //***espaçamento***
                    const SizedBox(height: 40),


                    //***BOTÃO Vantagens***
                    ElevatedButton(
                      
                    //tamanho botão
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 100)
                    ),

                    //função botão
                    onPressed: () {
                      
                    },
                      
                    //texto botão
                    child: const Text(
                      "Vantagens", 
                      style: TextStyle(
                        fontSize: 25,
                        ),
                      ),
                    ),


                    //***espaçamento***
                    const SizedBox(height: 40),

                    //***espaçamento***
                    Spacer(),

                    //***Botao Voltar***
                    Padding(padding: const EdgeInsets.only(bottom:30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaPrincipal(),
                            ),
                          );
                        },
                        child: const Text(
                          "Voltar",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}