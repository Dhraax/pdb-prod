void main()
{
object oPC = GetPCSpeaker();
//Anillo de resistencia mental ilicido
string sAro = "arodeanilloilcid";
string sGema = "gemadeanilloilci";
string sDiente = "dientedeazotam";

object oAro = GetItemPossessedBy(oPC, sAro);
object oGema = GetItemPossessedBy(oPC, sGema);
object oDiente = GetItemPossessedBy(oPC, sDiente);
object oCromwell = GetObjectByTag("cromwell");

if((GetGold(oPC) >= 50000) && (oAro != OBJECT_INVALID) &&
   (oGema != OBJECT_INVALID) && (oDiente != OBJECT_INVALID))
     {
      if (GetIsObjectValid(oAro)) DestroyObject(oAro);
      if (GetIsObjectValid(oGema)) DestroyObject(oGema);
      if (GetIsObjectValid(oDiente)) DestroyObject(oDiente);

      SetCampaignInt("CROMWELL", "ANILLOILICIDO", 1, oPC);

      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡¡¡Listo, aquí tienes tu anillo!!!")));


      AssignCommand(oPC, TakeGoldFromCreature(50000, oPC, TRUE));
      CreateItemOnObject("anilloderesisten", oPC);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
    }
else
    {
     FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
    }
}
