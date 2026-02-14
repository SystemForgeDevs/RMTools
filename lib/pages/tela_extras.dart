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
                              """ESQUIVA:\n\nA defesa Esquiva é baseada nas graduações de Agilidade. Ela inclui o tempo de reação, rapidez e coordenação geral, e é usada para evitar ataques à distância e outras ameaças em que os reflexos e a velocidade são importantes.\n\nFORTITUDE:\n\nA defesa Fortitude é baseada no Vigor e mede a saúde e salvamento a ameaças como veneno ou doenças. Ela reúne constituição, robustez, metabolismo e imunidade.\n\nAPARAR:\n\nA defesa Aparar é baseada em Luta. É a habilidade de bloquear ou evadir um golpe em corpo-a-corpo, através de uma habilidade superior de combate.\n\nRESISTÊNCIA:\n\nA defesa Resistência é baseada em Vigor e é o salvamento de dano ou ferimentos diretos.\n\nVONTADE:\n\nA defesa Vontade é baseada nas graduações de Prontidão. Ela mede a estabilidade mental, lucidez, determinação, autoconfiança e força de vontade, e é usada para resistir ataques mentais ou espirituais.""",
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