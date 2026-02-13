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



import 'dart:convert';
import 'dart:io';
//import 'dart:nativewrappers/_internal/vm/lib/ffi_native_type_patch.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:rmtools/model/fichaModel/ficha.dart';
import 'package:docx_template/docx_template.dart';
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


Future<void> exportarFicha(Ficha ficha) async {
  final data = await rootBundle.load('assets/personagem.docx');
  final bytes = data.buffer.asUint8List();
  final docx = await DocxTemplate.fromBytes(bytes);

  final content = Content()

    // Dados básicos
    ..add(TextContent("np", ficha.np.toString()))
    ..add(TextContent("nomeJogador", ficha.nomeJogador))
    ..add(TextContent("nomePersonagem", ficha.nomePersonagem))

    // Habilidades
    ..add(TextContent("forca", ficha.habilidades['forca'].toString()))
    ..add(TextContent("agilidade", ficha.habilidades['agilidade'].toString()))
    ..add(TextContent("destreza", ficha.habilidades['destreza'].toString()))
    ..add(TextContent("luta", ficha.habilidades['luta'].toString()))
    ..add(TextContent("intelecto", ficha.habilidades['intelecto'].toString()))
    ..add(TextContent("prontidao", ficha.habilidades['prontidao'].toString()))
    ..add(TextContent("presenca", ficha.habilidades['presenca'].toString()))
    ..add(TextContent("vigor", ficha.habilidades['vigor'].toString()))

    ..add(TextContent("custoHabilidades", ficha.custoHabilidades.toString()))

    // Vantagens
    ..add(ListContent(
      "vantagens",
      ficha.vantagens.map((v) => RowContent()
        ..add(TextContent("nome", v.nome))
        ..add(TextContent("graduacao", v.graduacao.toString()))
      ).toList()
    ))

    // Perícias
    ..add(ListContent(
      "pericias",
      ficha.pericias.map((p) => RowContent()
        ..add(TextContent("nome", p.nome))
        ..add(TextContent("graduacao", p.graduacao.toString()))
        ..add(TextContent("bonus", p.bonus.toString()))
      ).toList()
    ))

    // Resumo
    ..add(TextContent("totalGasto", ficha.totalGasto.toString()))
    ..add(TextContent("pontosRestantes", ficha.pontosRestantes.toString()));

  final generated = await docx.generate(content);

  final file = File(
    "/storage/emulated/0/Download/${ficha.nomePersonagem}.docx"
  );

  await file.writeAsBytes(generated!);
}



} 

