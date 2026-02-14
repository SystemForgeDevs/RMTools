class Modificador {
  final String nome;
  final int valor;
  final bool porGraduacao;

  Modificador({
    required this.nome,
    required this.valor,
    required this.porGraduacao,
  });
//teste
  Map<String,dynamic> toJson(){
    return{
      'nome':nome,
      'valor':valor,
      'porGraduacao':porGraduacao
    };
  }

  factory Modificador.fromJson(Map<String,dynamic> json){
    return Modificador(
      nome: json['nome'],
      valor: json['valor'],
      porGraduacao: json['porGraduacao']
    );
  }
}

class Componente{
  final String nomeComponente;
  final String efeito;
  final int graduacao;
  final int custoBase;
  final Map<String, Modificador> extras;
  final Map<String, Modificador> falhas;

  Componente({
    required this.nomeComponente,
    required this.efeito,
    required this.graduacao,
    required this.custoBase,
    Map<String, Modificador>? extras,
    Map<String, Modificador>? falhas,
  })  : extras = extras ?? {},
        falhas = falhas ?? {};
// extras ?? {}, se extras nao for nulo use ele,se for use {}


  Map<String,dynamic> toJson(){
    return{
      'nomeComponente':nomeComponente,
      'efeito':efeito,
      'graduacao':graduacao,
      'custoBase':custoBase,
      'extras': extras.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
      'falhas': falhas.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    };
  }

  factory Componente.fromJson(Map<String,dynamic>json){
    return Componente(
      nomeComponente: json['nomeComponente'],
      efeito: json['efeito'],
      graduacao: json['graduacao'],
      custoBase: json['custoBase'],
      extras: json['extras'] != null
        ? (json['extras'] as Map<String, dynamic>)
            .map((key, value) =>
                MapEntry(key, Modificador.fromJson(value)))
        : {},
    falhas: json['falhas'] != null
        ? (json['falhas'] as Map<String, dynamic>)
            .map((key, value) =>
                MapEntry(key, Modificador.fromJson(value)))
        : {},
    );


  } 

}

class Poder{
  final String nomePoder;
  final Map<String,Modificador> extras;
  final Map<String,Modificador> falhas;
  List<Componente> componentes = [];

  Poder({
    required this.nomePoder,
    Map<String, Modificador>? extras,
    Map<String, Modificador>? falhas,
    
  })  : extras = extras ?? {},
        falhas = falhas ?? {};


  Map<String,dynamic> toJson(){
    return{
      'nomePoder':nomePoder,
      'extras': extras.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'falhas': falhas.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'componentes': componentes.map((c) => c.toJson()).toList()
    
    };
  }

 factory Poder.fromJson(Map<String, dynamic> json) {
  final poder = Poder(
    nomePoder: json['nomePoder'],
    extras: json['extras'] != null
        ? (json['extras'] as Map<String, dynamic>)
            .map((key, value) =>
                MapEntry(key, Modificador.fromJson(value)))
        : {},
    falhas: json['falhas'] != null
        ? (json['falhas'] as Map<String, dynamic>)
            .map((key, value) =>
                MapEntry(key, Modificador.fromJson(value)))
        : {},
  );

  // AQUI entra a lista de componentes
  if (json['componentes'] != null) {
    poder.componentes.addAll(
      (json['componentes'] as List<dynamic>)
          .map((c) => Componente.fromJson(c)),
    );
  }

  return poder;
  }

}

class Vantagem {
  final String nome;
  int graduacao;
  
  Vantagem({
    required this.nome,
    required this.graduacao,
    
  });


  Map<String,dynamic> toJson(){
    return{
      'nome':nome,
      'graduacao':graduacao
    };
  }


  factory Vantagem.fromJson(Map<String,dynamic>json){
    return Vantagem(
      nome: json['nome'],
      graduacao: json['graduacao']
    );
  }

}

class Pericia {

  final String nome;
  int bonus;
  int graduacao;
  

  Pericia({
    required this.nome,
    required this.graduacao,
    this.bonus = 0,
    
  });

  


  Map<String,dynamic> toJson(){
    return {
      'nome':nome,
      'graduacao':graduacao,
      'bonus':bonus,
      
    };
  }

  factory Pericia.fromJson(Map<String,dynamic> json){
    return Pericia(
      nome:json['nome'],
      graduacao: json['graduacao'],
      bonus: json['bonus'],
      
    );

  }


  

}

class Ficha{

  final int np;
  final String nomeJogador;
  final String nomePersonagem;
  final int pontosBase ;
  int pontosD;
  Map<String, int> habilidades = {
    'forca': 0,
    'agilidade': 0,
    'destreza': 0,
    'luta': 0,
    'intelecto': 0,
    'prontidao': 0,
    'presenca': 0,
    'vigor': 0,
  };
  
  int esquiva = 0;
  int fortitude = 0;
  int resistencia = 0;
  int aparar = 0;
  int vontade = 0;
  
  int get custoHabilidades {
  return habilidades.values.fold(0, (soma, v) => soma + (v * 2));
  }

  int get custoPericias {
    int totalGraduacoes =
        pericias.fold(0, (soma, p) => soma + p.graduacao);

    return (totalGraduacoes / 2).ceil();
  }

  int get custoVantagens {
    return vantagens.fold(0, (soma, v) => soma + v.graduacao);
  }

  int get totalGasto {
    return custoHabilidades +
         custoPericias +
         custoVantagens;
  }

  int get pontosRestantes {
    return pontosBase - totalGasto;
  }


  List<Vantagem> vantagens = [];
  List<Pericia> pericias = [];
  List<Poder> poderes = [];
  
  Map<String, String> habilidadePorPericia = {
    "Acrobacia": "agilidade",
    "Atletismo": "forca",
    "Combate Dis.": "destreza",
    "Combate Corpo a corpo": "luta",
    "Enganação": "presenca",
    "Especialidade":"presenca",
    "Furtividade": "agilidade",
    "Intimidação": "presenca",
    "Intuição":"prontidao",
    "Investigação": "intelecto",
    "Percepção": "prontidao",
    "Persuasão": "presenca",
    "PrestiDig.":"destreza",
    "Tecnologia": "intelecto",
    "Tratamento": "intelecto",
    "Veículos": "destreza",
  };




  //CONSTRUTOR DA FICHA NORMAL
   Ficha._(
    this.np,
    this.nomeJogador,
    this.nomePersonagem,
    this.habilidades,
    this.vantagens,
    this.pericias,
    this.poderes,{
    this.esquiva = 0,
    this.aparar = 0,
    this.fortitude = 0,
    this.resistencia = 0,
    this.vontade = 0,
}) : pontosBase = np*15,
      pontosD=np*15;

  //factory usado para criar objetos, um construtor que decide como e se um objeto será criado, cabe logica dentro deste.
  factory Ficha.criar({
    required int np,
    required String nomeJogador,
    required String nomePersonagem
  }){
     return Ficha._(
      np,
      nomeJogador,
      nomePersonagem,
      {
        'forca': 0,
        'agilidade': 0,
        'destreza': 0,
        'luta': 0,
        'intelecto': 0,
        'prontidao': 0,
        'presenca': 0,
        'vigor': 0,
      },
      [],
      [],
      [],
    );
  }


  // funcao para criar ficha
  Ficha criarFicha({ required int np ,required String nomeJogador ,required String nomePersonagem})  
    {return Ficha.criar(np: np, nomeJogador: nomeJogador, nomePersonagem: nomePersonagem);}


 


  bool adicionarHabilidade(String nome, int valor){
        int habilidade= habilidades[nome]!;
        bool validar=false;
        
        final novoValorHabilidade = habilidade + 1;
        if(valor>0 && pontosD>=2 && habilidade<20 ){
        
        
        if(nome=='luta'){
          if(novoValorHabilidade + resistencia>np*2) return false;
        }
        
        if(nome=='agilidade'){
          if(novoValorHabilidade + resistencia>np*2) return false;
        }

        if(nome=='prontidao'){
          if(novoValorHabilidade + fortitude>np*2) return false;
        }
        
        if(nome=='vigor'){
          if(novoValorHabilidade + aparar>np*2) return false;
          if(novoValorHabilidade + esquiva>np*2) return false;
          if(novoValorHabilidade + vontade>np*2) return false;
        }

          if(nome == 'luta'){
            if(!simulacaoPericia('Combate Corpo a corpo','habilidade')){
              return false; 
            }
          }else if (nome == 'destreza'){
            if(!simulacaoPericia('Combate Dis.','habilidade')){
              return false; 
            }
          }
          for (final entry in habilidadePorPericia.entries) {
            if (entry.value == nome) {
              final nomePericia = entry.key;
              final pericia = verificarPericia(nomePericia);
              final graduacao = pericia?.graduacao ?? 0;

              final novoBonus = novoValorHabilidade + graduacao;

              if (novoBonus > np + 10) {
                return false;
              }
            }
          }
          pontosD -= 2;
          habilidade += valor;
          validar=true;
        }
        else if (valor<0 && habilidade>-5){
          pontosD += 2;
          habilidade +=valor;
          validar=true;
        }
        
        //caso nao mude nada, so fica igual
        habilidades[nome]=habilidade;
        
        recalcularBonusPericias();
        return validar;
        
    } 

  

//PERICIAS
  Pericia? verificarPericia(String nome){
      for (final p in pericias) {
        if (p.nome == nome) return p;
      }
      return null;
    }
  
  
  void recalcularBonusPericias() {
    for (final p in pericias) {
      final habilidadeBase = habilidadePorPericia[p.nome];
      if (habilidadeBase == null) continue;

      final valorHabilidade = habilidades[habilidadeBase];
      if (valorHabilidade == null) continue;

      
      p.bonus = p.graduacao + valorHabilidade;
    }
  }

  int calcularAtaqueCorpo() {
    final habilidade = habilidades['luta'] ?? 0;

    final pericia = verificarPericia('Combate Corpo a corpo')?.graduacao ?? 0;

    final vantagem = verificarVantagem('Ataque Corpo-a-Corpo')?.graduacao ?? 0;

    return habilidade + pericia + vantagem;
  }

  int calcularAtaqueDistancia() {
  final habilidade = habilidades['destreza'] ?? 0;

  final pericia = verificarPericia('Combate Dis.')?.graduacao ?? 0;

  final vantagem = verificarVantagem('Ataque à Distância')?.graduacao ?? 0;

  return habilidade + pericia + vantagem;
}


  bool simulacaoPericia(String nome,String categoria){
    
    switch (categoria){

      case 'pericia':

        if (nome == 'Combate Corpo a corpo') {
          return calcularAtaqueCorpo() + 2 <= np + 10;
        }

        if (nome == 'Combate Dis.') {
          return calcularAtaqueDistancia() + 2 <= np + 10;
        }

        return true;


      case 'habilidade':
        if (nome == 'Combate Corpo a corpo') {
          return calcularAtaqueCorpo() + 1 <= np + 10;
        }

        if (nome == 'Combate Dis.') {
          return calcularAtaqueDistancia() + 1 <= np + 10;
        }

        return true;


      case 'vantagem':
        if (nome == 'Ataque Corpo-a-Corpo') {
          return calcularAtaqueCorpo() + 1 <= np + 10;
        }

        if (nome == 'Ataque à Distância') {
          return calcularAtaqueDistancia() + 1 <= np + 10;
        }




      default:
        return true;
      
    

      }
    //simulação
    return true;
  }

  bool validarPericiaNormal(String nome, int incremento) {
    final habilidadeBase = habilidadePorPericia[nome];
    if (habilidadeBase == null) return true;

    final valorHabilidade = habilidades[habilidadeBase] ?? 0;
    final periciaAtual = verificarPericia(nome)?.graduacao ?? 0;

    final novoBonus = valorHabilidade + periciaAtual + incremento;

    return novoBonus <= np + 10;
  }


  bool adicionarPericia(String nome,int valor){
    Pericia? existe = verificarPericia(nome);
    bool validar =  false;

    //simulação
    


    //adicionar
    if(existe==null && valor>0 && pontosD>=1){
      if(!simulacaoPericia(nome,'pericia')) return false;
      if(!validarPericiaNormal(nome, 2)) return false;
      pericias.add(Pericia(nome: nome, graduacao: 2));
      pontosD -=1;
      validar=true;
    }else if(existe != null && valor>0 && pontosD>=1){
      if(!simulacaoPericia(nome,'pericia')) return false;
      if(!validarPericiaNormal(nome, 2)) return false;
      existe.graduacao +=2;
      pontosD-=1;
      validar=true;
    }

    //remover
    if(existe==null && valor<0){
      return validar;
    }
    else if(existe!= null && valor<0){
      if(existe.graduacao==2){
        existe.graduacao -=2;
        pericias.remove(existe);
        pontosD+=1;
        validar=true;
      }
      else{
      existe.graduacao -= 2;
      pontosD +=1;
      validar=true;
      }
    }
    recalcularBonusPericias();
    return validar;
    }





//VANTAGENS
  Vantagem? verificarVantagem(String nome){
      for (final v in vantagens) {
        if (v.nome == nome) return v;
      }
      return null;
    }
  
  int limiteVantagem(String nome){
    int semLimite = 99;
    switch (nome){

      case 'Ataque Preciso':
        return 4;

      case 'Atraente':
        return 2;

      case 'Evasão':
        return 0;
      
      case 'Idiomas':
        return 12;
      
      case 'Sorte':
        return np~/2;
      
      case 'Tontear':
        return 2;
      
      
      default: 
        return  semLimite;


    }

    

    
  }

  bool adicionarVantagem( String nome, int valor){
    bool validar=false;
    Vantagem? existir = verificarVantagem(nome);
    
    //adicionar
    if(existir==null && pontosD>=1 && valor>0){
      if(!simulacaoPericia(nome, 'vantagem')) return false;
      vantagens.add(Vantagem(nome: nome, graduacao: 1));
      pontosD-=1;
      validar=true;
    }else if(existir!= null && pontosD>=1 && valor>0){
      if(!simulacaoPericia(nome, 'vantagem')) return false;
      int limite=limiteVantagem(existir.nome);
      if (existir.graduacao+1<=limite){
        existir.graduacao+=1;
        pontosD-=1;
        validar=true;
      }else{
        return validar;}

    
    }

    
    //remover
    if(existir==null && valor<0){
      return validar;
    }else if(existir!=null && valor<0 ){
      if(existir.graduacao==1){
      existir.graduacao-=1;
      pontosD+=1;
      vantagens.remove(existir);
      validar=true;
      }
      else{
      existir.graduacao-=1;
      pontosD+=1;
      validar=true;}
    }








    return validar;
  }


//PODERES
  bool adicionarPoderes(String nome){
    bool existe = poderes.any((p) => p.nomePoder == nome);
    if(!existe ){
      poderes.add(Poder(nomePoder: nome));
      return true;
    }
  
    return false;
  }
  
  List<String> acharPoderes() {
    List<String> lista = [];

    for (final Poder poder in poderes) {
      lista.add(poder.nomePoder);
    }

    return lista;
}

 

  //COMPONENTES
  


    
   
  // bool adicionarComponentes(String nomePoder,String nomeComponente,String efeito,int custoBase,int graduacao){
  //   nomePoder;
    
  //   if(!existe){
      
  //     return true;
  //   }
  
  //   return false;

  // }  
  
  
  
  
  
  
  
  
  
  
  
  
  
  Map<String, dynamic> toJson() {
    return {
      'np': np,
      'nomeJogador': nomeJogador,
      'nomePersonagem': nomePersonagem,
      'habilidades': habilidades,
      'defesas': {
        'esquiva': esquiva,
        'aparar': aparar,
        'fortitude': fortitude,
        'resistencia': resistencia,
        'vontade': vontade,
      },
      'vantagens': vantagens.map((v) => v.toJson()).toList(),
      'pericias': pericias.map((p) => p.toJson()).toList(),
      'poderes': poderes.map((p) => p.toJson()).toList(),
      'pontosBase': pontosBase,
      'pontosD': pontosD,
    };
  }

  //CONSTRUTOR PARA O JSON
 Ficha._fromJson(
  this.np,
  this.nomeJogador,
  this.nomePersonagem,
  this.habilidades,
  this.vantagens,
  this.pericias,
  this.poderes,
  this.pontosD,
  this.esquiva,
  this.aparar,
  this.fortitude,
  this.resistencia,
  this.vontade,
): pontosBase= np * 15;
 

  factory Ficha.fromJson(Map<String, dynamic> json) {
  final defesas = json['defesas'] as Map<String, dynamic>;

  return Ficha._fromJson(
    (json['np'] as num).toInt(),
    json['nomeJogador'] as String,
    json['nomePersonagem'] as String,
    Map<String, int>.from(json['habilidades']),
    (json['vantagens'] as List<dynamic>)
        .map((v) => Vantagem.fromJson(v))
        .toList(),
    (json['pericias'] as List<dynamic>)
        .map((p) => Pericia.fromJson(p))
        .toList(),
    (json['poderes'] as List<dynamic>)
        .map((p) => Poder.fromJson(p))
        .toList(),
    (json['pontosD'] as num).toInt(),
    (defesas['esquiva'] as num).toInt(),
    (defesas['aparar'] as num).toInt(),
    (defesas['fortitude'] as num).toInt(),
    (defesas['resistencia'] as num).toInt(),
    (defesas['vontade'] as num).toInt(),
  );
}



}







