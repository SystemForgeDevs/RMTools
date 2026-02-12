class Rolagens{
//test para saber se a ação é efetuada
bool testeSimples(int dado, int modificador,int bonus,int cd){

  if( cd <= dado+modificador+ bonus){
    return true;
  }
  return false;
  }

int testeGraduado(int cd,int dado,){
  return 0;
  }
}