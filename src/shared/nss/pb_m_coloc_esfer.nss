void main()
{
//::////////////////////////////////////////////////////////////////////////:://
/* SIGUIENDO LA COSTUMBRE.. XAVI, MODIFICA ESTAS COSILLAS :) */
//Modifica aqui la etiqueta de la esfera necesaria para activar el portal
string sEsfera = "EsferadeSinght";

//Modifica aqui la etiqueta del obelisco donde se coloca la esfera
string sObelisco = "obelisko";

//Modifica aqui el texto que dira el jugador al activar el teletransporte
string sTexto1 = "(Parece que he activado este antiguo mecanismo, debería" +
 " investigar su funcionamiento más a fondo para averiguar su función primaria.)";

//Modifica aqui el texto que dira el jugador al intentar colocar de nuevo una
//esfera cuando ya ha sido colocada anteriormente
string sTexto2 = "(Ya hay una esfera colocada, por lo visto este mecanismo aún"+
" puede extraer energía de ella)";

//Modifica aqui el texto si por alguna de akellas al ejecutarse este script, el
//jugador ya no tiene una esfera
string sTexto3 = "¡Pero si no tengo ninguna esfera!";

//Modifica aqui los segundos en los que el teletransporte estara activo despues
//de ser activado por la esfera
float fSegundos = 200.0;
//::////////////////////////////////////////////////////////////////////////:://

// Definimos los objetos
object oPC = GetPCSpeaker();
object oObelisco = GetObjectByTag(sObelisco);
object oEsfera = GetItemPossessedBy(oPC, sEsfera);
object oMod = GetModule();

// Definimos los efectos
effect eEfecto1 = EffectVisualEffect(VFX_IMP_KNOCK);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

if(oEsfera == OBJECT_INVALID)
  {
    DelayCommand(0.5, AssignCommand(oPC, ActionSpeakString(sTexto3)));
  }
else
  {
  if(GetLocalInt(oMod, "OBELISCOESFERA") == 0)
      {
        DestroyObject(oEsfera);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oObelisco);

        SetLocalInt(oMod, "OBELISCOESFERA", 1);
        DelayCommand(fSegundos, DeleteLocalInt(oMod, "OBELISCOESFERA"));

        DelayCommand(0.5, AssignCommand(oPC, ActionSpeakString(sTexto1)));
      }
  else
      {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oObelisco);
        DelayCommand(0.5, AssignCommand(oPC, ActionSpeakString(sTexto2)));
      }
  }
}
