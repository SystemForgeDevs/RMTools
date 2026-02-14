// Sempre que você quiser persistir algo, siga exatamente esta sequência:

// Objeto
//   ↓ toJson()
// Map<String, dynamic>
//   ↓ jsonEncode()
// String
//   ↓ writeAsString()
// Arquivo .json


// E para carregar:

// Arquivo .json
//   ↓ readAsString()
// String
//   ↓ jsonDecode()
// Map<String, dynamic>
//   ↓ fromJson()
// Objeto


// Se você respeitar isso, não tem como dar errado.


import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import 'dart:io';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:rmtools/model/fichaModel/ficha.dart';

import 'package:flutter/services.dart';

class FichaRepository {

  Future<File> _file(String nomePersonagem) async {
    final dir = Directory('/storage/emulated/0/Download');
    return File('${dir.path}/$nomePersonagem.json');
  }

  Future<void> salvar(Ficha ficha) async {
    final file = await _file(ficha.nomePersonagem);
    final jsonString = jsonEncode(ficha.toJson());
    await file.writeAsString(jsonString);
  }

  Future<bool> salvarPoder(String nomePersonagem, String nomePoder) async {
  final ficha = await carregar(nomePersonagem);
  if (ficha == null) return false;

  final ok = ficha.adicionarPoderes(nomePoder);
  if (!ok) return false;

  await salvar(ficha);
  return true;
}


  Future<Ficha?> carregar(String nomePersonagem) async {
    final file = await _file(nomePersonagem);
    if (!await file.exists()) return null;

    final jsonString = await file.readAsString();
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

    return Ficha.fromJson(jsonMap);
  } 


  Future<String?> carregarCampo(String campo,String nomePersonagem) async {
    final file = await _file(nomePersonagem);
    if (!await file.exists()) return null;

    final jsonMap = jsonDecode(await file.readAsString());
    final valor = jsonMap[campo];

    if (valor is String) {
      return valor;
    }

    return null;
  }


  Future<int?> carregarCampoInt(String campo,String nomePersonagem) async {
    final file = await _file(nomePersonagem);
    if (!await file.exists()) return null;

    final jsonMap = jsonDecode(await file.readAsString());
    final valor = jsonMap[campo];

    return valor;
    
  }//dawd


  Future<List<String>> listarFichas() async {
    final dir = Directory('/storage/emulated/0/Download');

    if (!await dir.exists()) return [];

    final arquivos = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

    List<String> nomes = [];

    for (var f in arquivos) {
      final jsonString = await f.readAsString();
      final jsonMap = jsonDecode(jsonString);
      
      if (jsonMap['nomePersonagem'] != null) {
        nomes.add(jsonMap['nomePersonagem']);
      } else {
        nomes.add(f.uri.pathSegments.last.replaceAll('.json', ''));
      }
    }

    return nomes;
  }
  
  Future<void> excluir(String nomePersonagem) async {
    final file = await _file(nomePersonagem);
    
    if (await file.exists()) {
      await file.delete(); 
    }
  }


Future<List<String>> carregarNomesPoderes(String nomePersonagem) async {
  final ficha = await carregar(nomePersonagem);
  if (ficha == null) return [];
  return ficha.poderes.map((p) => p.nomePoder).toList();
}

Future<List<String>> carregarNomesComponentes(String nomePersonagem, String? nomePoder) async {
  final ficha = await carregar(nomePersonagem);
  if (ficha == null) return [];

  final poder = ficha.poderes.firstWhere(
    (p) => p.nomePoder == nomePoder
  );


  return poder.componentes.map((c) => c.nomeComponente).toList();
}


// Future<void> exportarFicha(Ficha ficha) async {
//   try {
//     final data = await rootBundle.load('assets/personagem.docx');
//     final bytes = data.buffer.asUint8List();
//     final docx = await DocxTemplate.fromBytes(bytes);

//     // USAR PLAINCONTENT EM VEZ DE CONTENT PARA AS LINHAS
//     final vantagensLinhas = <PlainContent>[];
    
//     for (var v in ficha.vantagens) {
//       final linha = PlainContent("vantagens"); // Título igual ao da lista
//       linha.add(TextContent("nome", v.nome));
//       linha.add(TextContent("graduacao", v.graduacao.toString()));
//       vantagensLinhas.add(linha);
//     }

//     final periciasLinhas = <PlainContent>[];
    
//     for (var p in ficha.pericias) {
//       final linha = PlainContent("pericias"); // Título igual ao da lista
//       linha.add(TextContent("nome", p.nome));
//       linha.add(TextContent("graduacao", p.graduacao.toString()));
//       linha.add(TextContent("bonus", p.bonus.toString()));
//       periciasLinhas.add(linha);
//     }

//     // CONSTRUIR CONTEÚDO PRINCIPAL
//     final content = Content();
    
//     // Campos simples
//     content.add(TextContent("np", ficha.np.toString()));
//     content.add(TextContent("nomeJogador", ficha.nomeJogador));
//     content.add(TextContent("nomePersonagem", ficha.nomePersonagem));

//     // Habilidades
//     content.add(TextContent("forca", ficha.habilidades['forca'].toString()));
//     content.add(TextContent("agilidade", ficha.habilidades['agilidade'].toString()));
//     content.add(TextContent("destreza", ficha.habilidades['destreza'].toString()));
//     content.add(TextContent("luta", ficha.habilidades['luta'].toString()));
//     content.add(TextContent("intelecto", ficha.habilidades['intelecto'].toString()));
//     content.add(TextContent("prontidao", ficha.habilidades['prontidao'].toString()));
//     content.add(TextContent("presenca", ficha.habilidades['presenca'].toString()));
//     content.add(TextContent("vigor", ficha.habilidades['vigor'].toString()));
//     content.add(TextContent("custoHabilidades", ficha.custoHabilidades.toString()));

//     // Defesas
//     content.add(TextContent("esquiva", ficha.esquiva.toString()));
//     content.add(TextContent("aparar", ficha.aparar.toString()));
//     content.add(TextContent("fortitude", ficha.fortitude.toString()));
//     content.add(TextContent("vontade", ficha.vontade.toString()));
//     content.add(TextContent("resistencia", ficha.resistencia.toString()));

//     // LISTAS - usando PlainContent
//     if (vantagensLinhas.isNotEmpty) {
//       content.add(ListContent("vantagens", vantagensLinhas.cast<Content>()));
//     }

//     if (periciasLinhas.isNotEmpty) {
//       content.add(ListContent("pericias", periciasLinhas.cast<Content>()));
//     }

//     // Custos
//     content.add(TextContent("custoVantagens", ficha.custoVantagens.toString()));
//     content.add(TextContent("custoPericias", ficha.custoPericias.toString()));
//     content.add(TextContent("totalGasto", ficha.totalGasto.toString()));
//     content.add(TextContent("pontosRestantes", ficha.pontosRestantes.toString()));

//     final gerado = await docx.generate(content);
//     final file = File("/storage/emulated/0/Download/${ficha.nomePersonagem}.docx");
//     await file.writeAsBytes(gerado!);
    
//   } catch (e, stack) {
//     print('Erro na exportação: $e');
//     print(stack);
//   }
// }






Future<void> exportarFicha(Ficha ficha) async {
  try {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        maxPages: 500,
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => [
          // TÍTULO
          pw.Center(
            child: pw.Text(
              'FICHA DE PERSONAGEM',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          
          // DADOS BÁSICOS
          _buildDadosBasicos(ficha),
          pw.SizedBox(height: 20),

          // HABILIDADES
          _buildHabilidades(ficha),
          pw.SizedBox(height: 20),

          // DEFESAS
          _buildDefesas(ficha),
          pw.SizedBox(height: 20),

          // VANTAGENS (agora com suporte a muitas linhas)
          _buildVantagens(ficha),
          pw.SizedBox(height: 3),

          // PERÍCIAS (agora com suporte a muitas linhas)
          _buildPericias(ficha),
          pw.SizedBox(height: 20),

          // RESUMO DE PONTOS
          _buildResumoPontos(ficha),
          pw.SizedBox(height: 20),

          // OBSERVAÇÕES
          _buildObservacoes(),
        ],
      ),
    );

    final file = File("/storage/emulated/0/Download/${ficha.nomePersonagem}.pdf");
    await file.writeAsBytes(await pdf.save());
    
    print('PDF exportado com sucesso: ${file.path}');
    
  } catch (e, stack) {
    print('Erro na exportação do PDF: $e');
    print(stack);
  }
}

// Widgets auxiliares para organizar o código
pw.Widget _buildDadosBasicos(Ficha ficha) {
  return pw.Container(
    padding: pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(),
      borderRadius: pw.BorderRadius.circular(5),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Text('Personagem: ${ficha.nomePersonagem}'),
            ),
            pw.Expanded(
              child: pw.Text('Jogador: ${ficha.nomeJogador}'),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Text('Nível de Poder (NP): ${ficha.np}'),
      ],
    ),
  );
}

pw.Widget _buildHabilidades(Ficha ficha) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'HABILIDADES',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Força: ${ficha.habilidades['forca']}')),
                pw.Expanded(child: pw.Text('Agilidade: ${ficha.habilidades['agilidade']}')),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Destreza: ${ficha.habilidades['destreza']}')),
                pw.Expanded(child: pw.Text('Luta: ${ficha.habilidades['luta']}')),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Intelecto: ${ficha.habilidades['intelecto']}')),
                pw.Expanded(child: pw.Text('Prontidão: ${ficha.habilidades['prontidao']}')),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Presença: ${ficha.habilidades['presenca']}')),
                pw.Expanded(child: pw.Text('Vigor: ${ficha.habilidades['vigor']}')),
              ],
            ),
            pw.Divider(),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'Custo Total: ${ficha.custoHabilidades}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildDefesas(Ficha ficha) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'DEFESAS',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          children: [
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Esquiva: ${ficha.esquiva}')),
                pw.Expanded(child: pw.Text('Aparar: ${ficha.aparar}')),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Fortitude: ${ficha.fortitude}')),
                pw.Expanded(child: pw.Text('Vontade: ${ficha.vontade}')),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(child: pw.Text('Resistência: ${ficha.resistencia}')),
                pw.Expanded(child: pw.Text('')),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildVantagens(Ficha ficha) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'VANTAGENS',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: ficha.vantagens.isEmpty
            ? pw.Text('Nenhuma vantagem')
            : pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: ficha.vantagens.map((v) {
                  return pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      children: [
                        pw.Expanded(child: pw.Text('• ${v.nome}')),
                        pw.Text('Grad: ${v.graduacao}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ),
    ],
  );
}

pw.Widget _buildPericias(Ficha ficha) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'PERÍCIAS',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: ficha.pericias.isEmpty
            ? pw.Text('Nenhuma perícia')
            : pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Cabeçalho
                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          'Perícia',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Container(
                        width: 60,
                        child: pw.Text(
                          'Grad',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                      pw.Container(
                        width: 60,
                        child: pw.Text(
                          'Bônus',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(),
                  ...ficha.pericias.map((p) {
                    return pw.Padding(
                      padding: pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Row(
                        children: [
                          pw.Expanded(child: pw.Text('• ${p.nome}')),
                          pw.Container(
                            width: 60,
                            child: pw.Text(
                              p.graduacao.toString(),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Container(
                            width: 60,
                            child: pw.Text(
                              p.bonus.toString(),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
      ),
    ],
  );
}

pw.Widget _buildResumoPontos(Ficha ficha) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'RESUMO DE PONTOS',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Column(
          children: [
            _buildLinhaResumo('Habilidades:', ficha.custoHabilidades.toString()),
            _buildLinhaResumo('Vantagens:', ficha.custoVantagens.toString()),
            _buildLinhaResumo('Perícias:', ficha.custoPericias.toString()),
            pw.Divider(),
            _buildLinhaResumo('TOTAL GASTO:', ficha.totalGasto.toString(), isBold: true),
            _buildLinhaResumo('PONTOS RESTANTES:', ficha.pontosRestantes.toString(), 
                isBold: true, color: PdfColors.green),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildLinhaResumo(String label, String valor, {bool isBold = false, PdfColor? color}) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : null),
      ),
      pw.Text(
        valor,
        style: pw.TextStyle(
          fontWeight: isBold ? pw.FontWeight.bold : null,
          color: color,
        ),
      ),
    ],
  );
}

pw.Widget _buildObservacoes() {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        'OBSERVAÇÕES',
        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 10),
      pw.Container(
        height: 100,
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: pw.Text(''),
      ),
    ],
  );
}


}