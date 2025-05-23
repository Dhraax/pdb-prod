#include "nw_i0_spells"

void ReprovoDeathEffect(object oReprovo)
{
  if(GetLocalInt(oReprovo, "ReprovoDeath") ==  0)
   {
    effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    effect eVis2 = EffectVisualEffect(1243);
    effect eLink = EffectLinkEffects(eVis, eVis2);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oReprovo);
    effect eDeath = EffectDeath(TRUE);
    SetImmortal(oReprovo, FALSE);
    SetLocalInt(oReprovo, "ReprovoDeath", 1);
    DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oReprovo));
    DestroyObject(oReprovo);
    return;
    }
}

void main()
{

int nUser = GetUserDefinedEventNumber();
int nCaido = GetLocalInt(OBJECT_SELF, "ReprovoCaido");

if(nUser == EVENT_HEARTBEAT) // OnHeartbeat Event
    {

        int nOriginalHPs = GetMaxHitPoints(OBJECT_SELF);
        int nCurrentHPs = GetCurrentHitPoints(OBJECT_SELF);
        int n20Hp = (nOriginalHPs*20/100);  //20% de la vida total

        //Efecto de caida
        effect eKnockdown = EffectKnockdown();
        effect eParalize = EffectCutsceneParalyze();

        //Si tenemos menos del 20% caemos
        if (nCurrentHPs <= n20Hp && nCaido == 0)
        {
            ClearAllActions();
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eKnockdown, OBJECT_SELF);
            DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParalize, OBJECT_SELF));
            SetLocalInt(OBJECT_SELF, "ReprovoCaido", 1);
        }
        //Si hemos recuperado mas del 20% de vida, nos levantamos
        else if (nCurrentHPs > n20Hp)
        {
            RemoveSpecificEffect(GetEffectType(eKnockdown),OBJECT_SELF);
            RemoveSpecificEffect(GetEffectType(eParalize),OBJECT_SELF);
            SetLocalInt(OBJECT_SELF, "ReprovoCaido", 0);
        }

    }

else if(nUser == EVENT_DAMAGED) // OnDamaged Event
    {
        object oDamager = GetLastDamager();

        int nMagicalDamage = GetDamageDealtByType(DAMAGE_TYPE_MAGICAL);
        int nCurrentHPs = GetCurrentHitPoints(OBJECT_SELF);

     //Si ha caido y recibe daño magico...
     if(nCaido == 1 && nMagicalDamage > 0)
        {
          ReprovoDeathEffect(OBJECT_SELF);
        }
     //Si esta caido y no es daño magico...
     else if(nCaido == 1)
        {
         FloatingTextStringOnCreature("Parece resistirse a tus ataques...", oDamager, FALSE);
        }
     }

else if(nUser == EVENT_SPELL_CAST_AT) // OnSpellCastAt Event
    {
        object oCaster = GetLastSpellCaster();
        int nSpellID = GetLastSpell();
        int nMagicalDamage = GetDamageDealtByType(DAMAGE_TYPE_MAGICAL);

        //Si es remover maldición...
        if(nCaido == 1 && nSpellID == SPELL_REMOVE_CURSE)
          {
            ReprovoDeathEffect(OBJECT_SELF);
          }

        // Si no es remover maldición...
        else if(nCaido == 1 && nMagicalDamage == 0)
        {
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_GLOBE_USE), OBJECT_SELF);
        }
    }
}
