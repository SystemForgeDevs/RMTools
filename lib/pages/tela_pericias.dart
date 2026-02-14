import 'package:flutter/material.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';

class TelaPericias extends StatefulWidget {
  final String nomePersonagem;
  const TelaPericias({super.key, required this.nomePersonagem});

  @override
  State<TelaPericias> createState() => _TelaPericias();
}

class _TelaPericias extends State<TelaPericias> {
  Map<String, int> pericias = {};
  int pontosDisponiveis = 0;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _lerJson();
  }

  Future<void> _lerJson() async {
    final repo = FichaRepository();
    final ficha = await repo.carregar(widget.nomePersonagem);

    setState(() {
      pericias = {
        "Acrobacia" : 0, 
        "Atletismo" : 0,
        "Combate Dis." : 0,
        "Combate Corpo a corpo" : 0,
        "Enganação" : 0,
        "Especialidade" : 0,
        "Furtividade" : 0,
        "Intimidação" : 0,
        "Intuição" : 0,
        "Investigação" : 0,
        "Percepção" : 0,
        "Persuasão" : 0,
        "Prestidigitação" : 0, 
        "Tecnologia" : 0,
        "Tratamento" : 0,
        "Veículos" : 0,
      };

      if (ficha != null) {
        for (var p in ficha.pericias) {
          pericias[p.nome] = p.graduacao;
        }
        pontosDisponiveis = ficha.pontosD;
      }

      carregando = false;
    });
  }

  Future<void> _alterar(String chave, int delta) async {
    final repo = FichaRepository();
    final ficha = await repo.carregar(widget.nomePersonagem);

    if (ficha != null && ficha.adicionarPericia(chave, delta)) {
      await repo.salvar(ficha);

      final novaGraduacao = ficha.pericias.where((p) => p.nome == chave).map((p) => p.graduacao).firstOrNull ?? 0;

      setState(() {
        if(ficha.pericias.any((p) => p.nome == chave)){
          pericias[chave] = novaGraduacao;
        }else{
          pericias[chave] = 0;
        }
        pontosDisponiveis = ficha.pontosD;
      });
    }
  }

  Widget periciaUI(String nome, int valor) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Expanded(
            child: Text(
              nome[0].toUpperCase() + nome.substring(1),
              style: const TextStyle(color: Colors.white, fontSize: 26),
              softWrap: true,
            ),
          ),
          
          Row(
            children: [

              //Botão remover
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                iconSize: 30,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _alterar(nome, -1),
              ),


              //Espaçamento
              const SizedBox(width: 15),


              Text(
                '$valor',
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),

              //Espaçamento
              const SizedBox(width: 15),

              //Botão adicionar
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                iconSize: 30,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _alterar(nome, 1), 
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      
      //Widgets pericias
      body: carregando? 
      const Center(child: CircularProgressIndicator()): Column(
        children: [
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
                              """As perícias são habilidades aprendidas, uma combinação de treinamento (a perícia) e talento natural (uma graduação de habilidade).\n\n

                              Cada perícia tem uma graduação, usada como um bônus à rolagem do dado ao se usar a perícia em questão.\n\n
                              
                              Dê ao seu herói graduações em perícia gastando pontos de poder: 2 graduações em perícia por ponto de poder. Você pode dividir as graduações em perícias diferentes.\n\n
                              
                              Os personagens podem realizar algumas tarefas sem treinamento, usando apenas seu talento bruto (como definido por suas graduações de habilidade), mas personagens peritos são melhores do que isso.\n\n
                              
                              Aqueles com as combinações certas de perícias e vantagens podem até mesmo se sair bem contra oponentes superpoderosos.
                              """,
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
          
          
          Flexible(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350), //<-- limite da linha
                  child: const Divider(color: Colors.white10),
                ),
              ),
              itemCount: pericias.length,
              itemBuilder: (_, i) {
                final e = pericias.entries.elementAt(i);
                return periciaUI(e.key, e.value);
              },
            ),
          ),
          


          //***Botao Voltar***
          Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 20),
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
          )
        ],
      ),
    );
  }
}