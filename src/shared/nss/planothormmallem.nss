void Teletransporte(object oPC, location lLugar)
{
DelayCommand(0.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
DelayCommand(1.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
DelayCommand(1.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GOOD_HELP), oPC));
DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC));
DelayCommand(2.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
DelayCommand(3.2, AssignCommand(oPC, ClearAllActions()));
DelayCommand(3.3, AssignCommand(oPC, ActionJumpToLocation(lLugar)));
}

void main()
{
object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

//Configura aqui la etiqueta del objeto necesario para usar el portal
string sEtiqueta = "LlavedelportalaThormallem";

//Configura aqui la etiqueta del punto de ruta donde te llevara
string sPuntoDeRuta = "entrada_dorwmago";

//Configura aqui la frase que saltara al jugador si no tiene el objeto
string sFrase = "¡No tienes permitido usar el portal!";


if(GetLocalInt(GetModule(), "THORMALLEMOCUPAO") == 0)
 {
  if (GetItemPossessedBy(oPC, sEtiqueta)!= OBJECT_INVALID)
   {
    Teletransporte(oPC, GetLocation(GetWaypointByTag(sPuntoDeRuta)));
    SetLocalInt(GetModule(), "THORMALLEMOCUPAO", 1);
    SetLocalInt(oPC, "ESTOYENTHORMALLEM", 1);
    DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_OPEN));
    DelayCommand(3.4, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
   }
  else
   {
    FloatingTextStringOnCreature(sFrase, oPC);
   }
 }
else
 {
  FloatingTextStringOnCreature("El plano ya está ocupado por otro drow, debes de esperar tu turno", oPC);
 }
}
