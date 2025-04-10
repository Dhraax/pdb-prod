void main()
{
object oPC = GetPCSpeaker();

//Mangual de las Edades +3
string sAcido = "cabezadeacido";
string sHielo = "cabezadehielo";
string sFuego = "cabezadefuego";

object oAcido = GetItemPossessedBy(oPC, sAcido);
object oHielo = GetItemPossessedBy(oPC, sHielo);
object oFuego = GetItemPossessedBy(oPC, sFuego);
object oCromwell = GetObjectByTag("cromwell");

if((GetGold(oPC) >= 50000) && (oAcido != OBJECT_INVALID) &&
   (oHielo != OBJECT_INVALID) && (oFuego != OBJECT_INVALID))
     {
      if (GetIsObjectValid(oAcido)) DestroyObject(oAcido);
      if (GetIsObjectValid(oHielo)) DestroyObject(oHielo);
      if (GetIsObjectValid(oFuego)) DestroyObject(oFuego);

      SetCampaignInt("CROMWELL", "MANGUALEDADES", 1, oPC);

      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡¡¡Listo, aquí tienes tu mangual!!!")));

      AssignCommand(oPC, TakeGoldFromCreature(50000, oPC, TRUE));
      CreateItemOnObject("mangualdelasedad", oPC);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
    }
else
    {
     FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
    }
}
