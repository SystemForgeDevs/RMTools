import 'package:flutter/material.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';
import 'package:rmtools/pages/tela_componentes.dart';

class TelaListaComponentes extends StatefulWidget { 
  final String nomePersonagem;
  const TelaListaComponentes({super.key, required this.nomePersonagem}); 
  
  @override
  State<TelaListaComponentes> createState() => _TelaListaComponentesState();
}

class _TelaListaComponentesState extends State<TelaListaComponentes> {
  List<String> poderes = [];
  int? selecionado;
  String? nomeSelecionado;
  
  Future<void> carregarPoderes() async {
    final ficha = FichaRepository();
    final retorno = await ficha.carregarNomesPoderes(widget.nomePersonagem);

    if(!mounted){
      return;
    }

    setState((){
      poderes = retorno;
    });
  }

  @override
  void initState(){
    super.initState();
    carregarPoderes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              
              //***Título***
              Text(
                "Componentes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),

              
              //Espaçamento
              const SizedBox(height: 20),

              
              //***Lista scrollável***
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    selecionado = null;
                  });
                },

                child: Container(
                  padding: EdgeInsets.all(6),//<--- isso faz com que os itens do listview não sumam/apareçam no limite do container
                  width: 300,
                  height: 520,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 49, 48, 48),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // listview de fato
                  child: Column(
                    children: [
                      // lista(Expanded faz a lista ocupar o espaço todo do container)
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: poderes.length,
                          itemBuilder: (context, index) {
                            final ativo = selecionado == index;

                            // Toque
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selecionado = index;
                                });
                              },

                              //label de seleção
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ativo
                                      ? const Color.fromARGB(255, 90, 90, 120)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  poderes[index],
                                  style: const TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),


                      //***Botões***
                      if (selecionado != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                              //***Excluir***
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  minimumSize: const Size(130, 40),
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 25
                                  )
                                ),
                                onPressed: () {
                                  setState((){
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false, //<-- isso nao deixa clicar fora para sair
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          backgroundColor: const Color.fromARGB(255, 21, 22, 34),
                                          title: Text(
                                            "Confimação",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                          content: Text(
                                            "Tem certeza que deseja excluir esta ficha?",
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
                                                "Cancelar",
                                                style: TextStyle(
                                                  color: Colors.grey
                                                ),
                                              ),
                                            ),

                                            //***Excluir***
                                            TextButton(
                                              onPressed: () async {
                                                final repo = FichaRepository();
                                                await repo.excluir(poderes[selecionado!]);

                                                if(!mounted){
                                                  return;
                                                }

                                                setState(() {
                                                  poderes.removeAt(selecionado!); 
                                                  selecionado = null;
                                                });

                                                // ignore: use_build_context_synchronously <-- isso vai ignorar o context sublinhado, eu já garanti que a tela esteja montada com o mounted mas vai dar certo
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Excluir",
                                                style: TextStyle(color: Colors.redAccent),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  });
                                },
                                child: const Text("Excluir"),
                              ),

                              //***Editar***
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  minimumSize: const Size(130, 40),
                                  foregroundColor: Colors.white,
                                  textStyle: TextStyle(
                                    fontSize: 25
                                  )
                                ),
                                onPressed: () {
                                  if(selecionado != null){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TelaPersonagemEditar(nomePersonagem: poderes[selecionado!])
                                      )
                                    );
                                  }
                                },
                              child: const Text("Editar"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              

              //***Espaçamento***
              const SizedBox(height: 20),


              //***Botão Adicionar ficha***
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 100),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaPoderes(nomePersonagem: widget.nomePersonagem)
                    )
                  );
                },
                child: const Text(
                  "Adicionar Componentes",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              

              //***Espaçamento***
              const SizedBox(height: 20),


              //***Botão Voltar***
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Voltar",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}