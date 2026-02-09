import 'package:flutter/material.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';

class TelaHabilidades extends StatefulWidget{
  final String nomePersonagem;
  const TelaHabilidades({super.key, required this.nomePersonagem});

  @override
  State<TelaHabilidades> createState() => _TelaHabilidades();
}

class _TelaHabilidades extends State<TelaHabilidades>{
  @override
  void initState(){
    super.initState();
    _lerJson();
  }
    
  int forca = 0;
  int agilidade =  0;
  int destreza = 0;
  int luta = 0;
  int intelecto = 0;
  int prontidao = 0;
  int presenca = 0;
  int vigor = 0;
  int pontosDisponiveis = 0;


  //***Ler o json***
  Future<void> _lerJson() async{
    final repositorio = FichaRepository();
    final ficha = await repositorio.carregar(widget.nomePersonagem);

    if(ficha != null){
      setState(() {
        forca = ficha.habilidades["forca"] ?? 0;
        agilidade = ficha.habilidades["agilidade"] ?? 0;
        destreza = ficha.habilidades["destreza"] ?? 0;
        luta = ficha.habilidades["luta"] ?? 0;
        intelecto = ficha.habilidades["intelecto"] ?? 0;
        prontidao = ficha.habilidades["prontidao"] ?? 0;
        presenca = ficha.habilidades["presenca"] ?? 0;
        vigor = ficha.habilidades["vigor"] ?? 0;
        pontosDisponiveis = ficha.pontosD;
      });
    }
  }
  
  //***Método de alterar as habilidades e pontos***
  Future<void> alterar(String chave, int valor, Function(int,int) atualizar) async {
    final repo = FichaRepository();
    final ficha = await repo.carregar(widget.nomePersonagem);
    if (ficha != null && ficha.adicionarHabilidade(chave, valor)) {
      await repo.salvar(ficha);
      atualizar(ficha.habilidades[chave] ?? 0, ficha.pontosD);
    }
  }

  //***Método UI que resolve a repetição***
  Widget habilidadeUI(String label, String chave, int valor, Function(int,int) atualizar) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 40)),
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
          habilidadeUI("Força:", "forca", forca, (v, p){
            setState(() {
              forca = v;
              pontosDisponiveis = p;
            });
          }),


          //***Agilidade***
          habilidadeUI("Agilidade:", "agilidade", agilidade, (v, p){
            setState(() {
              agilidade = v;
              pontosDisponiveis = p;
            });
          }),


          //***Destreza***
          habilidadeUI("Destreza:", "destreza", destreza, (v, p){
            setState(() {
              destreza = v;
              pontosDisponiveis = p;
            });
          }),


          //***Luta***
          habilidadeUI("Luta:", "luta", luta, (v, p){
            setState(() {
              luta = v;
              pontosDisponiveis = p;
            });
          }),


          //***Intelecto***
          habilidadeUI("Intelecto:", "intelecto", intelecto, (v, p){
            setState(() {
              intelecto = v;
              pontosDisponiveis = p;
            });
          }),

          //***Prontidão***
          habilidadeUI("Prontidão:", "prontidao", prontidao, (v, p){
            setState(() {
              prontidao = v;
              pontosDisponiveis = p;
            });
          }),

          //***Presença***
          habilidadeUI("Presença:", "presenca", presenca, (v, p){
            setState(() {
              presenca = v;
              pontosDisponiveis = p;
            });
          }),

          //***Vigor***
          habilidadeUI("Vigor:", "vigor", vigor, (v, p){
            setState(() {
              vigor = v;
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