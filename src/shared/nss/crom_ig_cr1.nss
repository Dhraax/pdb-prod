void main()
{
object oPC = GetPCSpeaker();
//La Igualadora
string sFilo = "filodelaigualado";
string sJoya = "joyadelaigualado";
string sMango = "pomodelaigualado";

object oFilo = GetItemPossessedBy(oPC, sFilo);
object oJoya = GetItemPossessedBy(oPC, sJoya);
object oMango = GetItemPossessedBy(oPC, sMango);
object oCromwell = GetObjectByTag("cromwell");

if((GetGold(oPC) >= 50000) && (oFilo != OBJECT_INVALID) &&
   (oJoya != OBJECT_INVALID) && (oMango != OBJECT_INVALID))
     {
      if (GetIsObjectValid(oFilo)) DestroyObject(oFilo);
      if (GetIsObjectValid(oJoya)) DestroyObject(oJoya);
      if (GetIsObjectValid(oMango)) DestroyObject(oMango);

      SetCampaignInt("CROMWELL", "IGUALADORA", 1, oPC);

      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡¡¡Listo, aquí tienes tu espada!!!")));

      AssignCommand(oPC, TakeGoldFromCreature(50000, oPC, TRUE));
      CreateItemOnObject("laigualadora", oPC);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
    }
else
    {
     FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
    }
}
