//::///////////////////////////////////////////////
//:: Project Q Spellhook
//:: q_spellhook.nss
//:://////////////////////////////////////////////
/*
    Culled from NwnE

    -------------------------
    Spell-Cast Item Overrides
    -------------------------

    Cursed Rods, Staves, Wands - 15% spell fails
                                 65% spell misfires with random effect
                                 20% spell fires normally
    Set the cursed flag (droppable) on the item in the toolset or set IS_CURSED variable to 1.
    If you use the variable the item will be renamed Cursed + name when first activated. 

    ---------------------------------------------
    Spell Overrides and Material Component System
    ---------------------------------------------

    Checks spell cast for material component and if the caster has a Spell
    Component Bag and/or Divine Focus in his inventory.

    Several spells also require other components:

    Animate Dead - Black Onyx (50gp)

    Blackstaff - Quarterstaff or Magic Staff which is not consumed by the spell

    Circle of Death - Black Pearl Dust (500gp)

    Continual Flame - Ruby Dust (50gp)

    Destruction - Anathemic Holy/Unholy Symbol (500gp)

    Firebrand - Alchemist's Fire (20gp)

    Gate - 1,000 XP

    Glyph of Warding - Pink Diamond Dust (200gp)

    Greater Restoration - 500 XP

    Greater Stoneskin - Blue Diamond Dust (250gp)

    Identify - Pearl Dust (100gp)

    Legend Lore - Incense (250gp) AND Ivory (150gp - not conusumed by the spell)

    Mordenkainen's Sword - Platinum Sword Figurine (250gp - not consumed by the
                           spell)

    Mummy Dust - Mummy Dust (10,000gp) AND 2,000 XP

    Planar Ally - 250 XP

    Protection from Spells - White Diamond (1000gp)

    Raise Dead - Diamond (5,000gp)

    Ressurection - Flawless Pink Diamond (10,000gp)

    Restoration - Diamond Dust (100gp)

    Shapechange - Jade Circlet (1500gp)

    Shelgarn's Persistant Blade - Silvered Dagger (24gp - not consumed by the spell)

    Stoneskin - Blue Diamond Dust (250gp)

    Tenser's Transformation - Potion of Bull's Strength (120gp)

    Undeath to Death - Red Diamond Dust (500gp)

    ---------------
    Spell Overrides
    ---------------
    Several spells have been completely rewritten or modified to better emulate
    their pnp counterparts:

    Bane - dispel Bless OR apply normal effects

    Bless - dispel Bane OR apply normal effects, cannot target bolts

    Identify - sets the identify flag on targeted item to TRUE

    Legend Lore - sets the identify flag on ALL items in targeted creature's
                  inventory to TRUE

    Remove Curse - when cast on cursed item allows unquipping the item. Use CURSE_DC > 0 to
               to require a will save.

*/
//:://////////////////////////////////////////////
//:: Created By: Pstemarie
//:: Created On:
//:://////////////////////////////////////////////
#include "q_inc_switches"
#include "q_inc_spells"

void main()
{
    //--------------------------------------------------------------------------
    //Declare major variables

    object oCaster = OBJECT_SELF;
    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    object oComponent;
    int nSpell = GetSpellId();
    int bValid;
    string sSpell;

//------------------------------------------------------------------------------
// CURSED ITEMS - Rods, staves, and wands
//------------------------------------------------------------------------------

    if (GetModuleSwitchValue(MODULE_SWITCH_CURSED_ITEMS_ENABLED) == TRUE &&
        GetIsObjectValid(oItem) &&
        (GetItemCursedFlag(oItem) || GetLocalInt(oItem, "IS_CURSED")))
    {
        int nBaseItemType = GetBaseItemType(oItem);
        if (nBaseItemType == BASE_ITEM_MAGICROD ||
            nBaseItemType == BASE_ITEM_MAGICSTAFF ||
            nBaseItemType == BASE_ITEM_MAGICWAND)
        {
	    if (!GetItemCursedFlag(oItem)) { 
		//ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oPC);
		FloatingTextStringOnCreature("The " +GetName(oItem)+ " is cursed!", oCaster, FALSE);
                SetName(oItem, "Cursed " +GetName(oItem));
                SetItemCursedFlag(oItem, TRUE);
                SetPlotFlag(oItem, TRUE);
	    } 

            int nRoll = d100();
            if (nRoll <= 15) //spell fails to fire
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oCaster, EventSpellCastAt(oCaster, GetSpellId(), FALSE));

                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), oCaster);
                SendMessageToPC(oCaster, "Your spell fizzles and dies, harmlessly expending its magical energies.");
                SetModuleOverrideSpellScriptFinished();
            }
            else if (nRoll <= 80) //spell misfires
            {
                object oTarget;
                //50% chance to target caster instead
                nRoll = d100();
                if (nRoll <= 50)
                {
                    oTarget = oCaster;
                }
                else
                {
                    oTarget = GetSpellTargetObject();
                }

                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), TRUE));

                nRoll = d100();

                // 1 - 5 slow target for 10 rounds
                if (nRoll < 6)
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oCaster, RoundsToSeconds(10));
                }
                // 6 - 10 polymorph target into chicken
                else if (nRoll < 11)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(POLYMORPH_TYPE_CHICKEN), oTarget, RoundsToSeconds(d4()));
                }
                // 11 - 15 delude wielder into thinking it's another effect
                else if (nRoll < 16)
                {
                    int nFakeSpell;
                    effect eFakeEffect;
                    if (Random(2) == 0)
                    {
                        nFakeSpell = SPELL_FIREBALL;
                        eFakeEffect = EffectVisualEffect(VFX_FNF_FIREBALL);
                    }
                    else
                    {
                        nFakeSpell  = SPELL_LIGHTNING_BOLT;
                        eFakeEffect = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
                    }
                    AssignCommand(oItem, ActionCastFakeSpellAtObject(nFakeSpell, oTarget));
                    if (nFakeSpell == SPELL_LIGHTNING_BOLT)
                    {
                        effect eLightning = EffectBeam(VFX_BEAM_LIGHTNING, OBJECT_SELF, BODY_NODE_HAND);
                        AssignCommand(oItem, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLightning, oTarget, 1.0)));
                    }
                    AssignCommand(oItem, ActionDoCommand(ApplyEffectToObject(DURATION_TYPE_INSTANT, eFakeEffect, oTarget)));
                }
                // 16 - 20 windstorm-force gust of wind -- knock down everyone in the area and play a wind sound
                else if (nRoll < 21)
                {
                    DoWindstorm(GetLocation(oTarget));
                }
                // 21 - 25 detect thoughts -- give short-term premonition
                else if (nRoll < 26)
                {
                    DoDetectThoughts(oCaster);
                }
                // 26 - 30 stinking cloud, 30 ft range
                else if (nRoll < 31)
                {
                    location lTargetLoc = GetLocation(oTarget);
                    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(259), lTargetLoc);
                    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_PER_FOGSTINK), lTargetLoc, RoundsToSeconds(d4()));
                }
                // 31 - 33 heavy rain falls briefly
                else if (nRoll < 34)
                {
                    PlaySound("as_wt_thundercl3");
                    object oArea = GetArea(oCaster);
                    SetWeather(oArea, WEATHER_RAIN);
                    DelayCommand(RoundsToSeconds(5), SetWeather(oArea, WEATHER_USE_AREA_SETTINGS));
                }
                // 34 - 36 summon penguin, rat, or cow
                else if (nRoll < 37)
                {
                    DoSillySummon(oTarget);
                }
                // 37 - 46 polymorph caster into a penguin
                else if (nRoll < 47)
                {
                    effect ePoly = EffectPolymorph(POLYMORPH_TYPE_PENGUIN);
                    effect eImp =  EffectVisualEffect(VFX_IMP_POLYMORPH);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImp, oCaster);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoly, oCaster, RoundsToSeconds(d4()));
                    SetCustomToken(0, GetName(oCaster));
                    FloatingTextStrRefOnCreature( 9266, oCaster);
                }
                // 47 - 49   Butterflies
                else if (nRoll < 50)
                {
                    ActionCastSpellAtObject(505, oTarget, METAMAGIC_ANY, TRUE);
                    ActionDoCommand(SetCommandable(TRUE));
                    SetCommandable(FALSE);
                }
                // 50 - 53 give target Bull's Strength
                else if (nRoll < 54)
                {
                    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, d4());
                    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                    effect eLink = EffectLinkEffects(eStr, eDur);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d6()));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
                // 54 - 58 darkness around target
                else if (nRoll < 59)
                {
                    effect eAOE = EffectAreaOfEffect(AOE_PER_DARKNESS);
                    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oTarget), RoundsToSeconds(d4()));
                }
                // 59 - 62 grass grows around caster
                else if (nRoll < 63)
                {
                    effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE);
                    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, GetLocation(oCaster), RoundsToSeconds(d6()));
                }
                // 63 - 65 turn target ethereal
                else if (nRoll < 66)
                {
                    effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
                    effect eDam = EffectDamageReduction(20, DAMAGE_POWER_PLUS_THREE);
                    effect eSpell = EffectSpellLevelAbsorption(2);
                    effect eConceal = EffectConcealment(25);
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

                    effect eLink = EffectLinkEffects(eDam, eVis);
                    eLink = EffectLinkEffects(eLink, eSpell);
                    eLink = EffectLinkEffects(eLink, eDur);
                    eLink = EffectLinkEffects(eLink, eConceal);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d4()));
                }
                // 66 - 69 make the target invisible
                else if (nRoll < 70)
                {
                    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, RoundsToSeconds(d6()));
                }
                // 77 - 79 polymorph target into a chicken
                else if (nRoll < 80)
                {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(POLYMORPH_TYPE_CHICKEN), oTarget, RoundsToSeconds(d4()));
                    SetCustomToken(0, GetName(oTarget));
                    FloatingTextStrRefOnCreature( 9265, oTarget);
                }
                // 80 - 84 wielder goes invisible
                else if (nRoll < 85)
                {
                    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);
                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                    effect eLink = EffectLinkEffects(eInvis, eDur);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster, RoundsToSeconds(d6()));
                }
                // 85 - 87 long-term pixie dust visual effect on caster
                else if (nRoll < 88)
                {
                    int nEffectPixieDust = 321;
                    effect eDust =  EffectVisualEffect(nEffectPixieDust);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDust, oCaster, RoundsToSeconds(d10(3) + 10));
                }
                // 88 - 90 gems fly out at target
                else if (nRoll < 91)
                {
                    ActionCastSpellAtObject(504, oTarget, METAMAGIC_ANY, TRUE);
                    ActionDoCommand(SetCommandable(TRUE));
                    SetCommandable(FALSE);
                }
                // 91 - 95 shimmering colors blind target
                else if (nRoll < 96)
                {
                    ActionCastFakeSpellAtObject(SPELL_PRISMATIC_SPRAY, oTarget, PROJECTILE_PATH_TYPE_DEFAULT);
                    DoBlindnessEffect(oCaster, GetLocation(oTarget), 20.0, d4());
                }
                // 96 - 97 wielder turns blue or purple
                else if (nRoll < 98)
                {
                    effect eVis;
                    SetCustomToken(0, GetName(oCaster));
                    if (Random(2) == 0)
                    {
                        eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
                        FloatingTextStrRefOnCreature(8861, oCaster);
                    }
                    else
                    {
                        eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
                        FloatingTextStrRefOnCreature(8860, oCaster);
                    }
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oCaster, TurnsToSeconds(3));
                }
                // 98 - 100 flesh to stone or stone to flesh
                else
                {
                    nSpell = SPELL_FLESH_TO_STONE;
                    effect eEff = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(eEff) && GetEffectType(eEff) != EFFECT_TYPE_PETRIFY)
                        eEff = GetNextEffect(oTarget);

                    if (GetIsEffectValid(eEff) && GetEffectType(eEff) == EFFECT_TYPE_PETRIFY)
                        nSpell = SPELL_STONE_TO_FLESH;

                    AssignCommand(oItem, ActionCastSpellAtObject(nSpell, oTarget, METAMAGIC_NONE, TRUE,0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
                }

                SetModuleOverrideSpellScriptFinished();
            }
        }
    }

//------------------------------------------------------------------------------
// MATERIAL COMPONENTS
// Check for base components - component bag or holy/unholy symbol
//------------------------------------------------------------------------------

    //Items are not subject to material components
    //* Hotfix - nor are DMs
    if (!GetIsObjectValid(oItem) && !GetIsDM(oCaster))
    {
        if (GetHasMaterialComponent(GetSpellId()) == TRUE)
        {
            bValid = TRUE;
            if (GetLevelByClass(CLASS_TYPE_BARD, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRUID, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_PALADIN, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_RANGER, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_SORCERER, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_WIZARD, oCaster) > 0 )
            {
                if (!HasItem(oCaster, "Q_IT_COMPNTBAG"))
                {
                    bValid = FALSE;
                    SendMessageToPC(oCaster, "You cannot cast that spell without the necessary material components.");
                    SendMessageToPC(oCaster, "You need to purchase a spell component bag.");
                }
            }
            if (GetLevelByClass(CLASS_TYPE_CLERIC, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_DRUID, oCaster) > 0 ||
                GetLevelByClass(CLASS_TYPE_PALADIN, oCaster) > 0 )
            {
                if (HasItem(oCaster, "Q_IT_SYMBOL001") ||
                    HasItem(oCaster, "Q_IT_SYMBOL002") )
                {
                    //Do nothing because bValid is already TRUE
                }
                else
                {
                    bValid = FALSE;
                    string sSymbol = "holy";
                    if (GetAlignmentGoodEvil(oCaster) == ALIGNMENT_EVIL)
                    {
                        sSymbol = "unholy";
                    }
                    SendMessageToPC(oCaster, "You cannot cast that spell without a " +sSymbol+ " symbol.");
                }
            }
            if (bValid == FALSE)
            {
                SetModuleOverrideSpellScriptFinished();
            }
        }
    }


//------------------------------------------------------------------------------
// SPELL BEHAVIOR OVERRIDES
//------------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //SPECIAL HANDLING - Bane, Bless, Identify, Legend Lore and Remove Curse

    switch (nSpell)
    {
        case SPELL_BANE:
        {
            if (GetModuleSwitchValue(MODULE_SWITCH_PNP_BANE_BLESS) == TRUE)
            {
                //Declare major variables
                effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
                effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
                effect eAttack = EffectAttackDecrease(1);
                effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                effect eLink = EffectLinkEffects(eAttack, eSave);
                eLink = EffectLinkEffects(eLink, eDur);
                int nDuration = GetCasterLevel(OBJECT_SELF);
                int nMetaMagic = GetMetaMagicFeat();
                float fDelay;
                //Metamagic duration check
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration *2;   //Duration is +100%
                }
                location lLoc = GetSpellTargetLocation();
                //Apply Impact
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lLoc);

                //Get the first target in the radius around the caster
                oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
                while(GetIsObjectValid(oTarget))
                {
                    if (spellsIsTarget(oTarget,SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
                    {
                         //Fire spell cast at event for target
                         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 449, FALSE));
                         if (!MyResistSpell(OBJECT_SELF, oTarget) )
                         {
                            if (GetHasSpellEffect(SPELL_BLESS, oTarget))
                            {
                                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                                DelayCommand(fDelay, RemoveEffectsFromSpell(oTarget, SPELL_BLESS));
                            }
                            else
                            {
                                /*Will Save*/
                                int nWillResult = WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
                                // * Bane is a mind affecting spell BUT its effects are not classified
                                // * as mind affecting. To make this work I have to only apply
                                // * the effects on the case of a failure, unlike most other spells.
                                if (nWillResult == 0)
                                {
                                    fDelay = GetRandomDelay(0.4, 1.1);
                                    //Apply VFX impact and bonus effects
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
                                }
                                else
                                // * target will immune
                                if (nWillResult == 2)
                                {
                                    SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
                                }
                            }
                        }
                    }
                    //Get the next target in the specified area around the caster
                    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLoc);
                }
                SetModuleOverrideSpellScriptFinished();
            }
        }
        break;

        case SPELL_BLESS:
        {
            if (GetModuleSwitchValue(MODULE_SWITCH_PNP_BANE_BLESS) == TRUE)
            {
                //Declare major variables
                object oTarget = GetSpellTargetObject();
                int nDuration = 1 + GetCasterLevel(OBJECT_SELF);
                effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
                effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
                effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
                effect eAttack = EffectAttackIncrease(1);
                effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);
                effect eLink = EffectLinkEffects(eAttack, eSave);
                eLink = EffectLinkEffects(eLink, eDur);

                int nMetaMagic = GetMetaMagicFeat();
                float fDelay;
                //Metamagic duration check
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration *2;   //Duration is +100%
                }

                //Apply Impact
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

                //Get the first target in the radius around the caster
                oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
                while(GetIsObjectValid(oTarget))
                {
                    if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
                    {
                        fDelay = GetRandomDelay(0.4, 1.1);
                        //Fire spell cast at event for target
                        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLESS, FALSE));

                        if (GetHasSpellEffect(SPELL_BANE, oTarget))
                        {
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                            DelayCommand(fDelay, RemoveEffectsFromSpell(oTarget, SPELL_BANE));
                        }
                        else
                        {
                            //Apply VFX impact and bonus effects
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration)));
                        }
                    }
                    //Get the next target in the specified area around the caster
                    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
                }
                SetModuleOverrideSpellScriptFinished();
            }
        }
        break;

        case SPELL_IDENTIFY:
        {
            //Check for material components
            if (GetModuleSwitchValue(MODULE_SWITCH_SPELL_COMPONENTS_ENABLED) == TRUE)
            {
                if (!GetIsObjectValid(oItem) && !GetIsDM(oCaster))
                {
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST006");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need 100gp worth of pearl dust to cast Identify.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
            }
            //Declare major variables
            object oTarget = GetSpellTargetObject();
            int nLevel = GetCasterLevel(oCaster);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_IDENTIFY, FALSE));

            //Make sure the item has not already been identified
            if(!GetIdentified(oTarget))
            {
                //Apply the VFX
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), oCaster);

                if (GetLocalInt(oTarget, "IS_CURSED") == 1)
                {
                    if (d100() <= nLevel)
                    {
                        SetIdentified(oTarget, TRUE);
                        SendMessageToPC(oCaster, "The spell reveals the " +GetName(oTarget)+ " is cursed!");
                        SetName(oTarget, "Cursed " +GetName(oTarget));
                    }
                }
                SetIdentified(oTarget, TRUE);
                SendMessageToPC(oCaster, "The spell reveals the magical attributes of " +GetName(oTarget)+ ".");
            }
            SetModuleOverrideSpellScriptFinished();
        }
        break;

        case SPELL_LEGEND_LORE:
        {
            //Check for material components
            if (GetModuleSwitchValue(MODULE_SWITCH_SPELL_COMPONENTS_ENABLED) == TRUE)
            {
                if (!GetIsObjectValid(oItem) && !GetIsDM(oCaster))
                {
                    object oComp1 = GetItemPossessedBy(oCaster, "Q_IT_INCENSE");
                    object oComp2 = GetItemPossessedBy(oCaster, "Q_IT_IVORY");
                    if (!GetIsObjectValid(oComp1) ||
                        !GetIsObjectValid(oComp2) )
                    {
                        if (!GetIsObjectValid(oComp1))
                        {
                            SendMessageToPC(oCaster, "You need incense worth at least 250gp to cast Legend Lore.");
                        }
                        if (!GetIsObjectValid(oComp2))
                        {
                            SendMessageToPC(oCaster, "You need ivory worth at least 150gp to cast Legend Lore.");
                        }
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComp1);
                    }
                }
            }

            //Declare major variables
            object oTarget = GetSpellTargetObject();
            object oItem;
            int nLevel = GetCasterLevel(oCaster);

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_LEGEND_LORE, FALSE));

            //Apply the VFX
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), oCaster);

            oItem = GetFirstItemInInventory(oTarget);
            while (GetIsObjectValid(oItem))
            {
                //Make sure the item has not already been identified
                if(!GetIdentified(oTarget))
                {
                    //Apply the VFX
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGICAL_VISION), oCaster);

                    if (GetLocalInt(oTarget, "IS_CURSED") == 1)
                    {
                        if (d100() <= nLevel)
                        {
                            SetIdentified(oTarget, TRUE);
                            SendMessageToPC(oCaster, "The spell reveals the " +GetName(oTarget)+ " is cursed!");
                            SetName(oTarget, "Cursed " +GetName(oTarget));
                        }
                    }
                    SetIdentified(oTarget, TRUE);
                    SendMessageToPC(oCaster, "The spell reveals the magical attributes of " +GetName(oTarget)+ ".");
                }
                oItem = GetNextItemInInventory(oTarget);
            }
            SetModuleOverrideSpellScriptFinished();
        }
        break;


        case SPELL_REMOVE_CURSE: //Cast on a cursed item
        {
            if (GetObjectType(oTarget) == OBJECT_TYPE_ITEM && GetItemCursedFlag(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(oCaster, SPELL_REMOVE_CURSE, FALSE));

                // Default is now automatic succes - no DC.
                int nDC = GetLocalInt(oItem, "CURSE_DC");
                if (nDC <= 0)
                {
                    nDC = 0;
                    //nDC = 17; // Base DC 10 + 7 (Min Level to cast Bestow Curse)
                }

                //Make a Will Save check
                if (nDC && !MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    SendMessageToPC(oCaster, "You are unable to negate the effects of the item's curse.");
                }
                else
                {
                    SetItemCursedFlag(oTarget, FALSE);
                    SetPlotFlag(oTarget, FALSE);    // should be TRUE to keep people from selling it?
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REMOVE_CONDITION), GetItemPossessor(oTarget));
                    SendMessageToPC(oCaster, "You have temporarily negated the effects of the item's curse, enabling you to unequip it.");
                }
		SetModuleOverrideSpellScriptFinished();
	    }
        }
        break;
    }

    //--------------------------------------------------------------------------
    // MATERIAL COMPONENTS - All Other Spells

    if (GetModuleSwitchValue(MODULE_SWITCH_SPELL_COMPONENTS_ENABLED) == TRUE)
    {
        if (!GetIsObjectValid(oItem) && !GetIsDM(oCaster))
        {
            switch (nSpell)
            {
                case SPELL_ANIMATE_DEAD:
                case SPELL_DEATH_ARMOR:
                {
                    switch (nSpell)
                    {
                        case SPELL_ANIMATE_DEAD: sSpell = "Animate Dead"; break;
                        case SPELL_DEATH_ARMOR: sSpell = "Death Armor"; break;
                    }
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEM003");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need a black onyx worth at least 50gp to cast " +sSpell+ "!");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyItem(oComponent);
                    }
                }
                break;

                case SPELL_CLOAK_OF_CHAOS:
                case SPELL_HOLY_AURA:
                case SPELL_SHIELD_OF_LAW:
                case SPELL_UNHOLY_AURA:
                {
                    switch (nSpell)
                    {
                        case SPELL_CLOAK_OF_CHAOS: sSpell = "Cloak of Chaos"; break;
                        case SPELL_HOLY_AURA: sSpell = "Holy Aura"; break;
                        case SPELL_SHIELD_OF_LAW: sSpell = "Shield of Law"; break;
                        case SPELL_UNHOLY_AURA: sSpell = "Unholy Aura"; break;
                    }
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_RELIQUARY");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need a reliquary worth at least 500gp to cast " +sSpell+ "!");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_BLACKSTAFF:
                case SPELL_SPELLSTAFF:
                {
                    switch (nSpell)
                    {
                        case SPELL_BLACKSTAFF: sSpell = "Blackstaff"; break;
                        case SPELL_SPELLSTAFF: sSpell = "Spellstaff"; break;
                    }
                    oComponent = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
                    if (GetIsObjectValid(oComponent))
                    {
                        if (GetBaseItemType(oComponent) != BASE_ITEM_MAGICSTAFF ||
                            GetBaseItemType(oComponent) != BASE_ITEM_QUARTERSTAFF )
                        {
                            SendMessageToPC(oCaster, "You need a normal or magical staff equipped to cast " +sSpell+ "!");
                            SetModuleOverrideSpellScriptFinished();
                        }
                    }
                }
                break;

                case SPELL_CIRCLE_OF_DEATH:
                {
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST003");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need 500gp worth of black pearl dust to cast Circle of Death.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_CONTINUAL_FLAME:
                {
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST004");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need 50gp worth of ruby dust to cast Continual Flame.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_CREATE_UNDEAD:
                case SPELL_CREATE_GREATER_UNDEAD:
                {
                    switch (nSpell)
                    {
                        case SPELL_CREATE_UNDEAD: sSpell = "Create Undead"; break;
                        case SPELL_CREATE_GREATER_UNDEAD: sSpell = "Create Greater Undead"; break;
                    }
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEM004");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need a flawless black onyx worth at least 150gp to cast " +sSpell+ ".");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyItem(oComponent);
                    }
                }
                break;

                case SPELL_DESTRUCTION:
                {
                    if (!HasItem(oCaster, "Q_IT_SYMBOL003") ||
                        !HasItem(oCaster, "Q_IT_SYMBOL004") )
                    {
                        SendMessageToPC(oCaster, "You need an anethemic holy or unholy symbol to cast Destruction.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                }
                break;

                case SPELL_FIREBRAND:
                {
                    oComponent = GetItemPossessedBy(oCaster, "X1_WMGRENADE002");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need a flask of alchemist's fire to cast Firebrand.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_GATE:
                {
                    if (!plotCanRemoveXP(oCaster, 1000))
                    {
                        SendMessageToPC(oCaster, "You need at least 1000 available XP to cast Gate.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        RemoveXP(oCaster, 1000);
                    }
                }
                break;

                case SPELL_GLYPH_OF_WARDING:
                {
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST002");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need 200gp worth of pink diamond dust to cast Glyph of Warding.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_GREATER_RESTORATION:
                {
                    if (!plotCanRemoveXP(oCaster, 500))
                    {
                        SendMessageToPC(oCaster, "You need at least 500 available XP to cast Greater Restoration.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        RemoveXP(oCaster, 500);
                    }
                }
                break;

                case SPELL_STONESKIN:
                case SPELL_GREATER_STONESKIN:
                {
                    switch (nSpell)
                    {
                        case SPELL_STONESKIN: sSpell = "Stoneskin"; break;
                        case SPELL_GREATER_STONESKIN: sSpell = "Greater Stoneskin"; break;
                    }
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST005");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need 250gp worth of blue diamond dust to cast " +sSpell+ "!");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_MORDENKAINENS_SWORD:
                {
                    oComponent = GetItemPossessedBy(oCaster, "Q_IT_PLATSWORD");
                    if (!GetIsObjectValid(oComponent))
                    {
                        SendMessageToPC(oCaster, "You need a platinum sword figurine worth at least 250gp to cast Mordenkainen's Sword.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                    else
                    {
                        DestroyObject(oComponent);
                    }
                }
                break;

                case SPELL_EPIC_MUMMY_DUST:
                {
                        oComponent = GetItemPossessedBy(oCaster, "Q_IT_MUMMYDUST");
                        bValid = GetIsObjectValid(oComponent);
                        int nXP = plotCanRemoveXP(oCaster, 2000);
                        if (!bValid || !nXP)
                        {
                            if (!nXP)
                            {
                                SendMessageToPC(oCaster, "You need at least 2,000 available XP to cast Mummy Dust.");
                            }
                            if (!bValid)
                            {
                                SendMessageToPC(oCaster, "You need mummy dust worth at least 10,000gp to cast Mummy Dust.");
                            }
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            RemoveXP(oCaster, 2000);
                        }
                }
                break;

                case SPELL_PLANAR_ALLY:
                {
                        if (!plotCanRemoveXP(oCaster, 250))
                        {
                            SendMessageToPC(oCaster, "You need at least 250 available XP to cast Planar Ally.");
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            RemoveXP(oCaster, 250);
                        }
                }
                break;

                case SPELL_PROTECTION_FROM_SPELLS:
                {
                        oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEM005");
                        if (!GetIsObjectValid(oComponent))
                        {
                            SendMessageToPC(oCaster, "You need a white diamond worth at least 1,000gp to cast Protection from Spells.");
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            DestroyItem(oComponent);
                        }
                }
                break;

                case SPELL_RESTORATION:
                {
                        oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST001");
                        if (!GetIsObjectValid(oComponent))
                        {
                            SendMessageToPC(oCaster, "You need 100gp worth of diamond dust to cast Restoration.");
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            DestroyObject(oComponent);
                        }
                }
                break;

                case SPELL_SHAPECHANGE:
                {
                        oComponent = GetItemPossessedBy(oCaster, "Q_IT_JADECIRCLT");
                        if (!GetIsObjectValid(oComponent))
                        {
                            SendMessageToPC(oCaster, "You need a jade circlet at least 1,500gp to cast Shapechange.");
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            DestroyObject(oComponent);
                        }
                }
                break;

                case SPELL_SHELGARNS_PERSISTENT_BLADE:
                {
                    bValid = FALSE;
                    oComponent = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
                    if (GetIsObjectValid(oComponent) && GetTag(oComponent) == "Q_IT_DAGGER001")
                    {
                        bValid = TRUE;
                    }
                    oComponent = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCaster);
                    if (GetIsObjectValid(oComponent) && GetTag(oComponent) == "Q_IT_DAGGER001")
                    {
                        bValid = TRUE;
                    }
                    if (bValid == FALSE)
                    {
                        SendMessageToPC(oCaster, "You need a silvered dagger equipped to cast Shelgarn's Persistant Blade.");
                        SetModuleOverrideSpellScriptFinished();
                    }
                }
                break;

                case SPELL_TENSERS_TRANSFORMATION:
                {
                        oComponent = GetItemPossessedBy(oCaster, "NW_IT_MPOTION015");
                        if (!GetIsObjectValid(oComponent))
                        {
                            SendMessageToPC(oCaster, "You need a potion of bull's strength to cast Tenser's Transformation.");
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            SetCommandable(TRUE, oCaster);
                            AssignCommand(oCaster, ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
                            DelayCommand(1.0, SetCommandable(FALSE, oCaster));
                            DestroyItem(oComponent);
                        }
                }
                break;

                case SPELL_UNDEATH_TO_DEATH:
                {
                        oComponent = GetItemPossessedBy(oCaster, "Q_IT_GEMDUST007");
                        if (!GetIsObjectValid(oComponent))
                        {
                            SendMessageToPC(oCaster, "You need 500gp worth of red diamond dust to cast Undeath to Death.");
                            SetModuleOverrideSpellScriptFinished();
                        }
                        else
                        {
                            DestroyObject(oComponent);
                        }
                }
                break;
            }
        }
    }
}
