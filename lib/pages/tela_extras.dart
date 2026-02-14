import 'package:flutter/material.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';

class TelaExtras extends StatefulWidget{
  final String nomePersonagem;
  const TelaExtras({super.key, required this.nomePersonagem});

  @override
  State<TelaExtras> createState() => _TelaExtras();
}

class _TelaExtras extends State<TelaExtras>{
  @override
  void initState(){
    super.initState();
    _lerJson();
  }
    
  int esquiva = 0;
  int fortitude =  0;
  int resistencia = 0;
  int aparar = 0;
  int vontade = 0;
  int pontosDisponiveis = 0;


  //***Ler o json***
  Future<void> _lerJson() async{
    final repositorio = FichaRepository();
    final ficha = await repositorio.carregar(widget.nomePersonagem);

    if(ficha != null){
      setState(() {
        esquiva = ficha.esquiva;
        fortitude = ficha.fortitude;
        resistencia = ficha.resistencia;
        aparar = ficha.aparar;
        vontade = ficha.vontade;
        pontosDisponiveis = ficha.pontosD;
      });
    }
  }
  
  //***Método de alterar as habilidades e pontos***
  Future<void> alterar(String chave, int valor, Function(int,int) atualizar) async {
    final repo = FichaRepository();
    final ficha = await repo.carregar(widget.nomePersonagem);

    if (ficha != null && ficha.adicionarDefesas(chave, valor)) {
      await repo.salvar(ficha);

      await _lerJson(); //recarrega os valores na tela
    }
  }

  //***Método UI que resolve a repetição***
  Widget extraUI(String label, String chave, int valor, Function(int,int) atualizar) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 35)),
          Row(
            children: [

              //diminuir
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                iconSize: 30,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => alterar(chave, -1, atualizar),
              ),

              //espaçamento
              const SizedBox(width: 15),

              //valor
              Text("$valor", style: const TextStyle(color: Colors.white, fontSize: 40)),
              
              //espaçamento
              const SizedBox(width: 15),
              
              //adicionar
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                iconSize: 30,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => alterar(chave, 1, atualizar),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      body: Column(
        children: [

          //***Botao de duvida e pontos***
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                // Botão de ajuda
                IconButton(
                  icon: const Icon(Icons.help, color: Colors.white),
                  iconSize: 35,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Color.fromARGB(255, 21, 22, 34),
                        title: Text("Ajuda", style: TextStyle(color: Colors.white)),
                        content: SizedBox(
                          height: 350,
                          width: 300,
                          child: SingleChildScrollView(
                            child: Text(
                              "Habilidades são como o sistema chama os atributos, ex: força. "
                              "Cada graduação em uma habilidade custa 2 pontos de poder, retirar concede 2 pontos,"
                              " contudo tem um limite de quanto você consegue retirar de graduações, o limite é até -5 de graduação"
                              "Segue a escala (material oficial):\n\n"
                              "-5 — Completamente inepto\n"
                              "-4 — Criança muito nova (<6 anos)\n"
                              "-3 — Criança nova (7-9)\n"
                              "-2 — Criança (10-13), idoso ou debilitado\n"
                              "-1 — Abaixo da média; adolescente\n"
                              "0 — Adulto médio\n"
                              "1 — Acima da média\n"
                              "2 — Bem acima da média\n"
                              "3 — Talentoso\n"
                              "4 — Altamente talentoso\n"
                              "5 — O melhor de um país\n"
                              "6 — Um dos melhores do mundo\n"
                              "7 — Ápice humano\n"
                              "8 — Super-humano fraco\n"
                              "10 — Super-humano moderado\n"
                              "13 — Super-humano poderoso\n"
                              "15 — Super-humano muito poderoso\n"
                              "20 — Cósmico",
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Fechar",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 22,
                              )
                            )
                          ),
                        ]
                      ),
                    );
                  },
                ),

                // Pontos disponíveis
                Text(
                  "Pontos disponíveis: $pontosDisponiveis",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

        
          //***Força***
          extraUI("Esquiva:", "esquiva", esquiva, (v, p){
            setState(() {
              esquiva = v;
              pontosDisponiveis = p;
            });
          }),


          //***Agilidade***
          extraUI("Aparar:", "aparar", aparar, (v, p){
            setState(() {
              aparar = v;
              pontosDisponiveis = p;
            });
          }),


          //***Destreza***
          extraUI("Fortitude:", "fortitude", fortitude, (v, p){
            setState(() {
              fortitude = v;
              pontosDisponiveis = p;
            });
          }),


          //***Luta***
          extraUI("Resistência:", "resistencia", resistencia, (v, p){
            setState(() {
              resistencia = v;
              pontosDisponiveis = p;
            });
          }),


          //***Intelecto***
          extraUI("Vontade:", "vontade", vontade, (v, p){
            setState(() {
              vontade = v;
              pontosDisponiveis = p;
            });
          }),

          //***Espaçamento***
          Spacer(),

          //***Botao Voltar***
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50),
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaPersonagemEditar(nomePersonagem: widget.nomePersonagem),
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
    );
  }
}