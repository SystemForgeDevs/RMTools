
//test para saber se a ação é efetuada
bool testeSimples(int dado, int modificador,int bonus,int cd){

  if( cd <= dado+modificador+ bonus){
    return true;
  }
  return false;
}

int testeGraduado(){
  return 0;
}