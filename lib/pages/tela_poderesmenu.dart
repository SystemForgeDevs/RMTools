import 'package:flutter/material.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';
import 'package:rmtools/pages/tela_listacomponentes.dart';

class TelaPoderesMenu extends StatelessWidget{
  final String nomePersonagem;
  const TelaPoderesMenu({super.key, required this.nomePersonagem});

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
                "Poderes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
                

              //***espaçamento***
              const SizedBox(height: 40),


              //***BOTÃO PODER***
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
                      builder: (context) => TelaListaComponentes(nomePersonagem: nomePersonagem),
                    )
                  );
                },
                  
                //texto botão
                child: const Text(
                  "Componentes", 
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),


              //***espaçamento***
              const SizedBox(height: 40),


              //***BOTÃO*** Extras
              ElevatedButton(
                  
                //tamanho botão
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 100)
                ),

                //função botão
                onPressed: () {},
                  
                //texto botão
                child: const Text(
                  "Extras", 
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
                onPressed: () {},
                  
                //texto botão
                child: const Text(
                  "Falhas", 
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            
              //***Espaçamento***
              Spacer(),

              //***Botao Voltar***
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TelaPersonagemEditar(nomePersonagem: nomePersonagem),
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
    );
  }
}