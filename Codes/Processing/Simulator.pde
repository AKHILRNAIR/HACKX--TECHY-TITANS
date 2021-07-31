import processing.serial.*;
import processing.opengl.*;

Serial serial;
int serialPort = 1;   
              
int a = 3; 
int b = 3; 

Stnd n[] = new Stnd[a];
Calc cama[] = new Calc[a];
Calc axyz[] = new Calc[a];
float[] nxyz = new float[a];
int[] ixyz = new int[a];

float w = 256; 
boolean[] flip = {
  false, true, false};

int P = 0;
boolean m[][][][];

PFont f;

void setup() {
  size(800, 600, OPENGL);
  frameRate(25);
  
  f = loadFont("TrebuchetMS-Italic-20.vlw");
  textFont(f);
  textMode(SHAPE);
  
  println(Serial.list());
  serial = new Serial(this, "COM3", 115200);
  
  for(int i = 0; i < a; i++) {
    n[i] = new Stnd();
    cama[i] = new Calc(.01);
    axyz[i] = new Calc(.15);
  }
  
  reset();
}

void draw() {
  up_s();
  dr_b();
}

void up_s() {
  String s = serial.readStringUntil('\n');
  if(s != null) {
    
    String[] parts = split(s, " ");
    if(parts.length == a  ) {
      float[] xyz = new float[a];
      for(int i = 0; i < a; i++)
        xyz[i] = float(parts[i]);
  
      if(mousePressed && mouseButton == LEFT)
        for(int i = 0; i < a; i++)
          n[i].note(xyz[i]);
  
      nxyz = new float[a];
      for(int i = 0; i < a; i++) {
        float raw = n[i].choose(xyz[i]);
        nxyz[i] = flip[i] ? 1 - raw : raw;
        cama[i].note(nxyz[i]);
        axyz[i].note(nxyz[i]);
        ixyz[i] = g_Pos(axyz[i].avg);
      }
    }
  }
}

float cf = .2;
int g_Pos(float x) {
  if(b == 3) {
    if(x < cf)
      return 0;
    if(x < 1 - cf)
      return 1;
    else
      return 2;
  } 
  else {
    return x == 1 ? b - 1 : (int) x * b;
  }
}

void dr_b() {
  background(255);

  float h = w / 2;
  camera(
    h + (cama[0].avg - cama[2].avg) * h,
    h + (cama[1].avg - 1) * height / 2,
    w * 2,
    h, h, h,
    0, 1, 0);

  pushMatrix();
  

  noFill();
  stroke(0, 40);
  translate(w/2, w/2, w/2);
  rotateY(-HALF_PI/2);
  box(w);
  popMatrix();

  float g = w / b;
  translate(h, g / 2, 0);
  rotateY(-HALF_PI/2);

  pushMatrix();
  float sd = g * (b - 1);
  translate(
    axyz[0].avg * sd,
    axyz[1].avg * sd,
    axyz[2].avg * sd);
  fill(255, 160, 0, 200);
  noStroke();
  sphere(18);
  popMatrix();

  for(int z = 0; z < b; z++) {
    for(int y = 0; y < b; y++) {
      for(int x = 0; x < b; x++) {
        pushMatrix();
        translate(x * g, y * g, z * g);

        noStroke();
        if(m[0][x][y][z])
          fill(255, 0, 0, 200); 
        else if(m[1][x][y][z])
          fill(0, 0, 255, 200); 
        else if(
        x == ixyz[0] &&
          y == ixyz[1] &&
          z == ixyz[2])
          if(P == 0)
            fill(255, 0, 0, 200); 
          else
            fill(0, 0, 255, 200); 
        else
          fill(0, 100); 
        box(g / 3);

        popMatrix();
      }
    }
  }
  
  stroke(0);
  if(mousePressed && mouseButton == LEFT)
    str("defining boundaries");
}

void k_Pr() {
  if(key == TAB) {
    m[P][ixyz[0]][ixyz[1]][ixyz[2]] = true;
    P = P == 0 ? 1 : 0;
  }
}

void mousePressed() {
  if(mouseButton == RIGHT)
    reset();
}

void reset() {
  m = new boolean[2][b][b][b];
  for(int i = 0; i < a; i++) {
    n[i].reset();
    cama[i].reset();
    axyz[i].reset();
  }
}

void str(String str) {
 
  println(str);
}
