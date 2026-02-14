import 'package:flutter/material.dart';
import 'package:rmtools/pages/tela_habilidades.dart';
import 'package:rmtools/pages/tela_listafichas.dart';
import 'package:rmtools/pages/tela_pericias.dart';
import 'package:rmtools/pages/tela_vantagens.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';

class TelaPersonagemEditar extends StatefulWidget{
  final String nomePersonagem;
  const TelaPersonagemEditar({super.key, required this.nomePersonagem});

  @override
  State<TelaPersonagemEditar> createState() => _TelaPersonagemEditarState();
}

class _TelaPersonagemEditarState extends State<TelaPersonagemEditar> {
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      body: Column(
        children: [
          //***Titulo*** fora do scroll pra ficar fixo
          Padding(
            padding: const EdgeInsets.only(top:20),
            child: Text(
              "Ficha do(a) ${widget.nomePersonagem}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.w500
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(//<--- isso faz com que eu coloque os widgets normalmente sem me preocupar com o tamanho do nome do personagem, já que ele libera um scroll caso "Falte tela"
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      //***BOTÃO info basica***
                      ElevatedButton(
                          
                        //tamanho botão
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(300, 100)
                        ),

                        //função botão
                        onPressed: () {},
                          
                        //texto botão
                        child: const Text(
                          "Informações básicas", 
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
                              builder: (context) => TelaHabilidades(nomePersonagem: widget.nomePersonagem),
                          ),
                        );
                      },
                        
                      //texto botão
                      child: const Text(
                        "Habilidades", 
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaPericias(nomePersonagem: widget.nomePersonagem),
                          ),
                        );
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaVantagens(nomePersonagem: widget.nomePersonagem),
                          ),
                        );
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


                      //***BOTÃO Poderes***
                      ElevatedButton(
                        
                      //tamanho botão
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 100)
                      ),

                      //função botão
                      onPressed: () async {
                        final repo = FichaRepository();

                        final ficha = await repo.carregar(widget.nomePersonagem);

                        if (ficha != null) {
                          repo.exportarFicha(ficha);
                        }

                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          barrierDismissible: false, //<-- isso nao deixa clicar fora para sair
                          builder: (BuildContext context){
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 21, 22, 34),
                              title: Text(
                                "Exportando...",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              content: Text(
                                "A ficha foi Exportada para PDF com Sucesso!",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              actions: [
                                
                                //***Cancelar
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();//<-- fecha o pop-up
                                  },
                                  child: Text(
                                    "Fechar",
                                    style: TextStyle(
                                      color: Colors.grey
                                    ),
                                  ),
                                ),
                              ]
                            );
                          },
                        );
                      },
                        
                      //texto botão
                      child: const Text(
                        "Exportar", 
                        style: TextStyle(
                          fontSize: 25,
                          ),
                        ),
                      ),


                      //***espaçamento***
                      const SizedBox(height: 40),


                      //***Botao Voltar***
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 50),
                        ),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TelaListaFicha(),
                            ),
                          );
                        },
                        child: const Text(
                          "Voltar",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}