void main()
{
object oPC = GetPCSpeaker();
//Asoladora +4
string sAsta = "astadelaasolador";
string sFilo = "filodelaasolador";

object oAsta = GetItemPossessedBy(oPC, sAsta);
object oFilo = GetItemPossessedBy(oPC, sFilo);
object oCromwell = GetObjectByTag("cromwell");

if((GetGold(oPC) >= 50000) && (oAsta != OBJECT_INVALID) && (oFilo != OBJECT_INVALID))
     {
      if (GetIsObjectValid(oAsta)) DestroyObject(oAsta);
      if (GetIsObjectValid(oFilo)) DestroyObject(oFilo);

      SetCampaignInt("CROMWELL", "ASOLADORA", 1, oPC);

      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡¡¡Listo, aquí tienes tu alabarda!!!")));

      AssignCommand(oPC, TakeGoldFromCreature(50000, oPC, TRUE));
      CreateItemOnObject("asoladora4", oPC);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
    }
else
    {
     FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
    }
}
