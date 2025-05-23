//:://////////////////////////////////////////////////
//:: Asy_comprarvampi
/*
  Se coloca en el  OnEnter del desencadenante.

  Este script comprueba si el jugador que quiere entrar en
  es siervo de Shar y si ha colocado en el centro de pentagrama.


 */
//:://////////////////////////////////////////////////
//::
//:: Creado Por: Asyel
//:: Created On: 12/01/2009
//:://////////////////////////////////////////////////
void main()
{
    object oPC = GetEnteringObject();
    if (!GetIsPC(oPC)) return;
    object oEstatuaShar= GetObjectByTag("Asyel_Diosashar");
    string sDios= GetDeity(oPC);
    SetLocalInt(oEstatuaShar, "asy_digno", 0);
    SetLocalInt(oEstatuaShar, "asy_entpenta",1);
    if (sDios=="Shar")
    {
          SetLocalInt(oEstatuaShar, "asy_digno", 1);
    }

}
