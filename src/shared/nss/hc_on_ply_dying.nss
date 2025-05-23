//::////////////////////////////////////////////////////////////////////////////
//:: Nombre del guion:  hc_on_ply_dying                                   //:://
//::////////////////////////////////////////////////////////////////////////////
//:: GUION ORIGINAL HCR 3.3b                                              //:://
//:: Modificado para el servidor Puerta de Baldur                         //:://
//::////////////////////////////////////////////////////////////////////////////
#include "HC_Inc"
#include "x0_i0_petrify"
#include "dote_atenuado2"

void main()
{
  object oPlayer = GetLastPlayerDying();
  effect eDeath = EffectDeath(FALSE, FALSE);
  int nCHP   = GetCurrentHitPoints(oPlayer);
  int pc_Damage = (GetCurrentHitPoints(oPlayer) * -1) + 1;
  int prev_Damage = GetLocalInt(oPlayer, "PC_Damage");
  // Prevent Bleed while currently possessing a Familiar or Companion. They
  // should be killed and treated as they just died.
  object oMaster = GetMaster(oPlayer);
  if (GetIsObjectValid(oMaster))
  {
      int nDam = d6();
      int nCHP = GetCurrentHitPoints(oMaster);
      if (nDam >= nCHP)
      nDam = (nCHP - 1);
      effect eDam = EffectDamage(nDam);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDam, oMaster);

      SendMessageToPC(oMaster, "Tu familiar ha muerto.");
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPlayer);
      return;
  }

  // DAÑO ATENUADO
  if(CheckSubdual(oPlayer)) return;

  // Corregir bug de polimorfacion
  effect eEff = GetFirstEffect(oPlayer);
  while(GetIsEffectValid(eEff))
  {
      if (GetEffectType(eEff) == EFFECT_TYPE_POLYMORPH)
      {
          RemoveEffect(oPlayer, eEff);
          ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oPlayer);
          SendMessageToPC(oPlayer, "<cþ<<>Cuando estás polimorfado no hay desangramiento. Has muerto.</c>");
      }
      eEff = GetNextEffect(oPlayer);
  }

  // Duro de Pelar, Berseker Frenetico
   if(GetHasFeat(1456, oPlayer) && (nCHP <= 1 && nCHP > -10))
    {
            // Guardamos el daño
            pc_Damage = pc_Damage + prev_Damage;
            SetLocalInt(oPlayer, "PC_Damage", pc_Damage);

        if(pc_Damage < 10)
            {
                 ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(), oPlayer);
                 string sFeedback = GetName(oPlayer, TRUE) + " : HP = " + IntToString(pc_Damage * -1);
                 SendMessageToPC(oPlayer, sFeedback);
            }
           else
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oPlayer);

   }

  // Only execute Bleed code if that system is on and the player is actually
  // dying. Just kill the player if they bypassed dying and went straight to
  // dead. The Death code will handle corpse and drop bag creation as well as
  // inventory transfer.
  //int nCHP   = GetCurrentHitPoints(oPlayer);
  if(nCHP < 1 && nCHP > -10)
  {
      string sID = GetPlayerID(oPlayer);
      location lPlayer = GetLocation(oPlayer);

      SPS(oPlayer, PWS_PLAYER_STATE_DYING);
      SetPersistentInt(oMod, "LastHP" + sID, nCHP);
      DelayCommand(6.0, ExecuteScript("hc_bleeding", oPlayer));
      SetPersistentLocation(oMod, "DIED_HERE" + sID, lPlayer);
  }
}

