package processing.test.sms_wall;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.content.BroadcastReceiver; 
import android.content.Context; 
import android.content.Intent; 
import org.apache.http.client.methods.HttpPost; 
import org.apache.http.HttpEntity; 
import org.apache.http.HttpResponse; 
import org.apache.http.impl.client.DefaultHttpClient; 
import apwidgets.*; 
import android.view.inputmethod.EditorInfo; 
import android.text.InputType; 
import android.content.IntentFilter; 
import android.os.Bundle; 
import android.telephony.gsm.SmsMessage; 
import android.view.MotionEvent; 
import ketai.ui.*; 
import ketai.net.*; 
import java.awt.*; 
import java.awt.event.*; 
import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sms_wall extends PApplet {


/*
    Example code to receive SMS in Processing, Tested on Processing 2.0b7 and a phone on Android Jelly bean
 by Julien Rat
 feb 2013
 
 Make sure to enable this permission in your sketch:
 RECEIVE_SMS
 */













APWidgetContainer widgetContainer; 
APEditText titre_input, url_input;











KetaiGesture gesture;
float largeur, hauteur;
String url_serveur = "http://192.168.1.32/site/add_sms.php";
String message = ""; 
String titre="titre";
String number = ""; 
PImage fond;
PFont text_font, button_font;
int nb_message=0;

float bouton_xmin=(69.0f/600.0f);
float bouton_xmax=(530.0f/600.0f);
//*Boutons en Y
//*bouton lecture
float play_ymin=706.0f/1024.0f;
float play_ymax=804.0f/1024.0f;
//*bouton pause
float pause_ymin=844.0f/1024.0f;
float pause_ymax=945.0f/1024.0f;


SmsReceiver mySMSReceiver = new SmsReceiver();
public void setup() {

  // Determination de la zone d'affichage
  hauteur=displayHeight;
  largeur=displayWidth;
  noStroke();
   // mise \u00e0 l'echelle des elements graphiques en fonction de la taille de l'ecran
  bouton_xmin=bouton_xmin*largeur;
  bouton_xmax=bouton_xmax*largeur;
  //*Boutons en Y
  //*bouton lecture
  play_ymin=play_ymin*hauteur;
  play_ymax=play_ymax*hauteur;
  //*bouton pause
  pause_ymin=pause_ymin*hauteur;
  pause_ymax=pause_ymax*hauteur;
  gesture = new KetaiGesture(this); // cr\u00e9ation de l'objet gesture, gestion des mvts des doigts
  fond=loadImage("smswall.png");
  button_font=loadFont("CurseCasualJVE-30.vlw");
  text_font=loadFont("DejaVuSans-12.vlw");
  textFont(text_font);
  textAlign(CENTER,CENTER);
  orientation(PORTRAIT);
 
  image(fond, 0, 0, largeur, hauteur);
  widgetContainer = new APWidgetContainer(this); //create new container for widgets
  fill(0);
  text("Entrez l'adresse du serveur",largeur/2.0f,4.5f*hauteur/16.0f);
  url_input = new APEditText(PApplet.parseInt(largeur/2.0f)-PApplet.parseInt(((4*largeur)/5.0f)/2.0f), PApplet.parseInt(5*hauteur/16), PApplet.parseInt((4*largeur)/5.0f), 50); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget( url_input); //place textField in container
  url_input.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  url_input.setImeOptions(EditorInfo.IME_ACTION_DONE);
  url_input.setCloseImeOnDone(true);
  text("Entrez le titre du sondage",largeur/2.0f,7.5f*hauteur/16.0f);
  
  titre_input = new APEditText(PApplet.parseInt(largeur/2.0f)-PApplet.parseInt(((4*largeur)/5.0f)/2.0f), PApplet.parseInt(8*hauteur/16), PApplet.parseInt((4*largeur)/5.0f), 50); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(titre_input); //place textField in container
  titre_input.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  titre_input.setImeOptions(EditorInfo.IME_ACTION_DONE);
  titre_input.setCloseImeOnDone(true);
  textFont(button_font);
      fill(176,103,17);
      rect(bouton_xmin,play_ymin,bouton_xmax-bouton_xmin,play_ymax-play_ymin);
      fill(255);
      text("D\u00e9marrer",largeur/2,(play_ymax-play_ymin)/2+play_ymin);
      
      text("Effacer le mur",largeur/2,(pause_ymax-pause_ymin)/2+pause_ymin); // add_sms.php?efface=1
 
}

public void draw() {
//myPort.write("bonjour");
//delay(1000);
 
}

public class SmsReceiver extends BroadcastReceiver //Class to get SMS
{
  @Override
    public void onReceive(Context context, Intent intent) 
  {
    //---get the SMS message passed in---
    Bundle bundle = intent.getExtras();        
    SmsMessage[] msgs = null;
    String caller="";
    String str="";

    if (bundle != null)
    {
      //---retrieve the SMS message received---
      Object[] pdus = (Object[]) bundle.get("pdus");
      msgs = new SmsMessage[pdus.length];            
      for (int i=0; i<msgs.length; i++) {
        msgs[i] = SmsMessage.createFromPdu((byte[])pdus[i]);                
        caller += msgs[i].getOriginatingAddress();
        str += msgs[i].getMessageBody().toString();
      }
    }   
    message=str;
    number=caller;
    
    if(PLAY_PAUSE){
    nb_message++;
    String request = url_serveur+"add_sms.php"+"?phrases=" + message +"&titre="+titre +"&tel="+number;
    request=request.replaceAll(" ", "%20");
    request=request.replaceAll("'", "%27");
    try {
      HttpPost          httpPost   = new HttpPost( request );
      DefaultHttpClient httpClient = new DefaultHttpClient();
      HttpResponse response = httpClient.execute( httpPost );
     
    }
    catch( Exception e ) { 
      e.printStackTrace();
    }
  }
  }
}



@Override
public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  IntentFilter filter = new IntentFilter("android.provider.Telephony.SMS_RECEIVED");   
  registerReceiver(mySMSReceiver, filter); // launch class when SMS are RECEIVED
}



/*  UI-related functions */
boolean PLAY_PAUSE=false;

public void mousePressed()
{
  textFont(button_font);
  if (url_input.getText()!="") {
    url_serveur=url_input.getText();
    
  }
  if (titre_input.getText()!="") {
    titre=titre_input.getText();
    titre=titre.replaceAll(" ", "%20");
    titre=titre.replaceAll("'", "%27");
  }
  println("appuy\u00e9");
  if (mouseX>bouton_xmin &&
    mouseX<bouton_xmax &&
    mouseY>play_ymin   &&
    mouseY<play_ymax) {
    if (!PLAY_PAUSE) {
      PLAY_PAUSE=true;
      fill(176, 103, 17);
      rect(bouton_xmin, play_ymin, bouton_xmax-bouton_xmin, play_ymax-play_ymin);
      fill(255);

      text("Arreter", largeur/2, (play_ymax-play_ymin)/2+play_ymin);
      println(url_serveur+"add_sms.php?titre=" +titre);
      try {
        HttpPost          httpPost   = new HttpPost( url_serveur+"add_sms.php?titre=" +titre);
        DefaultHttpClient httpClient = new DefaultHttpClient();
        HttpResponse response = httpClient.execute( httpPost );
      }
      catch( Exception e ) { 
        e.printStackTrace();
      }
      println("bouton play");
    }
    else {
      PLAY_PAUSE=false;
      fill(176, 103, 17);
      rect(bouton_xmin, play_ymin, bouton_xmax-bouton_xmin, play_ymax-play_ymin);
      fill(255);
      text("D\u00e9marrer", largeur/2, (play_ymax-play_ymin)/2+play_ymin);
      println("bouton pause");
    }
  }
  if (mouseX>bouton_xmin &&
    mouseX<bouton_xmax &&
    mouseY>pause_ymin   &&
    mouseY<pause_ymax) {
    fill(176, 103, 17);
    rect(bouton_xmin, pause_ymin, bouton_xmax-bouton_xmin, pause_ymax-pause_ymin);
    fill(255);
    text("Effacer le mur", largeur/2, (pause_ymax-pause_ymin)/2+pause_ymin); // add_sms.php?efface=1
    try {
      HttpPost          httpPost   = new HttpPost( url_serveur+"add_sms.php?efface=1" );
      DefaultHttpClient httpClient = new DefaultHttpClient();
      HttpResponse response = httpClient.execute( httpPost );
     
    }
    catch( Exception e ) { 
      e.printStackTrace();
    }
    println("bouton erase");
  }
}

public void mouseDragged()
{
}

public void keyPressed() {
}


public void drawUI()
{
}
public void onPinch(float x, float y, float d)
{
}

public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}


  public int sketchWidth() { return displayWidth; }
  public int sketchHeight() { return displayHeight; }
}
