import 'package:flutter/material.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';

class TelaVantagens extends StatefulWidget {
  final String nomePersonagem;
  const TelaVantagens({super.key, required this.nomePersonagem});

  @override
  State<TelaVantagens> createState() => _TelaVantagensState();
}

enum TipoVantagem { botoes, checkbox }

class _TelaVantagensState extends State<TelaVantagens> {
  Map<String, int> vantagens = {};
  int pontosDisponiveis = 0;
  bool carregando = true;

final Map<String, TipoVantagem> tipoPorItem = {
  "Agarrar Aprimorado": TipoVantagem.checkbox,
  "Agarrar Preciso": TipoVantagem.checkbox,
  "Agarrar Rápido": TipoVantagem.checkbox,
  "Ambiente Favorito": TipoVantagem.checkbox,
  "Arma Improvisada": TipoVantagem.botoes,
  "Armação": TipoVantagem.botoes,
  "Artífice": TipoVantagem.checkbox,
  "Assustar": TipoVantagem.checkbox,
  "Ataque à Distância": TipoVantagem.botoes,
  "Ataque Acurado": TipoVantagem.checkbox,
  "Ataque Corpo-a-Corpo": TipoVantagem.botoes,
  "Ataque Defensivo": TipoVantagem.checkbox,
  "Ataque Dominó": TipoVantagem.botoes,
  "Ataque Imprudente": TipoVantagem.checkbox,
  "Ataque Poderoso": TipoVantagem.checkbox,
  "Ataque Preciso": TipoVantagem.botoes,
  "Atraente": TipoVantagem.botoes,
  "Avaliação": TipoVantagem.checkbox,
  "Ação em Movimento": TipoVantagem.checkbox,
  "Bem Informado": TipoVantagem.checkbox,
  "Bem Relacionado": TipoVantagem.checkbox,
  "Benefício": TipoVantagem.botoes,
  "Capanga": TipoVantagem.botoes,
  "Contatos": TipoVantagem.checkbox,
  "Crítico Aprimorado": TipoVantagem.botoes,
  "Defesa Aprimorada": TipoVantagem.checkbox,
  "De Pé": TipoVantagem.checkbox,
  "Derrubar Aprimorado": TipoVantagem.checkbox,
  "Desarmar Aprimorado": TipoVantagem.checkbox,
  "Destemido": TipoVantagem.checkbox,
  "Duro de Matar": TipoVantagem.checkbox,
  "Empatia com Animais": TipoVantagem.checkbox,
  "Equipamento": TipoVantagem.botoes,
  "Esconder-se à Plena Vista": TipoVantagem.checkbox,
  "Esforço Extraordinário": TipoVantagem.checkbox,
  "Esforço Supremo": TipoVantagem.checkbox,
  "Esquiva Fabulosa": TipoVantagem.checkbox,
  "Estrangular": TipoVantagem.checkbox,
  "Evasão": TipoVantagem.botoes,
  "Fascinar": TipoVantagem.botoes,
  "Faz Tudo": TipoVantagem.checkbox,
  "Ferramentas Aprimoradas": TipoVantagem.checkbox,
  "Finta Ágil": TipoVantagem.checkbox,
  "Idiomas": TipoVantagem.botoes,
  "Imobilizar Aprimorado": TipoVantagem.checkbox,
  "Iniciativa Aprimorada": TipoVantagem.botoes,
  "Inimigo Favorito": TipoVantagem.checkbox,
  "Inspirar": TipoVantagem.botoes,
  "Interpor-se": TipoVantagem.checkbox,
  "Inventor": TipoVantagem.checkbox,
  "Liderança": TipoVantagem.checkbox,
  "Luta no Chão": TipoVantagem.checkbox,
  "Maestria em Arremesso": TipoVantagem.botoes,
  "Maestria em Perícia": TipoVantagem.checkbox,
  "Memória Eidética": TipoVantagem.checkbox,
  "Mira Aprimorada": TipoVantagem.checkbox,
  "Parceiro": TipoVantagem.botoes,
  "Prender Arma": TipoVantagem.checkbox,
  "Quebrar Aprimorado": TipoVantagem.checkbox,
  "Quebrar Arma": TipoVantagem.checkbox,
  "Rastrear": TipoVantagem.checkbox,
  "Redirecionar": TipoVantagem.checkbox,
  "Ritualista": TipoVantagem.checkbox,
  "Rolamento Defensivo": TipoVantagem.botoes,
  "Saque Rápido": TipoVantagem.checkbox,
  "Segunda Chance": TipoVantagem.botoes,
  "Sorte": TipoVantagem.botoes,
  "Sorte de Principiante": TipoVantagem.checkbox,
  "Tomar a Iniciativa": TipoVantagem.checkbox,
  "Tolerância Maior": TipoVantagem.checkbox,
  "Tontear": TipoVantagem.botoes,
  "Trabalho em Equipe": TipoVantagem.checkbox,
  "Transe": TipoVantagem.checkbox,
  "Zombar": TipoVantagem.checkbox,
};


  @override
  void initState() {
    super.initState();
    _inicializarDados();
  }

  Future<void> _inicializarDados() async {
    final repo = FichaRepository();
    final ficha = await repo.carregar(widget.nomePersonagem);

    if (ficha != null) {
      Map<String, int> mapaCarregado = {};
      // Inicializa todas as chaves do tipoPorItem com valor 0 ou valor da ficha
      for (var nome in tipoPorItem.keys) {
        final vFicha = ficha.vantagens.where((v) => v.nome == nome).firstOrNull;
        mapaCarregado[nome] = vFicha?.graduacao ?? 0;
      }

      setState(() {
        vantagens = mapaCarregado;
        pontosDisponiveis = ficha.pontosD;
        carregando = false;
      });
    }
  }

Future<void> _alterar(String chave, int delta) async {
    final repo = FichaRepository();
    final ficha = await repo.carregar(widget.nomePersonagem);
    if (ficha == null) return;

    final ok = ficha.adicionarVantagem(chave, delta);
    if (!ok) return;

    await repo.salvar(ficha);

    // BUSCA SEGURA: Se não encontrar, a graduação é 0
    final vantagemModificada = ficha.vantagens.where((v) => v.nome == chave).firstOrNull;
    final novaGraduacao = vantagemModificada?.graduacao ?? 0;

    setState(() {
      vantagens[chave] = novaGraduacao;
      pontosDisponiveis = ficha.pontosD;
    });
  }

  Widget vantagemUI(String nome, int valor) {
    TipoVantagem tipo = tipoPorItem[nome] ?? TipoVantagem.checkbox;

    if (tipo == TipoVantagem.checkbox) {
      return CheckboxListTile(
        // Removi o Divider usando o construtor do ListView abaixo, 
        // mas mantive o estilo do seu texto
        title: Text(nome, style: const TextStyle(color: Colors.white, fontSize: 26)),
        value: valor > 0, 
        onChanged: (bool? selecionado) {
          int delta = (selecionado == true) ? 1 : -1;
          _alterar(nome, delta);
        },
        activeColor: Colors.green,
        checkColor: Colors.white,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(nome, style: const TextStyle(color: Colors.white, fontSize: 26))),
          Row(
            children: [
              // Botão Menos (Corrigido para -1)
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                iconSize: 20,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: valor > 0 ? () => _alterar(nome, -1) : null, 
              ),

              //Espaçamento
              const SizedBox(width: 15),

              Text(
                "$valor", 
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)
              ),

              //Espaçamento
              const SizedBox(width: 15),

              // Botão Mais
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                iconSize: 20,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: Colors.white24, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _alterar(nome, 1), 
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      
      //Widgets principais
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
                              """As vantagens são classificadas em graduações e compradas com pontos de poder, da mesma forma que as habilidades e perícias. \n\nCada graduação em uma vantagem custa 1 ponto de poder. \n\nAlgumas vantagens não têm graduações e são adquiridas apenas uma vez (na prática, é como se fossem limitadas a 1 graduação).
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


          //***Elementos da lista */
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tipoPorItem.keys.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white10),
              itemBuilder: (context, index) {
                String nome = tipoPorItem.keys.elementAt(index);
                int valor = vantagens[nome] ?? 0;
                return vantagemUI(nome, valor);
              },
            ), 
          ),
          


          //***Botão Voltar */
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
        ]
      )
    );
  }
}