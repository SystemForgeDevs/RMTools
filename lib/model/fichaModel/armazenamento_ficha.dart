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

Future<List<String>> carregarNomesComponentes(String nomePersonagem) async {
  final ficha = await carregar(nomePersonagem);
  if (ficha == null) return [];
  return ficha.poderes.map((p) => p.nomePoder).toList();
}


} 

