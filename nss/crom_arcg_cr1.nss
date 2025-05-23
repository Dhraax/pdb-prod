void main()
{
object oPC = GetPCSpeaker();
//Arco corto de Gesen
string sArco = "arcodemadera";
string sCuerda = "cuerdadearcocort";

object oArco = GetItemPossessedBy(oPC, sArco);
object oCuerda = GetItemPossessedBy(oPC, sCuerda);
object oCromwell = GetObjectByTag("cromwell");

if((GetGold(oPC) >= 50000) && (oArco != OBJECT_INVALID) && (oCuerda != OBJECT_INVALID))
     {
      if (GetIsObjectValid(oArco)) DestroyObject(oArco);
      if (GetIsObjectValid(oCuerda)) DestroyObject(oCuerda);

      SetCampaignInt("CROMWELL", "ARCOGESEN", 1, oPC);

      DelayCommand(0.1, AssignCommand(oCromwell, SpeakString("¡¡¡Listo, aquí tienes tu arco corto!!!")));

      AssignCommand(oPC, TakeGoldFromCreature(50000, oPC, TRUE));
      CreateItemOnObject("arcocortodegesen", oPC);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
    }
else
    {
     FloatingTextStringOnCreature("¡No tienes los materiales necesarios!", oPC);
    }
}
