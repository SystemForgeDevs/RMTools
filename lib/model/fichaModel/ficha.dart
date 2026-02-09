class Modificador {
  final String nome;
  final int valor;
  final bool porGraduacao;

  Modificador({
    required this.nome,
    required this.valor,
    required this.porGraduacao,
  });

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
  int? bonus;
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
  List<Vantagem> vantagens = [];
  List<Pericia> pericias = [];
  List<Poder> poderes = [];
  
  Map<String, String> habilidadePorPericia = {
  "Acrobacia": "agilidade",
  "Atletismo": "forca",
  "Combate Dis.": "destreza",
  "Combate CaC.": "luta",
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




  //CONSRUTOR DA FICHA NORMAL
   Ficha._(
    this.np,
    this.nomeJogador,
    this.nomePersonagem,
    this.habilidades,
    this.vantagens,
    this.pericias,
    this.poderes, 
  ) : pontosBase = np*15,
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
        
        if(valor>0 && pontosD>=2 && habilidade<20 ){
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

  bool adicionarPericia(String nome,int valor){
    Pericia? existe = verificarPericia(nome);
    bool validar =  false;
    
    //adicionar
    if(existe==null && valor>0 && pontosD>=1){
      pericias.add(Pericia(nome: nome, graduacao: 2));
      pontosD -=1;
      validar=true;
    }else if(existe != null && valor>0 && pontosD>=1){
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
      vantagens.add(Vantagem(nome: nome, graduacao: 1));
      pontosD-=1;
      validar=true;
    }else if(existir!= null && pontosD>=1 && valor>0){
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
  ) : pontosBase = np * 15;

  factory Ficha.fromJson(Map<String, dynamic> json) {
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
      );
    }


}







