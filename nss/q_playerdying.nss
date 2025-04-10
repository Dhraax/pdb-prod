// Project Q OnPlayerDying hook script
//:://////////////////////////////////////////////
/*
    Bleeding and Dying

    - When HP drops below 0 PC begins to bleed, taking 1 damage
      pre round until death at -10 hp

    - 10% Chance to self-stabilize per round of bleeding

*/
//:://////////////////////////////////////////////
//:: Author : Scott Thorne
//:: E-mail : Thornex2@wans.net
//:: Updated: July 25, 2002
//:://////////////////////////////////////////////
//:: 01-24-2013, Pstemarie: added support for mounted players dying

#include "x3_inc_horse"
#include "NW_I0_GENERIC"

void doBleedEffect(int iBleedAmt)
{
    object oDying = GetLocalObject(OBJECT_SELF, "PCName");

    if (GetLocalInt(oDying, "IsDying") == 0)
        return;

    object oFoe = GetLastAttacker(oDying);
    effect eBleedEff = EffectDamage(iBleedAmt);

    // Keep executing recursively until character is dead or stabilizes
    if (GetCurrentHitPoints() <= 0)
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBleedEff, oDying);

        if (GetCurrentHitPoints() <= -10) // "He's dead, Jim..."
        {
            PlayVoiceChat(VOICE_CHAT_DEATH); /* scream one last time */
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), OBJECT_SELF);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oDying);
            AssignCommand(GetNearestObjectByTag("PC_Bloodstain", oDying), DestroyObject(OBJECT_SELF, 2.0));
            DeleteLocalInt(oDying, "IsDying");
            DeleteLocalInt(oDying, "PC_Bloodstain");
            return;
        }

        if(GetCurrentHitPoints()>0) // no longer unconscious or dying
        {
            AssignCommand(GetNearestObjectByTag("PC_bloodstain",oDying),DestroyObject(OBJECT_SELF,2.0));
            DeleteLocalInt(oDying, "PC_Bloodstain");
            DeleteLocalInt(oDying, "IsDying");
            // Determines combat round for nearest enemy when PC becomes conscious
            object oAttacker = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,PLAYER_CHAR_NOT_PC,oDying,1,
                CREATURE_TYPE_IS_ALIVE,TRUE,CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY);
            AssignCommand(oDying,DelayCommand(3.0,AssignCommand(oFoe,DetermineCombatRound(oDying, 10))));
            return;
        }

        if (d100() <= 10) // stabilized
        {
            FloatingTextStringOnCreature("You have stabilized but remain unconscious!", oDying, FALSE);
            DeleteLocalInt(oDying, "IsDying");
            return;
        }
        else // continue dying
        {
            FloatingTextStringOnCreature("Your wounds continue to bleed!", oDying, FALSE);
            switch (d3())
            {
                case 1: PlayVoiceChat(VOICE_CHAT_PAIN1); break;
                case 2: PlayVoiceChat(VOICE_CHAT_PAIN2); break;
                case 3: PlayVoiceChat(VOICE_CHAT_PAIN3); break;
            }

            DelayCommand(6.0, doBleedEffect(iBleedAmt)); // Do this again next round

            SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 50, oDying);
            DelayCommand(6.0,SetStandardFactionReputation(STANDARD_FACTION_HOSTILE, 0, oDying));

            // Keep the player from being attacked, stop nearby attackers
            if ( GetIsObjectValid(GetAttackTarget( oFoe)) == 1 && GetAttackTarget( oFoe) == oDying)
            {
                object oFriend = GetFactionLeastDamagedMember(oDying,TRUE);
                if ( oFriend != oDying )
                {
                    AssignCommand(oFoe,ActionAttack(oFriend));
                }
                else
                {
                    AssignCommand(oFoe,ClearAllActions(TRUE));
                    if (GetCurrentHitPoints(oFoe) != GetMaxHitPoints(oFoe) && GetPercentageHPLoss(oFoe) < 50)
                    {
                        AssignCommand(oFoe, ActionMoveAwayFromObject(oDying, FALSE, 5.0));
                        DelayCommand(20.0, AssignCommand(oFoe, ActionRandomWalk()));
                    }
                }
            }
        }
    }
}


int GetNumberPCs()
{
   int nPCs = 0;
   object oPC = GetFirstPC();
   while (GetIsObjectValid(oPC) == TRUE)
   {
      nPCs = nPCs+1; // nPCs++;
      oPC = GetNextPC();
   }

   return nPCs;
}



void main()
{
    object oDying = GetLastPlayerDying();

    // Support for mounted players dying.
    if (HorseGetIsMounted(oDying))
    {
        // Dismount
        object oHorse = HorseDismount(FALSE);
        // Have the horse react.
        if ( !GetIsDead(oHorse) )
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oHorse, 6.0);
    }

    if (GetNumberPCs() > 1) // More than one PC - do bleeding
    {
        SetLocalObject(oDying, "PCName", oDying);
        SetLocalInt(oDying, "IsDying", 1);
        AssignCommand(oDying, ClearAllActions());
        AssignCommand(oDying, doBleedEffect(1));

        if (GetLocalInt(oDying, "PC_Bloodstain") == 0)
        {
            CreateObject(OBJECT_TYPE_PLACEABLE, "plc_bloodstain", GetLocation(oDying), FALSE, "PC_Bloodstain");
            SetLocalInt(oDying, "PC_Bloodstain", 1);
        }
    }
    else // Only one PC - go directly from dying to death.
    {
        if (GetIsDead(oDying))
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oDying);
    }
}
