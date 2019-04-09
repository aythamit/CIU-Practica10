import processing.sound.*;
import processing.serial.*;

int frame = 0;
int ancho = 600;
int alto = 400;
int marcadorJ1 = 0;
int marcadorJ2 = 0;
SoundFile golpe;
SoundFile gol;
SoundFile musica;
Jugador j1;
Jugador j2;
Pelota pelota;

Serial myPort;
String val;

void setup() {
	size(600 , 400);
	frameRate( 30 );
String portName = Serial.list()[0] ; //change the 0 to a 1 or 2 e tc . to match your port
  myPort = new Serial ( this , portName , 9600) ;
  j1 = new Jugador(1,10,height/2);
  j2 = new Jugador(2,width-20,height/2); //jugXDerecha = width-50;
	pelota = new Pelota(width/2,height/2, 15, 5);
  gol = new SoundFile(this, "sounds/gol.wav");
  golpe = new SoundFile(this, "sounds/golpe.wav");
  musica = new SoundFile(this, "sounds/musica.mp3");
  thread("suena");
}

void draw ( ){
  
  background(0);
  //marcador y linea centrar
  textSize(32);
  text (""+ marcadorJ1 , width/4, 30);
  text (""+ marcadorJ2 , width*0.75, 30);
  stroke (255 ,255 ,255 ) ;
  for(int i = 0; i < alto; i= i+ 10){
     line(ancho/2,i,ancho/2,i+10);
     i = i + 5;
   }
  
  //j2.update(); //jugYDerecha = mouseY - 30;
	actualizaJugadorUno();
  // Dibujamos 
  pelota.display(); // ellipse ( pelotaX ,  pelotaY , pelotaRadio , pelotaRadio ) ;
	j1.display();
  j2.display(); // rect( jugXDerecha , jugYDerecha , 10 , 30 ) ;

  if(pelota.getX() + pelota.getVelocidad() >= j2.getX() && j2.getY() <= pelota.getY() &&  j2.getY()+30 >= pelota.getY()){
    golpe.play();
    pelota.invVelocidad();
		pelota.randomDireccion();
  }
  if(pelota.getX() + pelota.getVelocidad() <= j1.getX() && j1.getY() <= pelota.getY() &&  j1.getY()+30 >= pelota.getY()){
    golpe.play();
    pelota.invVelocidad();
		pelota.randomDireccion();
  }
  
  // Choca arriba o abajo
	if(pelota.getY() + pelota.getDireccion() >= height || pelota.getY() + pelota.getDireccion() <= 0){
		pelota.invDireccion();
	}
  //Gol jugador 1
 if(pelota.getX() + pelota.getVelocidad() >= ancho){
    gol.play();
	 	textSize(24);
    text ("GOOOOL DEL JUGADOR 1" , width/2-140, height-50) ;
    marcadorJ1++;
    
    noLoop();
  }
  
  //Gol jugador 2
 if(pelota.getX() + pelota.getVelocidad() <= 0){
    gol.play();
 		textSize(24);
    text ("GOOOOL DEL JUGADOR 2" , width/2-140, height-50) ;
    marcadorJ2++;
    noLoop();
    //velocidadPelota = velocidadPelota*-1;
  }
  //pelotaX = pelotaX +velocidadPelota;
	pelota.update();
}
void suena(){
  musica.loop();
}

void actualizaJugadorUno(){
  if( myPort.available( ) > 0 ){ // I f data i s a vailabl e ,
    val = myPort.readStringUntil( '\n') ; // read i t and s to re i t in val
    print(val); // p rin t i t out in the console
   if(val != null){
      float x = map( Float.parseFloat(val), 0.0,512,0.0,400.0);
      j1.setY((int)x);
   }
  }
  
}
void keyPressed() {
	int velocidadJugador = 20;
			if( key == CODED){
				if ( keyCode == UP || keyCode == 87) {
					if(j1.getY() - velocidadJugador > 0){  j1.setY (j1.getY() - velocidadJugador);}
				}
				if ( keyCode == DOWN || keyCode == 83) {
					if(j1.getY() + velocidadJugador < height - 30){j1.setY (j1.getY() + velocidadJugador);}
				}
			}
	}
void mouseMoved() {
	j2.setY(mouseY - 30);
}
void mousePressed ( ) {
  loop ( ) ;
  pelota.setX(ancho/2);
  frame = 0;
}
class Jugador { 
	int x;
	int y;
	int id;
	
	Jugador(int tempID,int tempX, int tempY){
		x = tempX;
		y = tempY;
		id = tempID;
	}
	int getX(){return x;}
	int getY(){return y;}
	void setY(int nY){ y = nY;}
	void display(){
	  rect( x , y , 10 , 30 ) ;
	}	
}
class Pelota {
	int x;
	int y;
	int radio;
	int velocidad;
	int direccion;
	Pelota(int xTemp, int yTemp, int radioTemp, int velo){
		x = xTemp;
		y = yTemp;
		radio = radioTemp;
		velocidad = velo;
		randomDireccion();
	}
	int getX(){return x;}
	int getY(){return y;}
	int getRadio(){return radio;}
	int getVelocidad(){return velocidad;}
	int getDireccion(){return direccion;}
	void setX(int nX){ x = nX;}
	void setY(int nY){ y = nY;}
	void display(){
	ellipse ( x ,  y , radio , radio );
	}
	void update(){
		x = x + velocidad;
		y = y + direccion;
	}
	void invDireccion(){
		direccion = direccion * -1;
	}
	void invVelocidad(){
		velocidad = velocidad * -1;
	}
	void randomDireccion(){
		direccion = (int)random(-10, 10);
	}
}
