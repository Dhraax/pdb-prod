#include "x2_inc_itemprop"
#include "opw_inc_weapons"
#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();
  object oFragua = GetNearestObjectByTag("forja_cielos");
  object oEsencia = GetItemPossessedBy(oPC, "esencianishruu");
  object oArma = GetFirstItemInInventory(oFragua);

  if(GetLocalInt(oArma, "FOJARDELOSCIELOS") == TRUE)
  {
      AssignCommand(OBJECT_SELF, ActionSpeakString("Hey hey, esta arma no puede encantarse más... ¡o los Picos de las Nubes explotarán!"));
      return;
  }

  if(IsMeleeWeapon(oArma) == TRUE && oEsencia != OBJECT_INVALID)
  {
      IPSafeAddItemProperty(oArma, ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY), 0.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING);

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1087), oFragua);
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1087), oFragua));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1087), oFragua));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1087), oFragua));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1087), oFragua));

      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1146), oFragua);
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1148), oFragua));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1150), oFragua));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1152), oFragua));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(1147), oFragua));

      DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(481), oFragua));
      DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC) - 1, DAMAGE_TYPE_FIRE), oFragua));

      DelayCommand(6.0, SpeakString("¡Genial genial! ¡Hubo una pequeñita explosión pero todo ha salido bien!"));
      DelayCommand(8.0, AssignCommand(oPC, ActionSpeakString("(Pequeña dice... maldito)")));

      GuardarIntPersistente(oPC, "FORJADELOSCIELOS", 1);
      SetLocalInt(oArma, "FOJARDELOSCIELOS", TRUE);

      SetName(oArma, "<cÍáþ>Furia celestial</c>");
      SetDescription(oArma, "Activa el arma para liberar su poder durante 12 minutos. Podrás liberar su poder una vez al día.");

      object oNuevaArma = CopyObject(oArma, GetLocation(oPC), oFragua, "furia_celestial");

      DestroyObject(oArma);
      DestroyObject(oEsencia);
  }

  else
  {
      SpeakString("Hey hey, prepárate mejor. O no has puesto un arma cuerpo a cuerpo en la fragua, o hay más cosas en la fragua de las que debería haber, o no tienes la esencia.");
  }
}
