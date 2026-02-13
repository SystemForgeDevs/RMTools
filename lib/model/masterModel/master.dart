
class Rolagens{
//test para saber se a ação é efetuada
bool testeSimples(int dado, int modificador,int bonus,int cd){

  if( cd <= dado+modificador+ bonus){
    return true;
  }
  return false;
  }

int testeGraduado(int cd,int dado,int bonus,int modificador){
    int diferenca = (dado+bonus+modificador) - cd; //5
    int grau;
    if(dado==20) grau = 1;
    
    if(diferenca>=0){
      grau = 1 + (diferenca~/5);
    }else {
      grau = -1 + (diferenca~/5);
    }
    
    if(dado==20) grau += 1;
    if(dado==1)  grau -= 1;
    grau = grau.clamp(-4, 4);     
    return grau;
  
  
  }


}