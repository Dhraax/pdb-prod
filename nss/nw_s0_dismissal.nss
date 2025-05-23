//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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

// End of Spell Cast Hook


    //Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    int nSpellDC;
    int oCasterLvl =GetCasterLevel(OBJECT_SELF);
    object oArea = GetArea(OBJECT_SELF);
    int nArea = 0;
        nArea = GetLocalInt(oArea,"tPlanar");

    //Get the first object in the are of effect
    //object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    object oTarget = GetSpellTargetObject();
    //while(GetIsObjectValid(oTarget))
    //{
        int oTargetHD =GetHitDice(oTarget);
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        //Determine correct save
        nSpellDC = (GetSpellSaveDC()+ GetChangesToSaveDC(OBJECT_SELF)) - oTargetHD + oCasterLvl;
        //Is that master valid and is he an enemy

        if (GetHasSpellEffect(990, oTarget) == TRUE)
              {
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     SendMessageToPC(OBJECT_SELF,"*Esta criatura se encuentra anclada, no puede ser expulsada!*");
                     return;
              }

        if((GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget) || (GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER) ||(GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL)||(GetRacialType(oTarget) == RACIAL_TYPE_FEY))
        {
            //Is the creature a summoned associate
            //if(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget )
            //{
              SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));

              if ((nArea==1) && (GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) != oTarget))     //si estas en un area planar no puede ser expulsado.
              {
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     SendMessageToPC(OBJECT_SELF,"*No puedes expulsar a esta criatura de este plano!*");
                     return;
              }
              else
              {
                //Make SR and will save checks
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                   if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                   {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     //DestroyObject(oTarget, 0.5);
                     if ((CanCreatureBeDestroyed(oTarget) == TRUE) && (GetIsPC(oTarget) != TRUE))
                     {
                      /*//bugfix: Simply destroying the object won't fire it's OnDeath script.
                      //Which is bad when you have plot-specific things being done in that
                      //OnDeath script... so lets kill it.
                      effect eKill = EffectDamage(GetCurrentHitPoints(oTarget)+10);
                      //just to be extra-sure... :)
                      effect eDeath = EffectDeath(FALSE, FALSE);
                      ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);   */

                      DestroyObject(oTarget, 0.5);
                     }
                       if(GetIsPC(oTarget) == TRUE)
                     {
                       object   oWaypoint = GetWaypointByTag("planodelasombra");   //posada planar
                       location lLocation = GetLocation(oWaypoint);
                       AssignCommand(oTarget, JumpToLocation(lLocation));
                       SendMessageToPC(oTarget,"*Has sido expulsado de ese plano*");
                     }
                   }
                }
              }
            //}
        //}
        //Get next creature in the shape.
        //oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
       }
       if ((nArea==1) && (!GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER||RACIAL_TYPE_ELEMENTAL||RACIAL_TYPE_FEY))
       {
                //Make SR and will save checks
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                   if (!MySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                   {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     //DestroyObject(oTarget, 0.5);
                     if ((CanCreatureBeDestroyed(oTarget) == TRUE) && (GetIsPC(oTarget) != TRUE))
                     {
                      /*//bugfix: Simply destroying the object won't fire it's OnDeath script.
                      //Which is bad when you have plot-specific things being done in that
                      //OnDeath script... so lets kill it.
                      effect eKill = EffectDamage(GetCurrentHitPoints(oTarget)+10);
                      //just to be extra-sure... :)
                      effect eDeath = EffectDeath(FALSE, FALSE);
                      ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget);
                      ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget); */
                      
                      DestroyObject(oTarget, 0.5);
                     }
                       if(GetIsPC(oTarget) == TRUE)
                     {
                       object   oWaypoint;
                       int nChance = Random(99)+1;

                            if ( nChance = 1 )    {oWaypoint = GetWaypointByTag("WP_banishcorrosivo");}              //corrosivos
                       else if (1 < nChance <10 ) {oWaypoint = GetWaypointByTag("WP_Infratrans7");}                  //infra
                       else if (10<= nChance <20) {oWaypoint = GetWaypointByTag("WP_esm_alcant_in");}                //alcantarillas esmeltaran
                       else if (20<= nChance <30) {oWaypoint = GetWaypointByTag("wp_destcuevama");}                  //cueva malar
                       else if (30<= nChance <40) {oWaypoint = GetWaypointByTag("WP_tyr_montecraneospasocolmillo");} //montecraneos
                       else if (40<= nChance <50) {oWaypoint = GetWaypointByTag("WP_banishbluedragon");}             //dragon azul
                       else if (50<= nChance <60) {oWaypoint = GetWaypointByTag("cs_aracnoida");}                    //cueva aranas
                       else if (60<= nChance <70) {oWaypoint = GetWaypointByTag("WP_banishbaths");}                  //torre selune
                       else if (70<= nChance <80) {oWaypoint = GetWaypointByTag("crs_vmp_brynley");}                 //Costa Brynley
                       else if (80<= nChance <90) {oWaypoint = GetWaypointByTag("WP_tyr_bifsurpursH");}              //bosques perdidos
                       else if (90<= nChance <95) {oWaypoint = GetWaypointByTag("WP_CS_MOUSE3_03");}                 //loma ghallar
                       else if (95<= nChance <100){oWaypoint = GetWaypointByTag("pn_wpweldazh");}                    //mitharan
                       else if ( nChance = 100 )  {oWaypoint = GetWaypointByTag("WP_desterrar");}                    //planar
                       location lLocation = GetLocation(oWaypoint);
                       AssignCommand(oTarget, JumpToLocation(lLocation));
                       SendMessageToPC(oTarget,"*Has sido expulsado de ese plano*");

                     }
                   }
                }

       }
	   DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
