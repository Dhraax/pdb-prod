#include "x2_inc_switches"
#include "mti_libreria"

void crearAlarma(object oPC, location lLugar){
   object oAlarma= CreateObject(OBJECT_TYPE_CREATURE, "sute_bicho_alarma", lLugar, FALSE);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectTrueSeeing(), oAlarma);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectEthereal(), oAlarma);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectInvisibility(INVISIBILITY_TYPE_IMPROVED), oAlarma);
   SetLocalObject(oAlarma, "PCCREADOR", oPC);
}

void main()
{

    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE){
       object oPC= GetItemActivator();
       if (GetIsDM(oPC)==FALSE)
       {

            location lLugar= GetLocation(oPC);

            int iDuracion= GetLevelByClass(CLASS_TYPE_RANGER, oPC);
            if (GetLevelByClass(CLASS_TYPE_BARD, oPC)>iDuracion){
                  iDuracion= GetLevelByClass(CLASS_TYPE_BARD, oPC);
            }
            if (GetLevelByClass(CLASS_TYPE_SORCERER, oPC)>iDuracion){
                  iDuracion= GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
            }
            if (GetLevelByClass(CLASS_TYPE_WIZARD, oPC)>iDuracion){
                  iDuracion= GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
            }

            effect eVis = EffectVisualEffect(VFX_DUR_GLYPH_OF_WARDING);
            AssignCommand(oPC,ActionCastFakeSpellAtObject(SPELL_SHIELD_OF_FAITH,oPC,PROJECTILE_PATH_TYPE_DEFAULT));
            DelayCommand(8.0,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lLugar, 30.0f));
            DelayCommand(38.0,crearAlarma(oPC, lLugar));
        }

  }
}
