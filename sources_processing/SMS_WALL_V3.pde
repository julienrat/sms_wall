
/*
Application Android pour le Mur de SMS, nuage de tags
 
 Cette application tranfert tout les SMS passant sur le téléphone 
 sur un mur hébergé sur un serveur PHP/MYSQL
 
 INSTALLATION
 1 - Activez "sources inconnues sur votre mobile
 2 - Téléchargez l'application.apk
 3 - Installez le logiciel
 4 - Indiquez l'adresse du serveur
 5 - Le titre du sondage
 6 - cliquez sur démarrer
 7 - Rendez vous avec un ordinateur sur le site SMSWALL pour visualiser 
 l'arrivée des SMS
 
 BASE DE DONNEE
 créer une base sur votre serveur PHP/MSQL
 +--------+---------+--------+--------+----------------+
 |nom     | phrases | titre  |   tel  |       id       |
 +--------+---------+--------+--------+----------------+
 | String | String  | String | String | int incrémenté |
 +--------+---------+--------+--------+----------------+
 
 FONTIONNEMENT DES REQUETES
 -- envoyer un titre au site :
 url_serveur+"add_sms.php?titre=" +titre
 
 -- envoi d'un SMS :
 url_serveur+"add_sms.php"+"?phrases=" + message +"&titre="+titre +"&tel="+numéro_de_tel
 
 -- effacer la base de donnée :
 url_serveur+"add_sms.php"+"?efface=1  
 
 COMPILATION 
 - Assurez vous d'activer la permission RECEIVE_SMS et INTERNET
 
 Julien RAT - Guillaume Remaud, Les Petits Débrouillards 2013 
 sous license GNU-GPL.
 Contact :
 j.rat@lespetitsdebrouillards.org
 */

//Chargement des bibliothèques SMS
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.telephony.gsm.SmsMessage;

//Chargement des Bibliothèques permettant d'envoyer des Post sur le web
import org.apache.http.client.methods.HttpPost;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.impl.client.DefaultHttpClient;

//Chargement des bibliothèques APWIDGET pour les zones de saisie
import apwidgets.*;
import android.view.inputmethod.EditorInfo;
import android.text.InputType;

//Bibliothèque de gestion de la fenetre
import android.view.WindowManager;

//Bibliothèque des actions de touché
import android.view.MotionEvent;
import ketai.ui.*;
import ketai.net.*;

// Bibliothèque de gestion des erreurs java
import java.awt.*;
import java.awt.event.*;
import java.io.*;

//Construction des zones de saisie
APWidgetContainer widgetContainer; 
APEditText titre_input, url_input;

//Construction de la zone de touché
KetaiGesture gesture;

//Constriction d'un objet SMS
SmsReceiver mySMSReceiver = new SmsReceiver();

///////////////*variables*////////////////////

float largeur, hauteur; // largeur et hauteur de l'ecran
String url_serveur = "http://sondages.lespetitsdebrouillardspc.org/smswall/"; // variable d'url par défaut
String message = "";  // corps du SMS
String titre=""; // titre du SMS
String number = "";  
PImage fond; // image de fond
PFont text_font, button_font; // polices des textes et des boutons
int nb_message=0;

//*Position des boutons en X (centré en largeur)
float bouton_xmin=(69.0/600.0);
float bouton_xmax=(530.0/600.0);

//*Boutons en Y (hauteur)
//*bouton démarrer
float play_ymin=706.0/1024.0;
float play_ymax=804.0/1024.0;
//*bouton effacer
float pause_ymin=844.0/1024.0;
float pause_ymax=945.0/1024.0;

boolean send_to_site=false; // variable d'envoi
String requestsms=""; // commande php post d'envoi au site et à la BDD


void setup() {

  size(displayWidth, displayHeight); // Determination de la zone d'affichage
  orientation(PORTRAIT); // orientation de l'appli fixée en PORTRAIT
  /*fixe les variables hauteur et largeur*/
  hauteur=displayHeight; 
  largeur=displayWidth;

  noStroke(); // pas de bordure


    // mise à l'echelle des elements graphiques en fonction de la taille de l'ecran
  bouton_xmin=bouton_xmin*largeur;
  bouton_xmax=bouton_xmax*largeur;
  //*Boutons en Y
  //*bouton lecture
  play_ymin=play_ymin*hauteur;
  play_ymax=play_ymax*hauteur;
  //*bouton pause
  pause_ymin=pause_ymin*hauteur;
  pause_ymax=pause_ymax*hauteur;

  gesture = new KetaiGesture(this); // création de l'objet gesture, gestion des mvts des doigts
  fond=loadImage("smswall.png"); // chargement de l'image de fond
  image(fond, 0, 0, largeur, hauteur); // affichage du fond

  button_font=loadFont("CurseCasualJVE-30.vlw"); //chargement de la police des boutons
  text_font=loadFont("DejaVuSans-12.vlw"); //chargement de la police des textes

  /*rectangles des boutons*/
  fill(176, 103, 17); // boutons en marron
  rect(bouton_xmin, play_ymin, bouton_xmax-bouton_xmin, play_ymax-play_ymin); // bouton demarrer
  rect(bouton_xmin, pause_ymin, bouton_xmax-bouton_xmin, pause_ymax-pause_ymin); // bouton effacer


  textFont(text_font, int(hauteur/40.0)); //création du texte des textes
  textAlign(CENTER, CENTER); // alignement des textes centré en hauteur et largeur
 
  /*affichage des textes*/
  fill(0); // texte en noir
  text("Entrez l'adresse du serveur", largeur/2.0, 4.5*hauteur/16.0);
  text("Entrez le titre du sondage", largeur/2.0, 7.5*hauteur/16.0);
  fill(255); // couleur des textes des boutons en blanc
  textFont(button_font, int(hauteur/16.6)); //création du texte des boutons
  text("Démarrer", largeur/2, (play_ymax-play_ymin)/2+play_ymin); // texte bouton demarrer
  text("Effacer le mur", largeur/2, (pause_ymax-pause_ymin)/2+pause_ymin);  // texte bouton effacer la base de donnée

  ////*zones de saisie*/////

  //*URL du serveur*//
  widgetContainer = new APWidgetContainer(this); //create new container for widgets
  url_input = new APEditText(int(largeur/2.0)-int(((4*largeur)/5.0)/2.0), int(5*hauteur/16), int((4*largeur)/5.0), int(hauteur/10.0)); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget( url_input); //place textField in container
  url_input.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  url_input.setImeOptions(EditorInfo.IME_ACTION_DONE);
  url_input.setCloseImeOnDone(true);

  //*titre du sondage *//
  titre_input = new APEditText(int(largeur/2.0)-int(((4*largeur)/5.0)/2.0), int(8*hauteur/16), int((4*largeur)/5.0), int(hauteur/10.0)); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(titre_input); //place textField in container
  titre_input.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  titre_input.setImeOptions(EditorInfo.IME_ACTION_DONE);
  titre_input.setCloseImeOnDone(true);
}

void draw() {

  /////*envoi du SMS au site*/////

  delay(1000);
  if (send_to_site) { // si la variable send_to_site est vraie, on envoie la commande Post
    try {
      //print(requestsms); //debug pour voir la commande à décommenter

      HttpPost          httpPost   = new HttpPost(requestsms);
      DefaultHttpClient httpClient = new DefaultHttpClient();
      HttpResponse response = httpClient.execute( httpPost ); // envoi de la commande au serveur
      send_to_site=false; // commande envoyée on remet la variable à faux
    }
    catch( Exception e ) {  //gestion des erreurs d'envoi
      e.printStackTrace();
    }
  }
}


////////////////////////*classe pour recevoir des SMS */////////////////////////

public class SmsReceiver extends BroadcastReceiver //Classe pour recevoir les SMS
{
  @Override
    public void onReceive(Context context, Intent intent)  // si on reçois un SMS
  {
    //---get the SMS message passed in---
    Bundle bundle = intent.getExtras();        
    SmsMessage[] msgs = null;
    String caller=""; // variable interne à la classe numéro de téléphone
    String str=""; // variable interne à la classe texte du SMS

    if (bundle != null)
    {
      //---réception des SMS---
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

    if (PLAY_PAUSE) { // si le bouton démarré est actif, on fixe les variables globales et on prépare la commande
      nb_message++;
      requestsms = url_serveur+"add_sms.php"+"?phrases=" + message +"&titre="+titre +"&tel="+number; // préparation de la commande post/php
      requestsms=requestsms.replaceAll(" ", "%20"); // on vire les espaces et on les remplace par %20, valeur des espaces pour post php
      requestsms=requestsms.replaceAll("'", "%27"); // on vire les apostrophes et on les remplace par %27, valeur des espaces pour post php

      send_to_site=true; // la commande est prete, on fixe la variable d'envoi à vrai
    }
  }
}



//////////////////////////////*fonctions demarrage / arret de l'application *//////////////////////////
@Override
public void onCreate(Bundle savedInstanceState) { //fonction lancée au démarrage de l'application
  super.onCreate(savedInstanceState);
  getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); // empeche la mise en veille
  IntentFilter filter = new IntentFilter("android.provider.Telephony.SMS_RECEIVED");   
  registerReceiver(mySMSReceiver, filter); // lancement de la classe pour recevoir des SMS
}

public void onDestroy(Bundle savedInstanceState) {  //fonction lancée à la fermeture de l'application
  super.onDestroy(); 
  getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON); // on remet la mise en veille active
}

