#include "mti_libreria"
void main()
{
  object oPC = GetPCSpeaker();
  object oPergamino = GetItemPossessedBy(oPC, "pergaminodelcrom");
  object oMartillo = GetItemPossessedBy(oPC, "martillo_tronante");
  object oTahali = GetItemPossessedBy(oPC, "tahali_escarcha");
  object oGuantes = GetItemPossessedBy(oPC, "NW_IT_MBRACER013");
  int iOro = GetGold(oPC);

  if(oPergamino != OBJECT_INVALID && oMartillo != OBJECT_INVALID &&
     oTahali != OBJECT_INVALID && oGuantes != OBJECT_INVALID && iOro >= 500000)
  {
      DestroyObject(oPergamino);
      DestroyObject(oMartillo);
      DestroyObject(oTahali);
      DestroyObject(oGuantes);
      AssignCommand(oPC, TakeGoldFromCreature(500000, oPC, TRUE));

      CreateItemOnObject("cromfaeyr", oPC);

      GuardarIntPersistente(oPC, "DESEO_AVENTURA", 3);

      DelayCommand(0.1, AssignCommand(OBJECT_SELF, SpeakString("¡Listo, aquí tienes el Crom Faeyr!")));

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_LIGHTNING_M), oPC);
      DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
  }

  else
  {
      FloatingTextStringOnCreature("¡No tienes todos los materiales necesarios!", oPC);
  }
}
