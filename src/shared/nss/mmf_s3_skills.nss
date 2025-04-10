#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_spells"
#include "lib_race"
#include "colors_inc"
#include "vgz_libreria"
#include "cerr_newdispel"
//#include "nostack_inc"

void main()
{
/*
Spellcast Hook Code
Added 2003-06-20 by Georg
If you want to make changes to all spells,
check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    int iSpellid = GetSpellId();
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetHitDice(oCaster);
    int nDruidLevel = GetLevelByClass(CLASS_TYPE_DRUID);
    int nWizardLevel = GetLevelByClass(CLASS_TYPE_WIZARD);
    int nSorcererLevel = GetLevelByClass(CLASS_TYPE_SORCERER);
    int iAbility;

    if(nDruidLevel >= nWizardLevel && nDruidLevel >= nSorcererLevel) {iAbility = ABILITY_WISDOM;}
    else if(nWizardLevel >= nDruidLevel && nWizardLevel >= nSorcererLevel) {iAbility = ABILITY_INTELLIGENCE;}
    else if(nSorcererLevel >= nWizardLevel && nSorcererLevel >= nDruidLevel) {iAbility = ABILITY_CHARISMA;}

    int iCD = 10 + nCasterLvl/3 + GetAbilityModifier(iAbility,oCaster);

    if(iSpellid == 1528) //MMF Fireball
    {
        //Declare major variables
        int nDamage;
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
        effect eDam;
        //Get the spell target location as opposed to the spell target.
        location lTarget = GetSpellTargetLocation();
        //Limit Caster level for the purposes of damage
        if (nCasterLvl > 10)
        {
            nCasterLvl = 10;
        }
        //Apply the fireball explosion at the location captured above.
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {

            if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FIREBALL));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, iCD, SAVING_THROW_TYPE_FIRE);
                //Set the damage effect
                eDam = EffectDamage(nDamage,DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
    else if(iSpellid == 1529) //MMF Darkness
    {
        //if (gsSPGetOverrideSpell()) return;
        location lTarget = GetSpellTargetLocation();
        int nDuration = nCasterLvl;
        //Make sure duration does no equal 0
        if (nDuration < 1)
        {
            nDuration = 1;
        }
        //apply
        CreateNonStackingPersistentAoE(DURATION_TYPE_TEMPORARY, AOE_PER_DARKNESS, lTarget, RoundsToSeconds(nDuration));

        //trigger spell cast at event
        object oTarget = GetSpellTargetObject();
        if (GetIsObjectValid(oTarget))
        {
          object oCaster = OBJECT_SELF;
          SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DARKNESS, FALSE));
        }

    }
    else if(iSpellid == 1530) //MMF Invisibility
    {
        // No funciona montado en montura

        object oTarget = GetSpellTargetObject();

        if(ObtenerIntPersistente(oTarget, "CAB_MONTADO") > 0)
        {
            SendMessageToPC(OBJECT_SELF, "Los conjuros de invisivilidad no ocultan a criaturas montadas en montura.");
            return;
        }
        //Declare major variables
        //effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eInvis, eDur);
        //eLink = EffectLinkEffects(eLink, eVis);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INVISIBILITY, FALSE));
        int nDuration = nCasterLvl;

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    }
    else if(iSpellid == 1531) //MMF Charm Person
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
        effect eCharm = EffectCharmed();
        eCharm = GetScaledEffect(eCharm, oTarget);
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        //Link persistant effects
        effect eLink = EffectLinkEffects(eMind, eCharm);
        eLink = EffectLinkEffects(eLink, eDur);

        int nCasterLevel = nCasterLvl;

        int nDuration = 2 + nCasterLvl/3;
        nDuration = GetScaledDuration(nDuration, oTarget);

        // MONTI: x10 LA DURACION
        nDuration = nDuration * 10;

        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_PERSON, FALSE));
            //Make SR Check
            //Verify that the Racial Type is humanoid
            if (PB_Race_GetIsHumanoid(GetRacialType(oTarget)))
            {
                //Make a Will Save check
                if (!MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    //Apply impact and linked effects
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
         }
    }
    else if(iSpellid == 1532) //MMF Cone of Cold
    {
        //Declare major variables
        int nCasterLevel = nCasterLvl;
        int nDamage;
        float fDelay;
        location lTargetLocation = GetSpellTargetLocation();
        object oTarget;
        //Limit Caster level for the purposes of damage.
        if (nCasterLevel > 15)
        {
            nCasterLevel = 15;
        }
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while(GetIsObjectValid(oTarget))
        {
             if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
             // March 2003. Removed this as part of the reputation pass
             //            if((GetSpellId() == 340 && !GetIsFriend(oTarget)) || GetSpellId() == 25)
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONE_OF_COLD));
                    //Get the distance between the target and caster to delay the application of effects
                    fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20.0;
                    //Make SR check, and appropriate saving throw(s).
                    if(oTarget != OBJECT_SELF)
                    {
                        //Detemine damage
                        nDamage = d6(nCasterLevel)  ;
                        //Adjust damage according to Reflex Save, Evasion or Improved Evasion
                        nDamage = GetReflexAdjustedDamage(nDamage, oTarget, iCD, SAVING_THROW_TYPE_COLD);

                        // Apply effects to the currently selected target.
                        effect eCold = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                        effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);
                        if(nDamage > 0)
                        {
                            //Apply delayed effects
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCold, oTarget));
                        }
                    }
                }
            }
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);

        }
    }
    else if(iSpellid == 1533) //MMF Hurl Rock
    {
        //Do damage here...//354 for impact
        effect eImpact = EffectVisualEffect(354);
        effect eImpac1 = EffectVisualEffect(460);
        location lImpact = GetSpellTargetLocation();
        float fDelay;
        int nDamage;
        effect eDam;
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lImpact);
        DelayCommand(0.2f,ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpac1, lImpact));
        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_SMALL, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.

        int nDice = GetHitDice(OBJECT_SELF) / 5;
        if (nDice <1) nDice =1;

        int nDamageAdjustment = GetAbilityModifier (ABILITY_STRENGTH,OBJECT_SELF);
        while (GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lImpact, GetLocation(oTarget))/20;
                //Roll damage for each target, but doors are always killed

                 nDamage = d6(nDice) + nDamageAdjustment;

                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, iCD, SAVING_THROW_TYPE_NONE);
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_PLUS_ONE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
            //Select the next target within the spell shape.
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lImpact, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }
    else if(iSpellid == 1534) //MMF Charm Monster
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
        effect eCharm = EffectCharmed();
        eCharm = GetScaledEffect(eCharm, oTarget);
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        //Link effects
        effect eLink = EffectLinkEffects(eMind, eCharm);
        eLink = EffectLinkEffects(eLink, eDur);

        int nCasterLevel = nCasterLvl;
        int nDuration = 3 + nCasterLevel/2;
        nDuration = GetScaledDuration(nDuration, oTarget);
        int nRacial = GetRacialType(oTarget);

        // MONTI: x10 LA DURACION
        nDuration = nDuration * 10;

        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CHARM_MONSTER, FALSE));
            // Make SR Check

            // Make Will save vs Mind-Affecting
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply impact and linked effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }

        }

    }
    else if(iSpellid == 1535) //MMF Petrifying Gaze
    {
        location lTargetLocation = GetSpellTargetLocation();

        //Get first target in spell area
        object oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
        while(GetIsObjectValid(oTarget))
        {
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            int nSpellID = 497;
            DelayCommand(fDelay,  DoPetrification(nCasterLvl, oCaster, oTarget, nSpellID, iCD));

            //Get next target in spell area
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
        }
    }
    else if(iSpellid == 1536) //MMF Poison
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        object oItem = GetSpellCastItem();
        int nCD = 10+nCasterLvl/2+GetAbilityModifier(iAbility,oCaster);

        int nType = GetBaseItemType(oItem);
        if (!IPGetIsMeleeWeapon(oItem) &&
        !IPGetIsProjectile(oItem)   &&
        nType != BASE_ITEM_SHURIKEN &&
        nType != BASE_ITEM_DART &&
        nType != BASE_ITEM_THROWINGAXE)
        {
            int nVenom;
            if (nCD <= 15)                          nVenom = POISON_PHASE_SPIDER_VENOM;
            else if ((nCD > 15) && (nCD <= 18))     nVenom = POISON_DARK_REAVER_POWDER;
            else if ((nCD > 18) && (nCD <= 20))     nVenom = POISON_DEATHBLADE;
            else if ((nCD > 20) && (nCD < 26))      nVenom = POISON_PIT_FIEND_ICHOR;
            else if ((nCD >= 26) && (nCD <= 30))    nVenom = POISON_HUGE_SPIDER_VENOM;
            else if (nCD > 30)                      nVenom = POISON_COLOSSAL_SPIDER_VENOM;
            effect ePoison = EffectPoison(nVenom);

            //conjuro
            int nTouch = TouchAttackMelee(oTarget);
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POISON));
                //Make touch attack
                if (nTouch > 0)
                {

                    //Apply the poison effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);

                }
            }
        }
        else {
            int idVeneno = GetLocalInt(oItem, "idVeneno");
            if (idVeneno == 0) idVeneno = 1;
            effect ePoison = EffectPoison(idVeneno);
            //Apply the poison effect and VFX impact
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
        }
    }
    else if(iSpellid == 1537) //MMF Dominate Person
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        effect eDom = EffectDominated();
        eDom = GetScaledEffect(eDom, oTarget);
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        //Link duration effects
        effect eLink = EffectLinkEffects(eMind, eDom);
        eLink = EffectLinkEffects(eLink, eDur);

        effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
        int nDuration = 2 + nCasterLvl/3;
        nDuration = GetScaledDuration(nDuration, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
        //Make sure the target is a humanoid
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            if(PB_Race_GetIsHumanoid(GetRacialType(oTarget)))
            {
                //Make Will Save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, iCD, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
                {
                    // MONTI: x10 LA DURACION
                    nDuration = nDuration * 10;

                    //Apply linked effects and VFX impact
                    DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
    else if(iSpellid == 1538) //MMF Improved Invisibility
    {
        object oTarget = GetSpellTargetObject();
        // No funciona montado en montura
        if(ObtenerIntPersistente(oTarget, "CAB_MONTADO") > 0)
        {
            SendMessageToPC(OBJECT_SELF, ColorToken(254,60,60) + "Los conjuros de invisivilidad no ocultan a criaturas montadas en montura.</c>");
            return;
        }

        //Declare major variables
        effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);
        effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
        effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eCover = EffectConcealment(50);
        effect eLink = EffectLinkEffects(eDur, eCover);
        eLink = EffectLinkEffects(eLink, eVis);


        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPROVED_INVISIBILITY, FALSE));
        int nDuration = nCasterLvl;
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, TurnsToSeconds(nDuration));
    }
    else if(iSpellid == 1539) //MMF Trepar cual Arácnido
    {
        int iBono = 10;
        int nDuration = nCasterLvl * 10;

        //Declare major variables
        object oTarget = GetSpellTargetObject();
        effect eVis1 = EffectVisualEffect(1750);
        effect eVis2 = EffectVisualEffect(1751);
        effect eLink1 = EffectLinkEffects(eVis1, eVis2);

        //Fire spell cast at event for target
        SignalEvent(oTarget, EventSpellCastAt(oTarget, GetSpellId(), FALSE));
        //Apply VFX impact and bonus effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink1, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget, TurnsToSeconds(nDuration));
        DoNoStackSkillBonus(OBJECT_SELF, oTarget, iBono, 37, TurnsToSeconds(nDuration),GetSpellId());
    }
    else if(iSpellid == 1540)// MMF Mage armor
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nDuration = nCasterLvl;
        effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
        effect eAC1, eAC2, eAC3, eAC4;
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGE_ARMOR, FALSE));
        //Set the four unique armor bonuses
        eAC1 = EffectACIncrease(1, AC_ARMOUR_ENCHANTMENT_BONUS);
        eAC2 = EffectACIncrease(1, AC_DEFLECTION_BONUS);
        eAC3 = EffectACIncrease(1, AC_DODGE_BONUS);
        eAC4 = EffectACIncrease(1, AC_NATURAL_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        effect eLink = EffectLinkEffects(eAC1, eAC2);
        eLink = EffectLinkEffects(eLink, eAC3);
        eLink = EffectLinkEffects(eLink, eAC4);
        eLink = EffectLinkEffects(eLink, eDur);

        RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);
        RemoveEffectsFromSpell(oTarget, 347);
        RemoveEffectsFromSpell(oTarget, 1540);

        //Apply the armor bonuses and the VFX impact
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    else if(iSpellid == 1541) //MMF Elemental Shield
    {
        //Declare major variables
        effect eVis = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
        int nDuration = nCasterLvl;
        object oTarget = OBJECT_SELF;
        effect eShield = EffectDamageShield(nDuration, DAMAGE_BONUS_1d6, ChangedElementalDamage(oTarget, DAMAGE_TYPE_FIRE));
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eCold = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50);
        effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 50);

        //Link effects
        effect eLink = EffectLinkEffects(eShield, eCold);
        eLink = EffectLinkEffects(eLink, eFire);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eVis);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ELEMENTAL_SHIELD, FALSE));
        RemoveSpellEffects(GetSpellId(), OBJECT_SELF, oTarget);
        RemoveSpellEffects(47, OBJECT_SELF, oTarget);
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }
    else if(iSpellid == 1542)// MMF Acid Sheath
    {
        //Declare major variables
        effect eVis = EffectVisualEffect(448);
        int nDuration = nCasterLvl;
        int nDamage = nDuration * 2;
        effect eShield = EffectDamageShield(nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_ACID);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

        //Link effects
        effect eLink = EffectLinkEffects(eShield, eDur);
        eLink = EffectLinkEffects(eLink, eVis);

        //Fire cast spell at event for the specified target
        SignalEvent(oCaster, EventSpellCastAt(OBJECT_SELF, 524, FALSE));

        // 2003-07-07: Stacking Spell Pass, Georg
        RemoveEffectsFromSpell(oCaster, GetSpellId());
        RemoveEffectsFromSpell(oCaster, 524);

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(nDuration));
    }
    else if(iSpellid == 1543) //MMF Drown
    {
        //Declare major variables
        object oTarget = GetSpellTargetObject();
        int nCasterLevel = nCasterLvl;
        int nDam = GetCurrentHitPoints(oTarget);
        //Set visual effect
        effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
        effect eDam;
        //Check faction of target
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 437));
            // * certain racial types are immune
            if ((GetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
                &&(!PB_Race_GetIsUndead(oTarget))
                &&(GetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
            {
                //Make a fortitude save
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, iCD))
                {
                    //nDam = FloatToInt(nDam * 0.9);   //anulamos
                    eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                    //Apply the VFX impact and damage effect
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                }
            }
        }
    }
    else if(iSpellid == 1544) // MMF Web
    {
        //Declare major variables including Area of Effect Object
        effect eAOE = EffectAreaOfEffect(AOE_PER_WEB);

        location lTarget = GetSpellTargetLocation();
        int nDuration = nCasterLvl / 2;
        //Make sure duration does no equal 0
        if (nDuration < 1)
        {
            nDuration = 1;
        }
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    }
    else if(iSpellid == 1545) // MMF Bebelith Web
    {
        //Declare major variables including Area of Effect Object
        effect eAOE = EffectAreaOfEffect(AOE_PER_WEB, "x2_s1_bebweba", "x2_s1_bebwebc", "x2_s1_bebwebb");

        location lTarget = GetSpellTargetLocation();
        int nDuration = nCasterLvl / 2;
        if (nDuration < 1)
        {
            nDuration = 1;
        }
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    }
    else if(iSpellid == 1546) // MMF Dispel
    {
        effect    eVis         = EffectVisualEffect(VFX_IMP_BREACH);
        effect    eImpact      = EffectVisualEffect(VFX_FNF_DISPEL);
        object    oTarget      = GetSpellTargetObject();
        location  lLocal       = GetSpellTargetLocation();
        int       nCasterLevel = nCasterLvl;

        //--------------------------------------------------------------------------
        // Dispel Magic is capped at caster level 10
        //--------------------------------------------------------------------------
        if(nCasterLevel > 10)
        {
                nCasterLevel = 10;
        }

        //Espada Planar
        object oMaster;
        string Espada = GetResRef(oTarget);
        string Espada2 = GetTag(oTarget);

        if(Espada == "espadaplanar" || Espada2 == "espadaplanar")
        {
            oMaster = GetMaster(oTarget);
            int nCasterLevel2 = GetTotalCasterLevel(oMaster);
            int nTirada = d20() + nCasterLevel;
            int nCD = 11 + nCasterLevel2;

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            if(nTirada > nCD)
            {
                DestroyObject(oTarget, 0.5);
            }
       }
       else if (GetIsObjectValid(oTarget))
        {
            //----------------------------------------------------------------------
            // Targeted Dispel - Dispel all
            //----------------------------------------------------------------------
             pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact);
        }
        else
        {
            //----------------------------------------------------------------------
            // Area of Effect - Only dispel best effect
            //----------------------------------------------------------------------

            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
            oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE );
            while (GetIsObjectValid(oTarget))
            {
                if ((GetHasFeat(FEAT_MASTERY_SHAPES, OBJECT_SELF)) && (GetLocalInt(OBJECT_SELF, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, OBJECT_SELF) || oTarget == OBJECT_SELF || GetMaster(oTarget) == OBJECT_SELF))
                {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oTarget);
                }
                else if(GetObjectType(oTarget) == OBJECT_TYPE_AREA_OF_EFFECT)
                {
                    //--------------------------------------------------------------
                    // Handle Area of Effects
                    //--------------------------------------------------------------
                    pbDispelAoE(oTarget, OBJECT_SELF, nCasterLevel);
                }
                else if (GetObjectType(oTarget) == OBJECT_TYPE_PLACEABLE)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
                }
                else
                {
                    pbDispelMagic(oTarget, nCasterLevel, eVis, eImpact, FALSE);
                }

                oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE,lLocal, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_AREA_OF_EFFECT | OBJECT_TYPE_PLACEABLE);

            }
        }
    }
    else if(iSpellid == 1547) //MMF Mind Fog
    {
        //Declare major variables including Area of Effect Object
        effect eAOE = EffectAreaOfEffect(AOE_PER_FOGMIND, "nw_s0_mindfoga", "", "nw_s0_mindfogb");
        location lTarget = GetSpellTargetLocation();
        int nDuration = 2 + nCasterLvl / 2;
        effect eImpact = EffectVisualEffect(262);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    }
    else if(iSpellid == 1548) // MMF Entangle
    {
        //Declare major variables including Area of Effect Object
        effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
        location lTarget = GetSpellTargetLocation();
        int nDuration = 3 + nCasterLvl / 2;
        //Make sure duration does no equal 0
        if (nDuration < 1)
        {
            nDuration = 1;
        }
        //Create an instance of the AOE Object using the Apply Effect function
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));
    }

    else if (iSpellid >= 1549 && iSpellid <= 1552) //Dragons breaths, select the element by iSpellid
    {
        //Determine the HD of the monster
        int nAge = nCasterLvl;
        int nDamage,nDamageType,nDamageTypeTS,iEventSpell;
        effect eVis;
        //Use the HD of the creature to determine damage and save DC
        if (nAge <= 6)  nDamage = d8(2);//Wyrmling
        else if (nAge >= 7 && nAge <= 9)   nDamage = d8(4);//Very Young
        else if (nAge >= 10 && nAge <= 12) nDamage = d8(6);//Young
        else if (nAge >= 13 && nAge <= 15) nDamage = d8(8);//Juvenile
        else if (nAge >= 16 && nAge <= 18) nDamage = d8(10);//Young Adult
        else if (nAge >= 19)               nDamage = d8(12);//Adult

        if(iSpellid == 1549)
        {
            nDamageType = DAMAGE_TYPE_ACID;
            nDamageTypeTS = SAVING_THROW_TYPE_ACID;
            eVis = EffectVisualEffect(VFX_IMP_ACID_S);
            iEventSpell = SPELLABILITY_CONE_LIGHTNING;
        }
        else if(iSpellid == 1550)
        {
            nDamageType = DAMAGE_TYPE_COLD;
            nDamageTypeTS = SAVING_THROW_TYPE_COLD;
            eVis = EffectVisualEffect(VFX_IMP_FROST_S);
            iEventSpell = SPELLABILITY_CONE_LIGHTNING;
        }
        else if(iSpellid == 1551)
        {
            nDamageType = DAMAGE_TYPE_FIRE;
            nDamageTypeTS = SAVING_THROW_TYPE_FIRE;
            eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
            iEventSpell = SPELLABILITY_CONE_LIGHTNING;
        }
        else if(iSpellid == 1552)
        {
            nDamageType = DAMAGE_TYPE_ELECTRICAL;
            nDamageTypeTS = SAVING_THROW_TYPE_ELECTRICITY;
            eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
            iEventSpell = SPELLABILITY_CONE_LIGHTNING;
        }

        PlayDragonBattleCry();
        //Declare major variables
        //effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF,BODY_NODE_HAND);
        effect eDamage;
        object oTarget;
        int nDamStrike = nDamage;
        float fDelay;

        //Get first target in spell area
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation());
        while (GetIsObjectValid(oTarget))
        {
            if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, iEventSpell));
                //Determine effect delay
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD, nDamageTypeTS, OBJECT_SELF, fDelay))
                {
                    nDamStrike = nDamStrike/2;
                    if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                    {
                        nDamStrike = 0;
                    }
                }
                else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nDamStrike = nDamStrike/2;
                }
                if(nDamStrike > 0)
                {
                    //Set the damage effect
                    eDamage = EffectDamage(nDamStrike, nDamageType);
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
            }
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation());
        }
    }
    else if(iSpellid == 1553)// MMF Mind Barrier
    {
        //Declare major variables


        int nDuration = nCasterLvl;
        int nDamagePower = IPGetDamagePowerConstantFromNumber(nDuration);
        int nReduction = nDuration /2;

        if(nReduction <10)
        {
           nReduction = 10;
        }


        object oTarget = OBJECT_SELF;
        effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
        effect eDam = EffectDamageReduction(nReduction, nDamagePower , nDuration*10);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eDam, eVis);
        eLink = EffectLinkEffects(eLink, eDur);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 741, FALSE));
        effect eImpact = EffectVisualEffect(VFX_IMP_AC_BONUS);

        //Apply the VFX impact and effects
        if (!GetHasSpellEffect(GetSpellId(),OBJECT_SELF))
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        }
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
    }
    else if(iSpellid == 1554) //MMF Mindblast
    {
        int nStunTime;
        float fDelay;

        location lTargetLocation = GetSpellTargetLocation();
        object oTarget;
        effect eCone;
        effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
        float fRange = 15.0;

        oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTargetLocation, TRUE);

        while(GetIsObjectValid(oTarget))
        {
            int nApp = GetAppearanceType(oTarget);
            int bImmune = FALSE;
            //----------------------------------------------------------------------
            // Hack to make mind flayers immune to their psionic attacks...
            //----------------------------------------------------------------------
            if (nApp == 413 ||nApp== 414 || nApp == 415 || ObtenerIntPersistente(oTarget,"POLYMORPH_FORM"))
            {
                bImmune = TRUE;
            }

            if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE,OBJECT_SELF) && oTarget != OBJECT_SELF && !bImmune )
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 789));
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                // already stunned
                if (GetHasSpellEffect(GetSpellId(),oTarget))
                {
                     // only affects the targeted object
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_STUN), oTarget);

                    int nDamage = d6(nCasterLvl/2);

                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage,16), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND), oTarget);
                }
                else if (WillSave(oTarget, iCD) < 1)
                {
                    //Calculate the length of the stun
                    nStunTime = d4(1);
                    //Set stunned effect
                    eCone = EffectStunned();
                    //Apply the VFX impact and effects
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCone, oTarget, RoundsToSeconds(nStunTime)));
                }
            }
            //Get next target in spell area
            oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, fRange, lTargetLocation, TRUE);
        }
    }
}
