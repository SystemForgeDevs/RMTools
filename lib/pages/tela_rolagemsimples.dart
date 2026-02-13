import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rmtools/model/masterModel/master.dart';
import 'package:rmtools/pages/tela_mestragremmenu.dart';

class TelaRolagemSimples extends StatefulWidget {
  const TelaRolagemSimples({super.key});

  @override
  State<TelaRolagemSimples> createState() => _TelaRolagemSimplesState();
}

class _TelaRolagemSimplesState extends State<TelaRolagemSimples> {
  final valorDado = TextEditingController();
  final valorBonus = TextEditingController();
  final valorModificador = TextEditingController();
  int valorCD = 1;
  
  bool erro = false;
  bool sucesso = false;
  bool preencha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 21, 22, 34),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                
                
                //***Titulo***
                children: [
                  const Text(
                    "Rolagem Simples",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),

                  
                  //***Espaçamento***
                  const SizedBox(height: 40),
                  
                  
                  //***Campo Dado***
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: TextField(
                      controller: valorDado,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                      ],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Valor do Dado",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),


                  //***Campo Bonus***
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: TextField(
                      controller: valorBonus,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                      ],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Valor do Bônus",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),

                  //***Campo Modificador***
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: TextField(
                      controller: valorModificador,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                      ],
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Valor do Modificador",
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      ),
                    ),
                  ),

                  Text(
                    "Valor CD",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),


                  //***Slider***
                  Slider(
                    value: valorCD.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    label: valorCD.toString(),
                    onChanged: (double novoValor) {
                      setState(() {
                        valorCD = novoValor.toInt();
                      });
                    },
                  ),

                  
                  //***Espaçamento***
                  Spacer(),

                  
                  //***Padding dos botões***
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),

                    //***Botao Rolagem***
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 100),
                      ),
                      onPressed: () async{
                        if (valorDado.text.isEmpty || valorBonus.text.isEmpty || valorModificador.text.isEmpty){
                          setState(() {
                            erro = false;
                            sucesso = false;
                            preencha = true;
                          });
                          return;
                        }

                        setState(() {
                          erro = false;
                          sucesso = false;

                          //faz o teste
                          final rolagem = Rolagens();
                          final dado = int.parse(valorDado.text);
                          final bonus = int.parse(valorBonus.text);
                          final modificador = int.parse(valorModificador.text);
                          final cd = valorCD;

                          if(rolagem.testeSimples(dado, modificador, bonus, cd)){
                            sucesso = true;
                            erro = false;
                            preencha = false;
                          }else{
                            sucesso = false;
                            erro = true;
                            preencha = false;
                          }
                          
                        });

                        if(!mounted){
                          return;
                        }   
                      },
                      child: const Text(
                        "Rolar!",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),


                  //***Botao Voltar***
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 50),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaMestragemMenu(),
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

          //erro
          if (erro)
            const Positioned(
              bottom: 280,
              child: Text(
                "Fracasso!",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (sucesso)
            const Positioned(
              bottom: 280,
              child: Text(
                "Sucesso!",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          if (preencha)
            const Positioned(
              bottom: 280,
              child: Text(
                "Preencha todos os dados!",
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}