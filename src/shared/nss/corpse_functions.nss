#include "lib_race"

//************************************************************************
//  Lootable, raiseable Corpse script: Include file
//  Original script by Magic & He Who Watches
//  Modified by Ankh_Phoenix
//************************************************************************

//************************************************************************
// Constants
//************************************************************************
// Delay for pseudo heartbeat
const float CORPSE_CHECK_DELAY = 3.0f;
const float BAG_CHECK_DELAY = 2.0f;

//***********************************************************************
// corpse_Looting
// usedby: OnAquireItem event
// Plays bend down animation for the looter.
// Check if takeing the last item of a corpse.
//***********************************************************************
void corpse_Looting( object oLooter, object oVictim, object oItem );

//***********************************************************************
// corpse_Raiseing
// usedby: Raise/Ressurect Spellhook
// Make creature lootbale again, return items from bodybag.
//***********************************************************************
void corpse_Raiseing( object oCorpse );

//***********************************************************************
// corpse_InitializeCorpse
// usedby: OnDeath event
// Turn on the lootable, raiseable corpse for the creature.
// Creature must be set to lootable for this to work.
//***********************************************************************
void corpse_InitializeCorpse( object oCreature );

//***********************************************************************
// corpse_DestroyContents
// usedby: corpse_DestroyCorpse
// Destroyes the items in a container
//***********************************************************************
void corpse_DestroyContents( object oContainer )
{
    // Get first item in the container
    object oItem = GetFirstItemInInventory( oContainer );

    // While the item is a valid object
    while ( GetIsObjectValid( oItem ) )
    {
        // Check if it is a container. If so, destroy all in it too
        if ( GetHasInventory( oItem ) ) corpse_DestroyContents( oItem );

        // Destroy the item, and get the next one in the container
        DestroyObject( oItem );
        oItem = GetNextItemInInventory( oContainer );
    }
}

//***********************************************************************
// corpse_DestroyCorpse
// usedby: corpse_InitializeCorpse
// Destroyes the bodybag and corpse
//***********************************************************************
void corpse_DestroyCorpse( object oCorpse, int nDeadTime )
{
    // Check that corpse is a dead creature
    if ( GetIsDead( oCorpse ) )
    {
        // Check if this is the right dead time
        int nCnt_timesdead = GetLocalInt( oCorpse, "cnt_timesdead" );

        if ( ( nDeadTime == 0 ) || ( nDeadTime == nCnt_timesdead ) )
        {
            // Make the corpse destroyable
            SetIsDestroyable( TRUE );

            // Get the pointer to the bodybag
            object oBag = GetLocalObject( oCorpse, "corpse_bodybag" );

            // Check that it really point to a bag
            if ( GetIsObjectValid( oBag ) )
            {
                // Destroy every item in the bag and the bag
                corpse_DestroyContents( oBag );
                DestroyObject( oBag, 0.5f );
            }

            // Get leavebag flag
            int nFl_leavebag = GetLocalInt( oCorpse, "fl_leavebag" );

            // If should leave some remains, don't destroy items on the corpse
            if ( nFl_leavebag <= 0 ) corpse_DestroyContents( oCorpse );

            // Creamos unos huesos durante unos pocos segundos
            if(GetCreatureSize(oCorpse) == CREATURE_SIZE_TINY)
            {
                // Do nothing -- no bones for tiny creatures
            }
            else
            {
                // Create the bones
                object oBones = CreateObject(OBJECT_TYPE_PLACEABLE, "cad_huesos" + IntToString(d3()), GetLocation(oCorpse), FALSE); // Location(GetArea(OBJECT_SELF), GetPosition(oCorpse), IntToFloat(Random(361)))
                DestroyObject( oBones, 20.0f );
            }
            // Destroy the corpse, if we left items on it, they will be spawned in a bag
            DestroyObject( oCorpse, 0.5f );
        }
    }
}

//***********************************************************************
// corpse_CheckNoDrop
// usedby: corpse_AssignBag
// Pseudo heartbeat to make corpse with no loot raiseable after beeing clicked on
//***********************************************************************
void corpse_CheckNoDrop( object oCorpse )
{
    // As long as there is a corpse, set it to raiseable
    if ( GetIsObjectValid( oCorpse ) )
    {
        AssignCommand( oCorpse, SetIsDestroyable( FALSE, TRUE, TRUE ) );
        DelayCommand( CORPSE_CHECK_DELAY, corpse_CheckNoDrop( oCorpse ) );
    }
}

//***********************************************************************
// corpse_AssignBag
// usedby: corpse_InitializeCorpse
// Find the bodybag for the corpse and set a pointer to it on the corpse
//***********************************************************************
void corpse_AssignBag( object oCorpse )
{
    // Get the nearest bodybag
    object oBag = GetNearestObjectByTag( "BodyBag" );

    // If it is not a valid object, or is not placed just beneath the corpse
    // the corpse has no bodybag (happens when the creature has no dropable items)
    if ( ( !GetIsObjectValid( oBag ) ) || ( GetDistanceToObject( oBag ) > 0.0 ) )
    {
        int nFl_raiseable = GetLocalInt( oCorpse, "fl_raiseable" );

        // If should be raiseable, start a pseudo heartbeat to set it so as long
        // as there is a corpse. (looting a corpse that has no loot will reset the
        // selectable flag)
        if ( nFl_raiseable > 0 ) DelayCommand( CORPSE_CHECK_DELAY, corpse_CheckNoDrop( oCorpse ) );

        return;
    }

    // Set a pointer to the bag on the corpse
    SetLocalObject( oCorpse, "corpse_bodybag", oBag );

    // Set a pointer to the corpse on the bag
    SetLocalObject( oBag, "corpse_object", oCorpse );
}

//***********************************************************************
// corpse_CheckForBag
// usedby: corpse_Looting
// Does the same as CheckNoDrop, only for when the lootbag is emptied
//***********************************************************************
void corpse_CheckForBag( object oCorpse, object oBag )
{
    // Check that the corpse is dead
    if ( GetIsDead( oCorpse ) )
    {
        // Check if the bag is still around
        if ( GetIsObjectValid( oBag ) )
        {
            // If the bag is still around and empty, call this function again
            // probably a PC holding the bag open
            if ( !GetIsObjectValid( GetFirstItemInInventory( oBag ) ) )
            {
                DelayCommand( BAG_CHECK_DELAY, corpse_CheckForBag( oCorpse, oBag ) );
                return;
            }
        }
        else
        {
            int nFl_raiseable = GetLocalInt( oCorpse, "fl_raiseable" );
            int nFl_do_not_decay = GetLocalInt( oCorpse, "fl_do_not_decay" );

            // When looting, selectable is turned off, so if it should be raiseable turn selecable back on
            if ( nFl_raiseable > 0 ) AssignCommand( oCorpse, SetIsDestroyable( FALSE, TRUE, TRUE ) );

            else
            {
                // If Leave corpse after bag is empty, even if it is not raiseable
                if ( nFl_do_not_decay == 1 ) AssignCommand( oCorpse, SetIsDestroyable( FALSE, FALSE, FALSE ) );

                // Else destroy the corpse, since it's fully looted
                else AssignCommand( oCorpse, corpse_DestroyCorpse( oCorpse, 0 ) );
            }
        }
    }
    // Delete variable that stop from getting more than one function running at a time
    if ( oCorpse != OBJECT_INVALID )  DeleteLocalInt( oCorpse, "corpse_check_for_bag" );
}

//***********************************************************************
// corpse_Looting
// usedby: OnAquireItem event
// Check if takeing the last item of a corpse
//***********************************************************************
void corpse_Looting( object oLooter, object oVictim, object oItem )
{
    // If the item was taken from a bodybag
    if ( GetIsObjectValid( oVictim ) && ( GetTag( oVictim ) == "BodyBag" ) )
    {
        // Play a bend down animation for the looter
        AssignCommand( oLooter, ActionPlayAnimation( ANIMATION_LOOPING_GET_LOW, 1.0, 6.0 ) );

        // Destruye las copias equipadas
        object oCopiaSaqueo = GetLocalObject(oItem, "COPIASAQUEO");
        if(GetIsObjectValid(oCopiaSaqueo))
        {
            DestroyObject(oCopiaSaqueo);
            DeleteLocalObject(oItem, "COPIASAQUEO");
        }

        // Check if the item taken was the last one in the bag
        if ( !GetIsObjectValid( GetFirstItemInInventory( oVictim ) ) )
        {
            // If it was the last item, check for when the bag dissapears and then
            // make the corpse selectable if it is raiseable
            object oCorpse = GetLocalObject( oVictim, "corpse_object" );

            // If there is a corpse, and it is not beeing checked allready,
            // Start check function
            if ( GetIsObjectValid( oCorpse ) && !GetLocalInt( oCorpse, "corpse_check_for_bag" ) )
            {
                SetLocalInt( oCorpse, "corpse_check_for_bag", TRUE );
                corpse_CheckForBag( oCorpse, oVictim );
            }
        }
    }
}

//***********************************************************************
// corpse_ReturnItems
// usedby: corpse_Raiseing
// Put all items in bodybag, back on creature
//***********************************************************************
void corpse_ReturnItems( object oCreature, object oContainer )
{
    object oNewItem;
    object oItem = GetFirstItemInInventory( oContainer );

    // Cycle through the items in the bodybag
    while ( GetIsObjectValid( oItem ) )
    {
            // As long as it is not any of the fake items
            // Move item from the bag to the creature
            oNewItem = CopyObject( oItem, GetLocation( oContainer ), oCreature );
            DestroyObject( oItem, 0.1f );

            // If it was a equiped item
            if ( ( GetLocalObject( oNewItem, "corpse_former_owner" ) == oCreature ) )
            {
                // Equip it back on where it was
                int slot = GetLocalInt( oNewItem, "corpse_inv_slot" );
                AssignCommand( oCreature, ActionEquipItem( oNewItem, slot ) );
                AssignCommand( oCreature, DeleteLocalObject( oNewItem, "corpse_former_owner" ) );
                AssignCommand( oCreature, DeleteLocalInt( oNewItem, "corpse_inv_slot" ) );
            }
        oItem = GetNextItemInInventory( oContainer );
    }

    // Destroy the bodybag, when it is emptied
    DestroyObject( oContainer );
}

//***********************************************************************
// corpse_Raiseing
// usedby: Raise/Ressurect Spellhook
// Make creature lootbale again, return items from bodybag
//***********************************************************************
void corpse_Raiseing( object oCorpse )
{
    // Get the bodybag of the corpse
    object oBag = GetLocalObject( oCorpse, "corpse_bodybag" );

    // Check that the bag still exists. If so return the items to the creature inventory
    if ( GetIsObjectValid( oBag ) ) corpse_ReturnItems( oCorpse, oBag );

    // If Creature is supposed to be lootable, set lootable
    if ( GetLocalInt( oCorpse, "fl_lootable" ) == 1 ) AssignCommand( oCorpse, SetLootable( oCorpse, TRUE ) );
}

//***********************************************************************
// corpse_InitializeCorpse
// usedby: OnDeath event
// Turn on the lootable, raiseable corpse
//***********************************************************************
void corpse_InitializeCorpse( object oCreature )
{
    // If the corpse is lootable
    if ( GetLootable( oCreature ) )
    {
        // Save a record of each item equipped, so can equip them back on
        // if get raised/ressurected
        int nCount;
        for ( nCount = 0; nCount <= NUM_INVENTORY_SLOTS; nCount++ )
        {
            object oItem = GetItemInSlot( nCount, oCreature );
            if ( GetIsObjectValid( oItem ) )
            {
                SetLocalObject( oItem, "corpse_former_owner", oCreature );
                SetLocalInt( oItem, "corpse_inv_slot", nCount );
            }
        }

        // Seatch for the bodybag, and save a pointer to it if found
        DelayCommand( 1.0, corpse_AssignBag( oCreature ) );
        // Set so that raise/ressurection know to make the creature lootable again
        SetLocalInt( oCreature, "fl_lootable", 1 );
    }

  // Correccion del bug de Bioware que imposibilitaba saquear objetos
  // indesprendibles equipados en torso, cabeza y manos
  object oCabeza = GetItemInSlot(INVENTORY_SLOT_HEAD);
  object oTorso = GetItemInSlot(INVENTORY_SLOT_CHEST);
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
  object oManoDer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  if(GetIsObjectValid(oCabeza) && GetDroppableFlag(oCabeza))
  {
      object oCopiaCabeza = CopyItem(oCabeza, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaCabeza, "COPIASAQUEO", oCabeza);
      SetDroppableFlag(oCabeza, FALSE);
  }
  if(GetIsObjectValid(oTorso) && GetDroppableFlag(oTorso))
  {
      object oCopiaTorso = CopyItem(oTorso, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaTorso, "COPIASAQUEO", oTorso);
      SetDroppableFlag(oTorso, FALSE);
  }
  if(GetIsObjectValid(oManoIzq) && GetDroppableFlag(oManoIzq))
  {
      object oCopiaManoIzq = CopyItem(oManoIzq, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaManoIzq, "COPIASAQUEO", oManoIzq);
      SetDroppableFlag(oManoIzq, FALSE);
  }
  if(GetIsObjectValid(oManoDer) && GetDroppableFlag(oManoDer))
  {
      object oCopiaManoDer = CopyItem(oManoDer, OBJECT_SELF, TRUE);
      SetLocalObject(oCopiaManoDer, "COPIASAQUEO", oManoDer);
      SetDroppableFlag(oManoDer, FALSE);
  }

    // Get Variables
    int nFl_raiseable = GetLocalInt( oCreature, "fl_raiseable" );
    int nFl_do_not_decay = GetLocalInt( oCreature, "fl_do_not_decay" );
    int nFl_leavebag = GetLocalInt( oCreature, "fl_leavebag" );

    // Check Area defaults
    if ( nFl_raiseable == 0 )
    {
        nFl_raiseable = GetLocalInt( GetArea( oCreature ), "fl_raiseable" );
        SetLocalInt( oCreature, "fl_raiseable", nFl_raiseable );
    }
    if ( nFl_do_not_decay == 0 )
    {
        nFl_do_not_decay = GetLocalInt( GetArea( oCreature ), "fl_do_not_decay" );
        SetLocalInt( oCreature, "fl_do_not_decay", nFl_do_not_decay );
    }
    if ( nFl_leavebag == 0 )
    {
        nFl_leavebag = GetLocalInt( GetArea( oCreature ), "fl_leavebag" );
        SetLocalInt( oCreature, "fl_leavebag", nFl_leavebag );
    }

    // Check if should be raiseable
    if ( nFl_raiseable > 0 ) AssignCommand( oCreature, SetIsDestroyable( FALSE, TRUE, TRUE ) );

    // If lootable, but not raiseable
    else if ( GetLootable( oCreature ) ) AssignCommand( oCreature, SetIsDestroyable( FALSE, FALSE, TRUE ) );

    // If not lootable, or raiseable (should just destroy the corpse ?)
    else  AssignCommand( oCreature, SetIsDestroyable( FALSE, FALSE, FALSE ) );

    // This fades corpse out
    if ( nFl_do_not_decay <= 0 )
    {
        // Numbers of times creature has died
        int nCnt_timesdead = GetLocalInt( oCreature, "cnt_timesdead" );
        nCnt_timesdead++;
        SetLocalInt( oCreature, "cnt_timesdead", nCnt_timesdead );

        // Decaytime
        float tFl_decaytime = GetLocalFloat( oCreature, "fl_decaytime" );

        // If decaytime is 0.0, check Area default
        if ( tFl_decaytime == 0.0 )
        {
            tFl_decaytime = GetLocalFloat( GetArea( oCreature ), "fl_decaytime" );

            // If still 0.0 set default time of 80 seconds ( 1 min )
            if ( tFl_decaytime == 0.0 )tFl_decaytime = 80.0;
        }

        // Sangre, marca chamuscada o fuego al morir...
        object oCorpseBlood;
        location lBloodLoc = GetLocation(OBJECT_SELF); //get original location for placing blood spot

        if (GetCreatureSize(OBJECT_SELF) == CREATURE_SIZE_TINY)
        {
            // Do nothing -- no bloodspot for tiny creatures
        }
        else
        {
            // Determine if scorch, flame, or bloodspot should appear
            int nFireDam = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
            int nElecDam = GetDamageDealtByType(DAMAGE_TYPE_ELECTRICAL);
            int nTotDam = GetTotalDamageDealt();
            int nMaxHP = GetMaxHitPoints();

            // If 1/3 or more of the damage is due to fire or electricity...
            // (only the final damage that actually killed the creature is
            // considered; tracking the cumulative damage taken would require
            // altering the default OnDamaged script for every creature,
            // which is not desirable)
            if ((nFireDam >= (nTotDam/3)) || (nElecDam >= (nTotDam/3)))
            {
                // If massive fire or electricity damage, spawn a small flame
                // which turns into a scorch mark after tFl_decaytime seconds
                // ("massive" means >= max HP)
                if(nFireDam >= nMaxHP)
                {
                    oCorpseBlood = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_flamesmall", lBloodLoc, FALSE);
                    DestroyObject(oCorpseBlood, tFl_decaytime);
                }
                else if(nElecDam >= nMaxHP)
                {
                    oCorpseBlood = CreateObject(OBJECT_TYPE_PLACEABLE, "zep_bflame003", lBloodLoc, FALSE);
                    DestroyObject(oCorpseBlood, tFl_decaytime);
                }
                else
                {
                    // Otherwise, spawn a scorch mark
                    oCorpseBlood = CreateObject(OBJECT_TYPE_PLACEABLE, "cad_marcachamus", lBloodLoc, FALSE);
                    DestroyObject(oCorpseBlood, tFl_decaytime);
                }
            }
            else
            {
                // Not enough (or zero) fire/electrical damage, so just spawn bloodspot (or do nothing for Undead/Constructs/Elementals)
                if (!PB_Race_GetIsUndead(OBJECT_SELF) && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_CONSTRUCT && GetRacialType(OBJECT_SELF) != RACIAL_TYPE_ELEMENTAL)
                {
                    oCorpseBlood = CreateObject(OBJECT_TYPE_PLACEABLE, "zep_splat002", lBloodLoc, FALSE);
                    DestroyObject(oCorpseBlood, tFl_decaytime);
                }
            }
        }

        DelayCommand( tFl_decaytime, corpse_DestroyCorpse( oCreature, nCnt_timesdead ) );
    }
}
