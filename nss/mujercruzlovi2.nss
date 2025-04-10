void main()
{

object oPC = GetEnteringObject();
object oTarjet =GetObjectByTag("mujercruzlovi2");
int iRoca = GetLocalInt(oTarjet,"mujercruzlovi2");

if (!GetIsPC(oPC)) return;

DelayCommand(1.5, AssignCommand(oTarjet, SpeakString("*Se retuerce de dolor* Por favor!! Estan locos!! Ayudarme!!")));

 }
