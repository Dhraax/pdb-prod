void main()
{
object oPC = GetPCSpeaker();
//Lacerahielos +3
string sEscama = "fhgtrhtrs";
string sFilo = "filodehachadelos";

object oEscama = GetItemPossessedBy(oPC, sEscama);
object oFilo = GetItemPossessedBy(oPC, sFilo);
object oCromwell = GetObjectByTag("cromwell");

if((GetGold(oPC) >= 50000) && (oEscama != OBJECT_INVALID) && (oFilo != OBJECT_INVALID))
     {
      if (GetIsObjectValid(oEscama)) DestroyObject(oEscama);
      if (GetIsObjectValid(oFilo)) DestroyObject(oFilo);

      SetCampaignInt("CROMWELL", "LACERAHIELOS", 1, oPC);

      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡¡¡Listo, aquí tienes tu hacha!!!")));

      AssignCommand(oPC, TakeGoldFromCreature(50000, oPC, TRUE));
      CreateItemOnObject("hachadeloshielos", oPC);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
    }
else
    {
     FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
    }
}
