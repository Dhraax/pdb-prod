void main()
{


object oPC = GetEnteringObject();
object oMago = GetNearestObjectByTag("Mortimer", oPC);
object oEsqueleto = GetNearestObjectByTag("Huesospodridos", oPC);
string sNombrePersonaje = GetName(oPC);
int hora = GetTimeHour() ;

if(GetIsPC(oPC)&& GetLocalInt(oPC, "Mortimeryhuesos") == 0)
{
SetLocalInt(oPC, "Mortimeryhuesos", 1);
DelayCommand(400.0f, DeleteLocalInt(oPC, "Mortimeryhuesos"));
DelayCommand(1.0, AssignCommand(oMago, SetFacingPoint(GetPosition(oEsqueleto))));
DelayCommand(2.0, AssignCommand(oMago, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,2.0)));
DelayCommand(1.8, AssignCommand(oMago, SpeakString("¡Maldito esqueleto, no me sirves para nada! <c!}þ>*Chilla exaltado al esqueleto*</c>")));
DelayCommand(2.2, AssignCommand(oEsqueleto, SetFacingPoint(GetPosition(oMago))));
DelayCommand(3.5, AssignCommand(oEsqueleto, SpeakString("Lo siento amooo... Lo siento amooo...")));
DelayCommand(5.5, AssignCommand(oMago, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL,1.0,2.0)));
DelayCommand(5.6, AssignCommand(oMago, SpeakString("¡Qué lo sientes! ¡Al próximo error te envio de vuelta a tu tumba! ¡No te tendría que haber sacado nunca de ahí!")));
DelayCommand(8.5, AssignCommand(oMago, SetFacingPoint(GetPosition(oPC))));

    if ((hora < 7) || (hora > 17)){
    DelayCommand(9.0, AssignCommand(oMago, SpeakString("<c!}þ>*Se gira hacia "+sNombrePersonaje+" y esboza una sonrisa*</c> ¡Un cliente! Perdone no le había visto, tengo magia y objetos mágicos. Écheles un vistazo, que por mirar no le voy a cobrar, ¡je je je je!")));
    }

    else
    DelayCommand(9.0, AssignCommand(oMago, SpeakString("<c!}þ>*Se gira hacia "+sNombrePersonaje+" frunciendo el ceño*</c> ¡¿Y tú qué haces aquí?! ¡¿Te parecen adecuadas estas horas para hacer una visita?! ¡Largo y no olvides cerrar la puerta, que entra demasiada luz!")));

    }


}
