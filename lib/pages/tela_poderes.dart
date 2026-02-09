import 'package:flutter/material.dart';
import 'package:rmtools/pages/tela_personagem_editar.dart';
import 'package:rmtools/model/fichaModel/armazenamento_ficha.dart';

class TelaPoderes extends StatefulWidget{
  final String nomePersonagem;
  const TelaPoderes({super.key, required this.nomePersonagem});

  @override
  State<TelaPoderes> createState() => _TelaPoderesState();
}

class _TelaPoderesState extends State<TelaPoderes>{
  int pontosDisponiveis = 0;
  bool carregando = false; //<----------- ALTERAR ISSO AQ PRA ***TRUE*** QUANDO FOR FAZER O INICIALIZAR DADOS(METODO)
  final nomeComponente = TextEditingController();
  int valor = 0;
  double _offset = 0;

  final List<String> efeitosPoderesLista = [
    "Nenhum Componente",
    "Absorção de Energia",
    "Aflição",
    "Alongamento",
    "Ambiente",
    "Armadilha",
    "Aura de Energia",
    "Campo de Força",
    "Camuflagem",
    "Característica Aumentada",
    "Característica",
    "Compreender",
    "Comunicação",
    "Controle da Sorte",
    "Controle de Elemento",
    "Controle de Energia",
    "Controle Mental",
    "Crescimento",
    "Criar",
    "Cura",
    "Dano",
    "Deflexão",
    "Duplicação",
    "Encolhimento",
    "Enfraquecer",
    "Escavação",
    "Forma Alternativa",
    "Golpe",
    "Ilusão",
    "Imitar",
    "Imortalidade",
    "Imunidade",
    "Intangibilidade",
    "Invisibilidade",
    "Invocar",
    "Leitura Mental",
    "Magia",
    "Membros Extras",
    "Metamorfo",
    "Morfar",
    "Mover Objeto",
    "Movimento",
    "Natação",
    "Nulificar",
    "Pasmar",
    "Poder de Carga",
    "Proteção",
    "Raio",
    "Rajada Mental",
    "Rapidez",
    "Regeneração",
    "Salto",
    "Sentidos",
    "Sentido Remoto",
    "Sono",
    "Sufocamento",
    "Supervelocidade",
    "Teleporte",
    "Transformação",
    "Variável",
    "Velocidade",
    "Voo"
  ];
  late String escolha;

  final List<String> descritoresBasicos = [
  // Físicos / Naturais
  "Fisico",
  "Biologico",
  "Organico",
  "Anatomico",
  "Cinetico",
  "Impacto",
  "Cortante",
  "Perfurante",
  "Municao",
  "Pressao",
  "Vibracao",
  "Sonico",

  // Energéticos
  "Energia",
  "Eletrico",
  "Termico",
  "Calor",
  "Frio",
  "Fogo",
  "Radiacao",
  "Luz",
  "Laser",
  "Plasma",
  "MicroOndas",

  // Elementais
  "Ar",
  "Agua",
  "Gelo",
  "Terra",
  "Areia",
  "Lama",
  "Metal",
  "Madeira",
  "Cristal",

  // Científicos / Tecnológicos
  "Tecnologico",
  "Nanotecnologia",
  "Mecanico",
  "Robotico",
  "Cibernetico",
  "Quimico",
  "Farmacologico",
  "Experimental",
  "EngenhariaGenetica",
  "InteligenciaArtificial",

  // Mentais / Psíquicos
  "Mental",
  "Psiquico",
  "Telepatico",
  "Emocional",
  "IlusaoMental",
  "ControleMental",
  "Medo",
  "Dor",

  // Espirituais / Sobrenaturais
  "Sobrenatural",
  "Espiritual",
  "Mistico",
  "Divino",
  "Demoníaco",
  "Infernal",
  "Celestial",
  "Maldicao",

  // Ambientais / Condição
  "Ambiental",
  "Vacio",
  "Gravidade",
  "Magnetico",
  "RadiacaoCosmica",
  "PressaoExtrema",
  "Profundidade",
  "Espaco",
  "Subaquatico",

  // Estados / Dano Especial
  "Veneno",
  "Doenca",
  "Acido",
  "Corrosao",
  "Envelhecimento",
  "Degeneracao",
  "Paralisia",
  "Asfixia",

  // Meta / Conceituais
  "Mutante",
  "Aprimoramento",
  "Artificial",
  "Natural",
  "NaoLetal",
  "Letal"
  ];
  late String escolhaDescritores;

  @override
  void initState() {
    super.initState();
    escolha = efeitosPoderesLista.first;
    escolhaDescritores = descritoresBasicos.first;
    _lerJson();
  }

  Future<void> _lerJson() async{
    final repositorio = FichaRepository();
    final ficha = await repositorio.carregar(widget.nomePersonagem);

    if(ficha != null){
      setState(() {
        pontosDisponiveis = ficha.pontosD;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),

      //Widgets principais
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: carregando? 
        const Center(child: CircularProgressIndicator()): SingleChildScrollView(
          child: Column(
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
                                  "Vantagens custam 1 ponto por graduação. Algumas são únicas (Checkbox) e outras graduáveis (Botões).\n\n"
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

              //***Nome do Componente */
              Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: TextField(
                  controller: nomeComponente,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Nome do Componente",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  ),
                ),
              ),


              //***DropDown efeitos */
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,          
                  //texto
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal:16),
                      child: Text("Efeitos de Poder", 
                        style: TextStyle(fontSize:16, color:Colors.white)),
                    ),
                    
                    //Espaçamento
                    const SizedBox(height:6),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:16),
                      child: DropdownButtonFormField<String>(
                        initialValue: escolha,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        items: efeitosPoderesLista.map((item) =>
                          DropdownMenuItem(value: item, child: Text(item))
                        ).toList(),
                        isExpanded: false,
                        onChanged: (v) => setState(() => escolha = v!),
                      ),
                    ),
                  ],
                ),
              ),
              
              //***Stepper */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Graduação(efeito):", style: const TextStyle(color: Colors.white, fontSize: 25)),
                    Row(
                      children: [

                        //diminuir
                        IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white),
                          iconSize: 20,
                          style: IconButton.styleFrom(
                            side: const BorderSide(color: Colors.white24, width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            if (valor > 0) {
                              setState(() {
                                valor--;
                                pontosDisponiveis++;
                              });

                              final repo = FichaRepository();
                              final ficha = await repo.carregar(widget.nomePersonagem);
                              if (ficha != null) {
                                ficha.pontosD = pontosDisponiveis;
                                await repo.salvar(ficha);
                              }
                            }
                          },
                        ),

                        //espaçamento
                        const SizedBox(width: 15),

                        //valor
                        Text("$valor", style: const TextStyle(color: Colors.white, fontSize: 30)),
                        
                        //espaçamento
                        const SizedBox(width: 15),
                        
                        //adicionar
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          iconSize: 20,
                          style: IconButton.styleFrom(
                            side: const BorderSide(color: Colors.white24, width: 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            if (pontosDisponiveis > 0) {
                              setState(() {
                                valor++;
                                pontosDisponiveis--;
                              });

                              final repo = FichaRepository();
                              final ficha = await repo.carregar(widget.nomePersonagem);
                              if (ficha != null) {
                                ficha.pontosD = pontosDisponiveis;
                                await repo.salvar(ficha);
                              }
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),


              //***DropDown descritores categorias */
              Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,          
                  //texto
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal:16),
                      child: Text("Descritores Base(Categorias)", 
                        style: TextStyle(fontSize:16, color:Colors.white)),
                    ),
                    
                    //Espaçamento
                    const SizedBox(height:6),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:16),
                      child: DropdownButtonFormField<String>(
                        initialValue: escolhaDescritores,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                        ),
                        items: descritoresBasicos.map((item) =>
                          DropdownMenuItem(value: item, child: Text(item))
                        ).toList(),
                        isExpanded: false,
                        onChanged: (v) => setState(() => escolhaDescritores = v!),
                      ),
                    ),
                  ],
                ),
              ),

              //*** Título Fixo (Fora do AnimatedContainer) */
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft, // Força o alinhamento à esquerda
                  child: Text(
                    "Descrição do Poder",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              //***Campo especificador */
              Focus(
                onFocusChange: (hasFocus) => setState(() => _offset = hasFocus ? -200 : 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds:250),
                  transform: Matrix4.translationValues(0, _offset, 0),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 21, 22, 34), // Cor igual ao fundo
                    child: SizedBox(
                      height:150,
                      width:350,
                      child: TextField(
                        maxLines:null,
                        expands:true,
                        style: const TextStyle(color: Colors.white),
                        textAlignVertical: TextAlignVertical.top,
                        scrollPadding: EdgeInsets.zero,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled:true,
                          fillColor: Colors.white10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),


               Padding(
                padding: const EdgeInsets.only(top: 130, bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 100),
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
                    "Adicionar Poder",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),

              //***Botão Voltar */
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
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
          ),
        ),
      )
    );
  }
}