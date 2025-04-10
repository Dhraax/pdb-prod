void main()
{

object oPC = GetEnteringObject();
object oTarjet =GetObjectByTag("mujercruzlovi");
int iIndex;

iIndex=Random(4);
switch(iIndex){

case 1: //Comentario Aleatorio 1

        DelayCommand(2.0, AssignCommand(oTarjet, SpeakString("¡AAAAHH! ¡Auxilio!")));
        break;
case 2: //Comentario Aleatorio 2

        DelayCommand(2.0, AssignCommand(oTarjet, ActionSpeakString("¡SOCORRO! ¡Me duele! ¡AYUDAME! ")));
        break;
case 3: //Comentario Aleatorio 3

        DelayCommand(2.0, AssignCommand(oTarjet, SpeakString("¡Esta loca! ¡Nos estan torturando! ")));
        break;
case 4: //Comentario Aleatorio 4

        DelayCommand(2.0, AssignCommand(oTarjet, ActionSpeakString("¡No siento las piernas! ¡Salvame por favor! ")));
        break;

 }

}
