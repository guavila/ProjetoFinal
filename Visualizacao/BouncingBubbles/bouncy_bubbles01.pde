Table table;
int i = 0;
float xOffset = 0.0; 
float yOffset = 0.0;
int bola_da_vez = 0;

int numBalls=18;
float spring = 0.05;
float gravity = 0.03;
float friction = -0.9;

Ball[] balls = new Ball[numBalls];

PFont f;

void setup() {
  size(640, 360);
  f = createFont("Arial",16,true); // Arial, 16 point, anti-aliasing on
  table = loadTable("dados.csv", "header");
  
  //criando as bolas
  for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), 10, i, balls);
  }
  
  //carregando tabela de dados das palavras
  println(table.getRowCount() + " total rows in table"); 
  for (TableRow row : table.rows()) {
    int id = row.getInt("id");
    String palavra = row.getString("palavra");
    String polaridade = row.getString("polaridade");
    float tamanho = row.getFloat("tamanho");
    int contagem = row.getInt("contagem");
    //println(id + " - " + palavra + " (" + polaridade + ") tem diametro(d): " + tamanho);
    
    //tratamento as bolas de acordo com a polaridade
    balls[id].titulo=palavra;
    balls[id].diameter = tamanho;
    balls[id].contagem = contagem;
    
    if (polaridade.equals("pos")){
      balls[id].pol = 1;
    }
    if (polaridade.equals("neg")){
      balls[id].pol = 0;
    }
    if (polaridade.equals("neu")){
      balls[id].pol = 2;
    }
  }
  
  noStroke();
  fill(255, 204);
}

void draw() {
  background(#424242);
  
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();
  
    textFont(f,10);                          // STEP 3 Specify font to be used
    fill(255);                               // STEP 4 Specify font color 
    text(balls[bola_da_vez].titulo + "   # " + balls[bola_da_vez].contagem,30,30);   // STEP 5 Display Text
    
    //rectangle para destacar o texto
    fill(255,0.2);
    strokeWeight(1);
    rect(10,10,200,30);
  }
}

//Ações ao pressionar o mouse - Testando se o cursor foi pressionado sobre a elipse
void mousePressed() {
  for (int i = 0; i < numBalls; i++) {
    if (balls[i].over_box == true) {
      balls[i].locked = true; 
    }
    else {
      balls[i].locked = false;
    }
  }
  xOffset = mouseX-balls[bola_da_vez].x; 
  yOffset = mouseY-balls[bola_da_vez].y;


}

void mouseDragged() {
  if(balls[bola_da_vez].locked) {
    balls[bola_da_vez].x = mouseX-xOffset; 
    balls[bola_da_vez].y = mouseY-yOffset; 
  }
}

void mouseReleased() {
  balls[bola_da_vez].locked = false;
}


class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id,pol,contagem;
  String titulo;
  boolean over_box;
  boolean locked;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    pol=0;
    contagem=0;
    over_box=false;
    locked=false;
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    if (pol==0){
      fill(#F30432);
    }
    if (pol==1){
      fill(#04EE41);
    }
    if (pol==2){
      fill(#FBE552);
    }
    
    // Testando se o cursor está sobre a elipse
    if (mouseX > x-diameter && mouseX < x+diameter && 
      mouseY > y-diameter && mouseY < y+diameter) {
      over_box = true;
      stroke(255);
      strokeWeight(3);
      if (id != bola_da_vez){
        //println(titulo + "  -  " + diameter);
        bola_da_vez=id;
      } 
    }
    else {
    over_box = false;
    noStroke();
    }
   
   ellipse(x, y, diameter, diameter);

  }
}