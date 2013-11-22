/*  Fonction des boutons */
boolean PLAY_PAUSE=false; // variable démarrer/arreter

void mousePressed() // fonction active quand l'ecran est touché
{
  //println("appuyé");//debug pour confirmer que l'ecran est touché

  /*reception de l'URL*/
  if (url_input.getText()!="") { // si du texte est présent dans la zone texte url
    url_serveur=url_input.getText(); // reception de l' URL de la zone texte
    //println(url_serveur); //debug pour voir l'entrée dans la zone texte
  }

  /*reception du titre*/
  if (titre_input.getText()!="") { // si du texte est entré dans la zone titre
    titre=titre_input.getText(); // reception du titre de la zone titre
    titre=titre.replaceAll(" ", "%20"); // on vire les espaces et on les remplace par %20, valeur des espaces pour post php
    titre=titre.replaceAll("'", "%27"); // on vire les apostrophes et on les remplace par %27, valeur des espaces pour post php
  }

  /*teste su le bouton démarrer est appuyé*/  //
  if (mouseX>bouton_xmin &&
    mouseX<bouton_xmax &&
    mouseY>play_ymin   &&
    mouseY<play_ymax) {
    //println("bouton démarrer appuyé");//debug pour test du bouton
    
    if (!PLAY_PAUSE) { // bouton bascule si le bouton est en position "arreté", on démarre et inversement
      PLAY_PAUSE=true; // mise en route de la variable démarrer
      /*on efface le bouton démarrer et on affiche le bouton arreter*/
      fill(176, 103, 17); // marron
      rect(bouton_xmin, play_ymin, bouton_xmax-bouton_xmin, play_ymax-play_ymin); //rectangle du bouton
      fill(255); //blanc
     
      text("Arreter", largeur/2, (play_ymax-play_ymin)/2+play_ymin); //texte du bouton

      /*envoi du titre*/
      try {
        HttpPost          httpPost   = new HttpPost( url_serveur+"add_sms.php?titre=" +titre); 
        DefaultHttpClient httpClient = new DefaultHttpClient();
        HttpResponse response = httpClient.execute( httpPost ); // envoi de la commande pour fixer le titre
      }
      catch( Exception e ) {  // gestion des erreurs
        e.printStackTrace(); 
      }
    }
    else { //si le bouton est en mode démarré, on le bascule en mode arreté
      PLAY_PAUSE=false; // arret de l'envoi des requetes PHP
      //println("bouton arreté appuyé"); //debug pour test du bouton
      
      /*on efface le bouton arreter et on affiche le bouton demarrer*/
      fill(176, 103, 17); //marron
      rect(bouton_xmin, play_ymin, bouton_xmax-bouton_xmin, play_ymax-play_ymin); //rectangle du bouton
      fill(255); // blanc
   
      text("Démarrer", largeur/2, (play_ymax-play_ymin)/2+play_ymin); // texte du bouton
      
    }
  }
  
  ///*teste du bouton effacer*//
  if (mouseX>bouton_xmin &&
    mouseX<bouton_xmax &&
    mouseY>pause_ymin   &&
    mouseY<pause_ymax) {
    
    try {
      HttpPost          httpPost   = new HttpPost( url_serveur+"add_sms.php?efface=1" );
      DefaultHttpClient httpClient = new DefaultHttpClient();
      HttpResponse response = httpClient.execute( httpPost );  // envoi de la commande effacer la base de donnée
    }
    catch( Exception e ) { 
      e.printStackTrace(); // gestion des erreurs
    }
  }
}

/*fonctions de geste sur l'ecran non utilisées*/
void mouseDragged()
{
}

public void keyPressed() {
}
void onLongPress(float x, float y)
{
}

void drawUI()
{
}
void onPinch(float x, float y, float d)
{
}

/*fonction d'interrupion su l'ecran est touché*/
public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}

