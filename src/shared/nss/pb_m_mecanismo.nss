void main()
{
//::////////////////////////////////////////////////////////////////////////:://
/* SIGUIENDO LA COSTUMBRE.. XAVI, MODIFICA ESTAS COSILLAS :) */
//La etiqueta del punto de ruta donde se teletransportara el jugador
string sPuntoderuta = "entrada_cueva_drow";

//Modifica aqui el texto que dira el jugador cuando intente teletransportarse
//pero el obelisco no dispone de energia o ésta ya se ha acabado
string sTexto = "¿Uh? Mmmm... ¡¡Este trasto no funciona!! (Seguramente no" +
" tenga energía suficiente.)";
//::////////////////////////////////////////////////////////////////////////:://

// Definimos los objetos
object oPC = GetPCSpeaker();
object oMod = GetModule();

// Definimos el lugar del punto de ruta
location lPuntoderuta = GetLocation(GetWaypointByTag(sPuntoderuta));

// Definimos los efectos
effect eEfecto1 = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
effect eEfecto2 = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
effect eEfecto3 = EffectVisualEffect(VFX_IMP_GOOD_HELP);
effect eEfecto4 = EffectVisualEffect(VFX_IMP_BREACH);

if(GetLocalInt(oMod, "OBELISCOESFERA") == 1)
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC);
      DelayCommand(0.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC));
      DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC));
      DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC));
      DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto3, oPC));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto1, oPC));
      DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto4, oPC));
      DelayCommand(3.2, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(3.3, AssignCommand(oPC, ActionJumpToLocation(lPuntoderuta)));
    }
else
    {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC);
      DelayCommand(0.5, AssignCommand(oPC, ActionSpeakString(sTexto)));
    }
}
