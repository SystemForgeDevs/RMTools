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

import 'dart:convert';
import 'dart:io';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:rmtools/model/fichaModel/ficha.dart';
import 'package:permission_handler/permission_handler.dart';


class FichaRepository {

  
  

Future<bool> _pedirPermissao() async {
  if (await Permission.manageExternalStorage.isGranted) {
    return true;
  }

  await Permission.manageExternalStorage.request();
  return await Permission.manageExternalStorage.isGranted;
}


  
  
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

  final permitido = await _pedirPermissao();
  if (!permitido) return [];

  final dir = Directory('/storage/emulated/0/Download');

  if (!await dir.exists()) return [];

  final arquivos = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'));

  return arquivos
      .map((f) => f.uri.pathSegments.last.replaceAll('.json', ''))
      .toList();
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



Future<void> exportarFicha(Ficha ficha) async {
  
    // =========================
    // 1️⃣ GERAR PDF
    // =========================

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        maxPages: 500,
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

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

              _buildDadosBasicos(ficha),
              pw.SizedBox(height: 20),

              _buildHabilidades(ficha),
              pw.SizedBox(height: 20),

              _buildDefesas(ficha),
              pw.SizedBox(height: 20),

              _buildVantagens(ficha),
              pw.SizedBox(height: 20),

              _buildPericias(ficha),
              pw.SizedBox(height: 20),

              _buildResumoPontos(ficha),
              pw.SizedBox(height: 20),

              _buildObservacoes(),
            ],
          ),
        ],
      ),
    );

    final pdfFile = File(
        "/storage/emulated/0/Download/${ficha.nomePersonagem}.pdf");

    await pdfFile.writeAsBytes(await pdf.save());

    // =========================
    // 2️⃣ GERAR HTML DOS PODERES
    // =========================

    final html = '''
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Poderes</title>

<style>
body { font-family: Arial; margin: 40px; }
h1 { text-align: center; }
.bloco { border: 1px solid black; padding: 15px; margin-bottom: 20px; border-radius: 5px; }
label { font-weight: bold; display: block; margin-top: 10px; }
input, textarea { width: 100%; margin-top: 3px; }
textarea { min-height: 60px; resize: vertical; }
button { margin-bottom: 20px; padding: 10px; }
</style>
</head>

<body>

<h1>PODERES</h1>

<button onclick="salvarArquivo()">Salvar Arquivo</button>

<div id="containerPoderes"></div>

<script>
function criarBlocos(quantidade) {
  const container = document.getElementById("containerPoderes");

  for (let i = 1; i <= quantidade; i++) {
    container.innerHTML += `
      <div class="bloco">
        <h3>Poder \${i}</h3>

        <label>Nome do Poder:</label>
        <input type="text">

        <label>Efeito:</label>
        <textarea></textarea>

        <label>Extras/Falhas:</label>
        <textarea></textarea>

        <label>Descritor:</label>
        <input type="text">

        <label>Graduação:</label>
        <input type="number">

        <label>Custo em PP:</label>
        <input type="number">
      </div>
    `;
  }
}

function salvarArquivo() {

  // Atualiza todos os inputs
  document.querySelectorAll("input").forEach(input => {
    input.setAttribute("value", input.value);
  });

  // Atualiza todos os textareas
  document.querySelectorAll("textarea").forEach(textarea => {
    textarea.innerHTML = textarea.value;
  });

  const conteudo = document.documentElement.outerHTML;
  const blob = new Blob([conteudo], { type: "text/html" });
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = "poderes_preenchido.html";
  a.click();
}


criarBlocos(10); // AQUI define quantos slots você quer
</script>

</body>
</html>

''';

    final htmlFile = File(
        "/storage/emulated/0/Download/${ficha.nomePersonagem}_poderes.html");

    await htmlFile.writeAsString(html);

    
  
    
    
  
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
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: 10),

      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(),
          borderRadius: pw.BorderRadius.circular(5),
        ),
        child: ficha.vantagens.isEmpty
            ? pw.Text('Nenhuma vantagem')
            : pw.Wrap(
                runSpacing: 4,
                children: ficha.vantagens.map((v) {
                  return pw.Row(
                    children: [
                      pw.Expanded(child: pw.Text('• ${v.nome}')),
                      pw.Text('Grad: ${v.graduacao}'),
                    ],
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
                  }),
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
            _buildLinhaResumo('Defesas:', ficha.custoDefesas.toString()),
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