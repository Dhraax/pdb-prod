////////////////////////////////////////////////////////////////////////////////
//                          ARCANE ARCHER INCLUDE                             //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Include file used to centralize the Imbue Arrow functions.                //
//                                                                            //
//  When making changes, don't forget to recompile all scripts using this     //
//include file.                                                               //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Created By  : Nailog                                                        //
//Last Edited : 7-26-2004                                                     //
////////////////////////////////////////////////////////////////////////////////

#include "x2_inc_itemprop"

////////////////////////////////////////////////////////////////////////////////
//                                CONSTANTS                                   //
////////////////////////////////////////////////////////////////////////////////

//ResRef constants.  Any changes take effect throughout the code.
const string AA_IMBUED_ARROW = "wp_arr_imbue_1";
const string AA_CREATION_WAY = "w_aacreate";


////////////////////////////////////////////////////////////////////////////////
//                                PROTOTYPES                                  //
////////////////////////////////////////////////////////////////////////////////

/// @brief Destroys all imbued arrows ("wp_arr_imbue_1") in a container, including recursively inside bags/containers.
/// @param oContainer The object (PC or container) whose inventory is searched.
/// @returns Nothing. All found imbued arrows are destroyed.
void DestroyImbuedArrowsInContainer(object oContainer);

//Creates an imbued arrow at AA_CREATION_WAY.  Enchants arrow and copies it to
//the archer.  Returns the enchanted arrow.
object AACreateImbuedArrow(object oArrow, int iOnHitSpell, int iSpellLevel, float fDuration, object oArcher = OBJECT_SELF);

//Removes all imbued arrows from oArcher's inventory.
void AADestroyAllImbuedArrows(object oArcher);

//Imbues oArrow with iSpell of iSpellLevel.
//Returns 1 if it was successful.
//Returns 0 if the spell was invalid.
//Returns -1 if oArrow was not BASE_ITEM_ARROW.
int AAImbueArrow(object oArrow, int iSpell, int iSpellLevel);

//Floats a message and destroys oArrow.  If oArrow does not exist, nothing
//happens.
void AAImbueExpire(object oArrow);

//Controls which spells are allowed to be Imbued.
//Returns the IP_CONST_ONHIT_CASTSPELL_* constant matching the SPELL_* constant.
//Returns -1 if there is no match.
int SpellToOnHitCastSpell(int iSpell);


////////////////////////////////////////////////////////////////////////////////
//                              IMPLEMENTATION                                //
////////////////////////////////////////////////////////////////////////////////

/// @brief Destroys all imbued arrows ("wp_arr_imbue_1") in a container, recursively (including inside bags).
/// @param oContainer The object (PC or container) whose inventory is searched.
/// @returns Nothing. All found imbued arrows are destroyed.
void DestroyImbuedArrowsInContainer(object oContainer)
{
    object oItem = GetFirstItemInInventory(oContainer);

    while (GetIsObjectValid(oItem))
    {
        if (GetResRef(oItem) == AA_IMBUED_ARROW)
        {
            DestroyObject(oItem);
        }
        else
        {
            // Recursive call to check inside containers or any object with inventory.
            DestroyImbuedArrowsInContainer(oItem);
        }
        oItem = GetNextItemInInventory(oContainer);
    }
}

object AACreateImbuedArrow(object oArrow, int iOnHitSpell, int iSpellLevel, float fDuration, object oArcher = OBJECT_SELF)
{
    //Construct the imbued arrow's new tag.
    string sNewTag   = GetStringUpperCase(GetStringLeft(AA_IMBUED_ARROW, 13)) + IntToString(iOnHitSpell);
    object oWaypoint = GetWaypointByTag(GetStringUpperCase(AA_CREATION_WAY));
    object oNewArrow = CreateObject(OBJECT_TYPE_ITEM, AA_IMBUED_ARROW, GetLocation(oWaypoint), FALSE, sNewTag);

    //Debug statement.
    //if (GetIsObjectValid(oNewArrow))
    //{
    //    SendMessageToPC(oArcher, "NEW ARROW CREATED!");
    //}

    //Copy all item properties from original arrow to new one.
    //Since the DMG does not state that magical arrows cannot be imbued, I have
    //allowed magical arrows to be imbued.
    itemproperty ipCopy = GetFirstItemProperty(oArrow);
    while (GetIsItemPropertyValid(ipCopy))
    {
        IPSafeAddItemProperty(oNewArrow, ipCopy, 0.0);

        ipCopy = GetNextItemProperty(oArrow);
    }

    //Destroy one arrow.
    int iStack = GetItemStackSize(oArrow);

    if (iStack > 1)
    {
        SetItemStackSize(oArrow, iStack - 1);
    }
    else
    {
        DestroyObject(oArrow);
    }

    //Debug statement.
    //SendMessageToPC(oArcher, "OLD ARROW DESTROYED!");

    //Add OnHit: Cast Spell to new arrow.
    itemproperty ipSpell = ItemPropertyOnHitCastSpell(iOnHitSpell, iSpellLevel);

    IPSafeAddItemProperty(oNewArrow, ipSpell, fDuration);

    //Copy new arrow to archer's inventory.
    object oImbuedArrow = CopyItem(oNewArrow, oArcher);

    //Debug statement.
    //if (GetIsObjectValid(oImbuedArrow))
    //{
    //    SendMessageToPC(oArcher, "IMBUED ARROW CREATED!");
    //}

    //Destroy new arrow.
    DestroyObject(oNewArrow);

    return oImbuedArrow;
}

void AADestroyAllImbuedArrows(object oArcher)
{
    //Loop through oArcher's inventory.
    object oItem = GetFirstItemInInventory(oArcher);

    while (GetIsObjectValid(oItem))
    {
        //If the item is an imbued arrow, destroy it.
        if (GetResRef(oItem) == AA_IMBUED_ARROW)
        {
            DestroyObject(oItem);
        }

        oItem = GetNextItemInInventory(oArcher);
    }

    //Check arrow slot for imbued arrows.
    oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oArcher);

    //If the item is an imbued arrow, destroy it.
    if (GetResRef(oItem) == AA_IMBUED_ARROW)
    {
        DestroyObject(oItem);
    }
}

int AAImbueArrow(object oArrow, int iSpell, int iSpellLevel)
{
    //Only imbue if oArrow is an arrow.
    if (GetBaseItemType(oArrow) == BASE_ITEM_ARROW)
    {
        int bContinue = TRUE;

        //Check for other OnHitCastSpell properties.  If found, abort the imbue.
        if (GetItemHasItemProperty(oArrow, ITEM_PROPERTY_ONHITCASTSPELL))
        {
            bContinue = FALSE;
        }
/*        else
        {
            //Check for other temporary properties on the arrow.  If found, abort
            //the imbue.
            itemproperty ipCheck = GetFirstItemProperty(oArrow);
            while (GetIsItemPropertyValid(ipCheck))
            {
                if (GetItemPropertyDurationType(ipCheck) == DURATION_TYPE_TEMPORARY)
                {
                    bContinue = FALSE;
                }

                ipCheck = GetNextItemProperty(oArrow);
            }
        }
*/
        //If we may continue with the imbueing.
        if (bContinue)
        {
            //Spell must be valid.
            int iISpell = SpellToOnHitCastSpell(iSpell);

            if (iISpell > -1)
            {
                //Find out which stack of arrows was targetted.
                int bEquip = FALSE;
                if (GetItemInSlot(INVENTORY_SLOT_ARROWS) == oArrow)
                {
                    bEquip = TRUE;
                }

                //Duration is 1 hour per level of Arcane Archer.
                float  fDuration    = HoursToSeconds(GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER));

                //Create the imbued arrow in the player's inventory.
                object oImbuedArrow = AACreateImbuedArrow(oArrow, iISpell, iSpellLevel, fDuration);

                //Allows the player to target equipped arrows and have the new
                //arrow become equipped after imbueing.
                if (bEquip)
                {
                    ActionEquipItem(oImbuedArrow, INVENTORY_SLOT_ARROWS);
                }

                //Delay the destruction of the imbued arrow.  Used to clean up
                //trash, as well as informing the player that his imbueing has
                //expired.
                DelayCommand(fDuration, AAImbueExpire(oImbuedArrow));

                //The imbueing was successful, so return a TRUE.
                return TRUE;
            }
        }

        //Imbue didn't happen, either because the spell was wrong, or because
        //there were other disallowed enchantments on the target arrow.
        return FALSE;
    }
    else
    {
        //The targetted arrow was not, in fact, an arrow.
        return -1;
    }
}

void AAImbueExpire(object oArrow)
{
    //If the arrow doesn't exist anymore, I.E. player logged off, or the arrow
    //was fired, then don't float a message, and don't try to destroy the arrow.
    if (GetIsObjectValid(oArrow))
    {
        //Informs the possessor of the arrow that the imbue expired.  Allows for
        //trading of arrows, but trading of arrows allows for minor exploitation.
        FloatingTextStringOnCreature("* El encantamiento expiró *", GetItemPossessor(oArrow));

        //Lower stack size by one, or destroy arrow.
        int iStack = GetItemStackSize(oArrow);

        if (iStack > 1)
        {
            SetItemStackSize(oArrow, iStack - 1);
        }
        else
        {
            DestroyObject(oArrow);
        }
    }
}

int SpellToOnHitCastSpell(int iSpell)
{
    //If no OnHitCastSpell is found, this is returned.
    int iOHSpell = -1;

    switch (iSpell)
    {
        case SPELL_ACID_FOG:                                iOHSpell = IP_CONST_ONHIT_CASTSPELL_ACID_FOG;
                                                            break;
        case SPELL_ACID_SPLASH:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_ACID_SPLASH;
                                                            break;

        //Spell centers on caster, not arrow.  Disabled for awkwardness, though
        //you can re-enable it, if you wish.  I suggest editing the spell script
        //first, though, to center on the target, if an item cast the spell.
        //case SPELL_BALAGARNSIRONHORN:                       iOHSpell = IP_CONST_ONHIT_CASTSPELL_BALAGARNSIRONHORN;
        //                                                    break;

        case SPELL_BALL_LIGHTNING:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_BALL_LIGHTNING;
                                                            break;
        case SPELL_BANE:                                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_BANE;
                                                            break;
        case SPELL_BANISHMENT:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_BANISHMENT;
                                                            break;
        case SPELL_BESTOW_CURSE:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_BESTOW_CURSE;
                                                            break;
        case SPELL_BIGBYS_CLENCHED_FIST:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_BIGBYS_CLENCHED_FIST;
                                                            break;
        case SPELL_BIGBYS_CRUSHING_HAND:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_BIGBYS_CRUSHING_HAND;
                                                            break;
        case SPELL_BIGBYS_FORCEFUL_HAND:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_BIGBYS_FORCEFUL_HAND;
                                                            break;
        case SPELL_BIGBYS_GRASPING_HAND:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_BIGBYS_GRASPING_HAND;
                                                            break;
        case SPELL_BIGBYS_INTERPOSING_HAND:                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_BIGBYS_INTERPOSING_HAND;
                                                            break;

        //Like Wall of Fire, there is a problem with the OnHitCastSpell property
        //2DA.  Uncomment these two lines if you fix the entry.
        //case SPELL_BLADE_BARRIER:                           iOHSpell = IP_CONST_ONHIT_CASTSPELL_BLADE_BARRIER;
        //                                                    break;

        case SPELL_BLINDNESS_AND_DEAFNESS:                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_BLINDNESS_AND_DEAFNESS;
                                                            break;
        case SPELL_BOMBARDMENT:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_BOMBARDMENT;
                                                            break;
        case SPELL_CALL_LIGHTNING:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_CALL_LIGHTNING;
                                                            break;
        case SPELL_CHAIN_LIGHTNING:                         iOHSpell = IP_CONST_ONHIT_CASTSPELL_CHAIN_LIGHTNING;
                                                            break;
        case SPELL_CLOUDKILL:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_CLOUDKILL;
                                                            break;
        case SPELL_COMBUST:                                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_COMBUST;
                                                            break;
        case SPELL_CONFUSION:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_CONFUSION;
                                                            break;
        case SPELL_CONTAGION:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_CONTAGION;
                                                            break;
        case SPELL_CREEPING_DOOM:                           iOHSpell = IP_CONST_ONHIT_CASTSPELL_CREEPING_DOOM;
                                                            break;
        case SPELL_CRUMBLE:                                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_CRUMBLE;
                                                            break;
        case SPELL_DARKNESS:
        case SPELL_SHADOW_CONJURATION_DARKNESS:             iOHSpell = IP_CONST_ONHIT_CASTSPELL_DARKNESS;
                                                            break;
        case SPELL_DAZE:                                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_DAZE;
                                                            break;
        case SPELL_DEAFENING_CLANG:                         iOHSpell = IP_CONST_ONHIT_CASTSPELL_DEAFENING_CLNG;
                                                            break;
        case SPELL_DELAYED_BLAST_FIREBALL:                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_DELAYED_BLAST_FIREBALL;
                                                            break;
        case SPELL_DESTRUCTION:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_DESTRUCTION;
                                                            break;
        case SPELL_DISMISSAL:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_DISMISSAL;
                                                            break;
        case SPELL_DISPEL_MAGIC:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_DISPEL_MAGIC;
                                                            break;
        case SPELL_DOOM:                                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_DOOM;
                                                            break;
        case SPELL_DROWN:                                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_DROWN;
                                                            break;
        case SPELL_EARTHQUAKE:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_EARTHQUAKE;
                                                            break;
        case SPELL_ELECTRIC_JOLT:                           iOHSpell = IP_CONST_ONHIT_CASTSPELL_ELECTRIC_JOLT;
                                                            break;
        case SPELL_ENERGY_DRAIN:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_ENERGY_DRAIN;
                                                            break;
        case SPELL_ENERVATION:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_ENERVATION;
                                                            break;
        case SPELL_ENTANGLE:                                iOHSpell = IP_CONST_ONHIT_CASTSPELL_ENTANGLE;
                                                            break;
        case SPELL_EVARDS_BLACK_TENTACLES:                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_EVARDS_BLACK_TENTACLES;
                                                            break;
        case SPELL_FEAR:                                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_FEAR;
                                                            break;
        case SPELL_FEEBLEMIND:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_FEEBLEMIND;
                                                            break;

        //spells.2da problem.  Spell can't be targetted on items, only self.
        //If you change the target types for the spell, re-enable by uncommenting
        //the two lines.
        //case SPELL_FIRE_STORM:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_FIRE_STORM;
        //                                                    break;

        case SPELL_FIREBALL:
        case SPELL_SHADES_FIREBALL:                         iOHSpell = IP_CONST_ONHIT_CASTSPELL_FIREBALL;
                                                            break;
        case SPELL_FIREBRAND:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_FIREBRAND;
                                                            break;
        case SPELL_FLAME_LASH:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_FLAME_LASH;
                                                            break;
        case SPELL_FLAME_STRIKE:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_FLAME_STRIKE;
                                                            break;
        case SPELL_FLARE:                                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_FLARE;
                                                            break;
        case SPELL_FLESH_TO_STONE:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_FLESH_TO_STONE;
                                                            break;
        case SPELL_GEDLEES_ELECTRIC_LOOP:                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_GEDLEES_ELECTRIC_LOOP;
                                                            break;
        case SPELL_GHOUL_TOUCH:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_GHOUL_TOUCH;
                                                            break;
        case SPELL_GREASE:                                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_GREASE;
                                                            break;
        case SPELL_GREAT_THUNDERCLAP:                       iOHSpell = IP_CONST_ONHIT_CASTSPELL_GREAT_THUNDERCLAP;
                                                            break;
        case SPELL_GREATER_DISPELLING:                      iOHSpell = IP_CONST_ONHIT_CASTSPELL_GREATER_DISPELLING;
                                                            break;
        case SPELL_GREATER_SPELL_BREACH:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_GREATER_SPELL_BREACH;
                                                            break;
        case SPELL_GUST_OF_WIND:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_GUST_OF_WIND;
                                                            break;
        case SPELL_HAMMER_OF_THE_GODS:                      iOHSpell = IP_CONST_ONHIT_CASTSPELL_HAMMER_OF_THE_GODS;
                                                            break;
        case SPELL_HARM:                                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_HARM;
                                                            break;
        case SPELL_HOLD_ANIMAL:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_HOLD_ANIMAL;
                                                            break;
        case SPELL_HOLD_MONSTER:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_HOLD_MONSTER;
                                                            break;
        case SPELL_HOLD_PERSON:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_HOLD_PERSON;
                                                            break;
        case SPELL_HORIZIKAULS_BOOM:                        iOHSpell = IP_CONST_ONHIT_CASTSPELL_HORIZIKAULS_BOOM;
                                                            break;
        case SPELL_HORRID_WILTING:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_HORRID_WILTING;
                                                            break;
        case SPELL_ICE_STORM:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_ICE_STORM;
                                                            break;
        case SPELL_IMPLOSION:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_IMPLOSION;
                                                            break;
        case SPELL_INCENDIARY_CLOUD:                        iOHSpell = IP_CONST_ONHIT_CASTSPELL_INCENDIARY_CLOUD;
                                                            break;
        case SPELL_INFERNO:                                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFERNO;
                                                            break;
        case SPELL_INFESTATION_OF_MAGGOTS:                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFESTATION_OF_MAGGOTS;
                                                            break;

        //The Inflict Wounds spells do not work.  Seems to be a 2DA error.
        //Probably fixable, but I leave that to you.
        //case SPELL_INFLICT_CRITICAL_WOUNDS:                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFLICT_CRITICAL_WOUNDS;
        //                                                    break;
        //case SPELL_INFLICT_LIGHT_WOUNDS:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFLICT_LIGHT_WOUNDS;
        //                                                    break;
        //case SPELL_INFLICT_MINOR_WOUNDS:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFLICT_MINOR_WOUNDS;
        //                                                    break;
        //case SPELL_INFLICT_MODERATE_WOUNDS:                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFLICT_MODERATE_WOUNDS;
        //                                                    break;
        //case SPELL_INFLICT_SERIOUS_WOUNDS:                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_INFLICT_SERIOUS_WOUNDS;
        //                                                    break;

        case SPELL_ISAACS_GREATER_MISSILE_STORM:            iOHSpell = IP_CONST_ONHIT_CASTSPELL_ISAACS_GREATER_MISSILE_STORM;
                                                            break;
        case SPELL_ISAACS_LESSER_MISSILE_STORM:             iOHSpell = IP_CONST_ONHIT_CASTSPELL_ISAACS_LESSER_MISSILE_STORM;
                                                            break;
        case SPELL_LESSER_DISPEL:                           iOHSpell = IP_CONST_ONHIT_CASTSPELL_LESSER_DISPEL;
                                                            break;
        case SPELL_LESSER_SPELL_BREACH:                     iOHSpell = IP_CONST_ONHIT_CASTSPELL_LESSER_SPELL_BREACH;
                                                            break;
        case SPELL_LIGHT:                                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_LIGHT;
                                                            break;
        case SPELL_LIGHTNING_BOLT:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_LIGHTNING_BOLT;
                                                            break;
        case SPELL_MAGIC_MISSILE:
        case SPELL_SHADOW_CONJURATION_MAGIC_MISSILE:        iOHSpell = IP_CONST_ONHIT_CASTSPELL_MAGIC_MISSILE;
                                                            break;
        case SPELL_MASS_BLINDNESS_AND_DEAFNESS:             iOHSpell = IP_CONST_ONHIT_CASTSPELL_MASS_BLINDNESS_AND_DEAFNESS;
                                                            break;

        //Slightly odd behavior.  The damage the arrow does will turn the initial
        //target hostile again, but surrounding targets may remain affected.
        case SPELL_MASS_CHARM:                              iOHSpell = IP_CONST_ONHIT_CASTSPELL_MASS_CHARM;
                                                            break;

        case SPELL_MELFS_ACID_ARROW:
        case SPELL_GREATER_SHADOW_CONJURATION_ACID_ARROW:   iOHSpell = IP_CONST_ONHIT_CASTSPELL_MELFS_ACID_ARROW;
                                                            break;
        case SPELL_MESTILS_ACID_BREATH:                     iOHSpell = IP_CONST_ONHIT_CASTSPELL_MESTILS_ACID_BREATH;
                                                            break;

        //The default Meteor Swarm will center on the caster, not the target.
        //Fairly odd, when observed, so I've disabled it.
        //You can re-enable it by uncommenting the two lines.
        //case SPELL_METEOR_SWARM:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_METEOR_SWARM;
        //                                                    break;

        case SPELL_MIND_FOG:                                iOHSpell = IP_CONST_ONHIT_CASTSPELL_MIND_FOG;
                                                            break;
        case SPELL_NEGATIVE_ENERGY_BURST:                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_NEGATIVE_ENERGY_BURST;
                                                            break;
        case SPELL_PHANTASMAL_KILLER:                       iOHSpell = IP_CONST_ONHIT_CASTSPELL_PHANTASMAL_KILLER;
                                                            break;
        case SPELL_POISON:                                  iOHSpell = IP_CONST_ONHIT_CASTSPELL_POISON;
                                                            break;
        case SPELL_POWER_WORD_KILL:                         iOHSpell = IP_CONST_ONHIT_CASTSPELL_POWER_WORD_KILL;
                                                            break;
        case SPELL_POWER_WORD_STUN:                         iOHSpell = IP_CONST_ONHIT_CASTSPELL_POWER_WORD_STUN;
                                                            break;
        case SPELL_QUILLFIRE:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_QUILLFIRE;
                                                            break;
        case SPELL_SCARE:                                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_SCARE;
                                                            break;
        case SPELL_SCINTILLATING_SPHERE:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_SCINTILLATING_SPHERE;
                                                            break;
        case SPELL_SEARING_LIGHT:                           iOHSpell = IP_CONST_ONHIT_CASTSPELL_SEARING_LIGHT;
                                                            break;
        case SPELL_SILENCE:                                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_SILENCE;
                                                            break;

        //OnHitCastSpell property 2DA problem.  Won't add property to item.
        //case SPELL_SLAY_LIVING:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_SLAY_LIVING;
        //                                                    break;

        //Doesn't really work right, apparently suffering from the same thing
        //that makes the OnHit: Sleep ability not work.  The sleep is applied
        //before the damage from the attack, waking the target immediately.
        //However, since this is an AOE spell, other targets may be affected,
        //and they won't be awakened by damage from the arrow.
        case SPELL_SLEEP:                                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_SLEEP;
                                                            break;

        case SPELL_SLOW:                                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_SLOW;
                                                            break;
        case SPELL_SOUND_BURST:                             iOHSpell = IP_CONST_ONHIT_CASTSPELL_SOUND_BURST;
                                                            break;
        case SPELL_SPIKE_GROWTH:                            iOHSpell = IP_CONST_ONHIT_CASTSPELL_SPIKE_GROWTH;
                                                            break;
        case SPELL_STINKING_CLOUD:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_STINKING_CLOUD;
                                                            break;
        case SPELL_STONE_TO_FLESH:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_STONE_TO_FLESH;
                                                            break;
        case SPELL_STONEHOLD:                               iOHSpell = IP_CONST_ONHIT_CASTSPELL_STONEHOLD;
                                                            break;

        //spells.2da file problem.  Can't be targetted on an item, only self.
        //Re-enable if you change target types for the spell.
        //case SPELL_STORM_OF_VENGEANCE:                      iOHSpell = IP_CONST_ONHIT_CASTSPELL_STORM_OF_VENGEANCE;
        //                                                    break;

        case SPELL_SUNBEAM:                                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_SUNBEAM;
                                                            break;
        case SPELL_SUNBURST:                                iOHSpell = IP_CONST_ONHIT_CASTSPELL_SUNBURST;
                                                            break;
        case SPELL_TASHAS_HIDEOUS_LAUGHTER:                 iOHSpell = IP_CONST_ONHIT_CASTSPELL_TASHAS_HIDEOUS_LAUGHTER;
                                                            break;
        case SPELL_UNDEATH_TO_DEATH:                        iOHSpell = IP_CONST_ONHIT_CASTSPELL_UNDEATH_TO_DEATH;
                                                            break;
        case SPELL_UNDEATHS_ETERNAL_FOE:                    iOHSpell = IP_CONST_ONHIT_CASTSPELL_UNDEATHS_ETERNAL_FOE;
                                                            break;

        //Making this work will require changes to the Vampiric Touch spell
        //script.  The 2DA file is fine.
        //case SPELL_VAMPIRIC_TOUCH:                          iOHSpell = IP_CONST_ONHIT_CASTSPELL_VAMPIRIC_TOUCH;
        //                                                    break;

        case SPELL_WAIL_OF_THE_BANSHEE:                     iOHSpell = IP_CONST_ONHIT_CASTSPELL_WAIL_OF_THE_BANSHEE;
                                                            break;

        //The 2DA entry is broken.  No ability is added to the arrow.  Once that
        //is fixed, this should work very well.
        //case SPELL_WALL_OF_FIRE:
        //case SPELL_SHADES_WALL_OF_FIRE:             iOHSpell = IP_CONST_ONHIT_CASTSPELL_WALL_OF_FIRE;
        //                                            break;

        case SPELL_WEB:
        case SPELL_GREATER_SHADOW_CONJURATION_WEB:          iOHSpell = IP_CONST_ONHIT_CASTSPELL_WEB;
                                                            break;
        case SPELL_WEIRD:                                   iOHSpell = IP_CONST_ONHIT_CASTSPELL_WEIRD;
                                                            break;
        case SPELL_WORD_OF_FAITH:                           iOHSpell = IP_CONST_ONHIT_CASTSPELL_WORD_OF_FAITH;
                                                            break;

        //Spell is a self buff.  Doesn't fit for imbueing on an arrow.
        //Re-enable by uncommenting the two lines.
        //case SPELL_WOUNDING_WHISPERS:                       iOHSpell = IP_CONST_ONHIT_CASTSPELL_WOUNDING_WHISPERS;
        //                                                    break;

        //New spells can be added, but editing to the 2DA file controlling
        //OnHitCastSpell properties would be needed.  Once that is done, simply
        //add new cases akin to what has already been laid out.
    }

    return iOHSpell;
}
