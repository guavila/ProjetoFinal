Table table;
float x,y = 0;
int iniciox=50;
int inicioy=10;
int i=0;

int tamanho = 10;

//desenhando a estrutura do grafico de waffle
int num_pesq = 4720;
int break_pesq = (80*tamanho)+iniciox;

int bola_da_vez = 0;
int len;
int break_string=0;
int break_string2=0;
int break_string3=0;

int ac_elogio=0,tot_elogio=0;
int ac_neutro=0,tot_neutro=0;
int ac_reclamacao=0,tot_reclamacao=0;
float result_elogio,result_neutro,result_reclamacao,result;


PFont f,F;

Pesquisa[] pesquisas   = new Pesquisa[num_pesq];

void setup(){
  size(900,750);
  background(#424242);
  
  //preparando fonte e tabela de dados
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  F = createFont("Arial Bold",18,true); // Arial, 16 point, anti-aliasing on
  table = loadTable("dados_2016_07.csv", "header");

  x=iniciox;
  y=inicioy;
  
  //criando os quadrados, onde cada quadrado é uma pesquisa de satisfação
  for (int i = 0; i < num_pesq; i++) {
    pesquisas[i] = new Pesquisa(x,y,tamanho,i);
    x=x+tamanho;
    if (x==break_pesq){
      y=y+tamanho;
      x=iniciox;
    }
  }
  
  //carregando tabela de dados das pesquisas
  println(table.getRowCount() + " total rows in table"); 
  for (TableRow row : table.rows()) {
    int id = row.getInt("id");
    String comentario = row.getString("Comentário");
    String manif_geral = row.getString("label");
    String predicted = row.getString("predicted");
    int nota1 = row.getInt("Nota1");
    int nota2 = row.getInt("Nota2");
    
    //tratamento as bolas de acordo com a polaridade
    pesquisas[id].comentario=comentario;
    pesquisas[id].label = manif_geral;
    pesquisas[id].predicted = predicted;
    pesquisas[id].nota1 = nota1;
    pesquisas[id].nota2 = nota2;
  }
}

void draw(){
  background(#424242);
  for (Pesquisa pesquisa : pesquisas) {
    pesquisa.display();
  }
  textFont(f,10);                      
  fill(255);       
  text(pesquisas[bola_da_vez].id+ "  -  predicted: " + pesquisas[bola_da_vez].predicted+ "  -  label: " + pesquisas[bola_da_vez].label + "  -  nota1: "+ pesquisas[bola_da_vez].nota1 + "  -  nota2: "+ pesquisas[bola_da_vez].nota2,50,640);
  len = pesquisas[bola_da_vez].comentario.length( );
    if (len<=150){
      text(pesquisas[bola_da_vez].comentario,50,660);
    }
    else if(len>150 && len<=300){
      for (int i = 0 ; i<15 ; i++){
        if (pesquisas[bola_da_vez].comentario.substring(134,150).charAt(i) == ' '){
          break_string=134+i;
          break;
        }
      }
      text(pesquisas[bola_da_vez].comentario.substring(0,break_string),50,660);
      text(pesquisas[bola_da_vez].comentario.substring(break_string+1,len),50,670);
    }
    else if(len>305 && len<=455){
      for (int i = 0 ; i<15 ; i++){
        if (pesquisas[bola_da_vez].comentario.substring(134,150).charAt(i) == ' '){
          break_string=134+i;
          break;
        }
      }
      for (int i = 0 ; i<15 ; i++){
        if (pesquisas[bola_da_vez].comentario.substring(284,300).charAt(i) == ' '){
          break_string2=284+i;
          break;
        }
      }
      text(pesquisas[bola_da_vez].comentario.substring(0,break_string),50,660);
      text(pesquisas[bola_da_vez].comentario.substring(break_string+1,break_string2),50,670);
      text(pesquisas[bola_da_vez].comentario.substring(break_string2+1,len),50,680);
    }
    else if(len>455){
      for (int i = 0 ; i<15 ; i++){
        if (pesquisas[bola_da_vez].comentario.substring(134,150).charAt(i) == ' '){
          break_string=134+i;
          break;
        }
      }
      for (int i = 0 ; i<15 ; i++){
        if (pesquisas[bola_da_vez].comentario.substring(284,300).charAt(i) == ' '){
          break_string2=284+i;
          break;
        }
      }
      for (int i = 0 ; i<15 ; i++){
        if (pesquisas[bola_da_vez].comentario.substring(434,450).charAt(i) == ' '){
          break_string3=434+i;
          break;
        }
      }
      text(pesquisas[bola_da_vez].comentario.substring(0,break_string),50,660);
      text(pesquisas[bola_da_vez].comentario.substring(break_string+1,break_string2),50,670);
      text(pesquisas[bola_da_vez].comentario.substring(break_string2+1,break_string3),50,680);
      if(len>600){
          text("...",50,690);
      }
  }
  
  //rectangle para destacar o texto
  fill(#8C8C8C,100);
  strokeWeight(1);
  stroke(0);
  rect(50,630,800,70);
  
  //legenda
  fill(#7498F0);
  rect(50,610,10,10);
  fill(255); 
  text("elogio",70,620);
  
  fill(#3F5CA4);
  rect(120,610,10,10);
  fill(255); 
  text("neutro",140,620);
  
  fill(#192B57);
  rect(190,610,10,10);
  fill(255); 
  text("reclamação",210,620);
  
  fill(#FF0000);
  rect(280,610,10,10);
  fill(#D61324);
  rect(290,610,10,10);
  fill(#74101A);
  rect(300,610,10,10);
  fill(255); 
  text("erro classificação",320,620);
 
  //inserir percentual de acerto total e por label
  textFont(F,13); 
  
  //percentual de acerto consolidado
  fill(255);
  result=float(ac_elogio+ac_neutro+ac_reclamacao)/float(tot_elogio+tot_neutro+tot_reclamacao);
  text(nf(result*100,2,1)+"%",iniciox-45,inicioy+10);
  text("score",iniciox-45,inicioy+30);
  
  //elogio-percentual de acerto
  fill(#7498F0);
  result_elogio=float(ac_elogio)/float(tot_elogio);
  text(nf(result_elogio*100,2,1)+"%",(80*tamanho)+iniciox+5,inicioy+10);
  
  //neutro-percentual de acerto
  fill(#7498F0);
  result_neutro=float(ac_neutro)/float(tot_neutro);
  text(nf(result_neutro*100,2,1)+"%",(80*tamanho)+iniciox+5,inicioy+380);
  
  //reclamação-percentual de acerto
  fill(#7498F0);
  result_reclamacao=float(ac_reclamacao)/float(tot_reclamacao);
  text(nf(result_reclamacao*100,2,1)+"%",(80*tamanho)+iniciox+5,inicioy+540);


}


class Pesquisa {
  
  float x, y;
  int tamanho;
  int id;
  String comentario;
  String label;
  String predicted;
  boolean over_box;
  boolean locked;
  int nota1,nota2;
 
  Pesquisa(float xin, float yin, int tamanhoin, int idin) {
    x = xin;
    y = yin;
    tamanho = tamanhoin;
    id = idin;
    over_box=false;
    locked=false;
  }
  
  void display() {
    if (label.equals("elogio")){
      fill(#7498F0);
      tot_elogio=tot_elogio+1;
    }
    if (label.equals("neutro")){
      fill(#3F5CA4);
      tot_neutro=tot_neutro+1;
    }
    if (label.equals("reclamação")){
      fill(#192B57);
      tot_reclamacao=tot_reclamacao+1;
    }
    if (!label.equals(predicted)){
      //elogio
      if (label.equals("elogio") && predicted.equals("neutro")){
        fill(#D61324);
      }
      else if (label.equals("elogio") && predicted.equals("reclamação")){
        fill(#74101A);
      }
      
      //neutro
      if (label.equals("neutro") && predicted.equals("elogio")){
        fill(#FF0000);
      }
      else if (label.equals("neutro") && predicted.equals("reclamação")){
        fill(#74101A);
      }
      
      //reclamação
      if (label.equals("reclamação") && predicted.equals("elogio")){
        fill(#FF0000);
      }
      else if (label.equals("reclamação") && predicted.equals("neutro")){
        fill(#D61324);
      }
      
    }
    
    else if (label.equals(predicted)){
      if (label.equals("elogio") && predicted.equals("elogio")){
        ac_elogio=ac_elogio+1;
      }
      if (label.equals("neutro") && predicted.equals("neutro")){
        ac_neutro=ac_neutro+1;
      }
      if (label.equals("reclamação") && predicted.equals("reclamação")){
        ac_reclamacao=ac_reclamacao+1;
      }
    }


    
    // Testando se o cursor está sobre a Pesquisa
    if (mouseX > x && mouseX < x+tamanho && 
      mouseY > y && mouseY < y+tamanho) {
      over_box = true;
      stroke(255);
      strokeWeight(1);
      if (id != bola_da_vez){
        //println(id + "  -  " + comentario);        
        bola_da_vez=id;
      } 
    }
    else {
    over_box = false;
    stroke(0);
    }
   
   rect(x, y, tamanho, tamanho);

  }
}