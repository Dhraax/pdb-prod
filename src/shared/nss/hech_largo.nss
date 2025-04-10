#include "henchman_inv"
#include "x0_i0_henchman"

void main()
{

    object oPC = GetLastSpeaker();
    object oMaster = GetMaster(OBJECT_SELF);
    object oHench = OBJECT_SELF;
    effect eSummon = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);

    //Guardamos el que corresponda
    if(GetResRef(OBJECT_SELF) == "ow_sum_barb" ) {GuardarOrcBarb(oPC); IncrementRemainingFeatUses(oPC, 1381);}
    if(GetResRef(OBJECT_SELF) == "ow_sum_fght" ){GuardarOrcFght(oPC); IncrementRemainingFeatUses(oPC, 1380);}
    if(GetResRef(OBJECT_SELF) == "ow_sum_axe" ) {GuardarOrcAxe(oPC); IncrementRemainingFeatUses(oPC, 1379);}
    if(GetResRef(OBJECT_SELF) == "ow_sum_sham" ) {GuardarOrcSham(oPC); IncrementRemainingFeatUses(oPC, 1436);}
    if(GetResRef(OBJECT_SELF) == "conj_ladsombras" ) {GuardarLadron1(oPC); IncrementRemainingFeatUses(oPC, 1284);}
    if(GetResRef(OBJECT_SELF) == "conj_ladsombras2" ) {GuardarLadron2(oPC); IncrementRemainingFeatUses(oPC, 1289);}
    if(GetResRef(OBJECT_SELF) == "conj_ladsombras3" ) {GuardarLadron3(oPC); IncrementRemainingFeatUses(oPC, 1290);}
    if(GetResRef(OBJECT_SELF) == "conj_lider" ) {GuardarLiderazgo(oPC); IncrementRemainingFeatUses(oPC, 1550); }
    if(GetResRef(OBJECT_SELF) == "conj_mdl" ) {GuardarMDL(oPC); IncrementRemainingFeatUses(oPC, 1555);}

   //Lo destruimos
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eSummon, oHench);
   ChangeToStandardFaction(oHench, STANDARD_FACTION_DEFENDER);
   RemoveHenchman(oPC, oHench);
   DelayCommand(1.0, SetIsDestroyable(TRUE,FALSE,FALSE));
   DelayCommand(2.0, DestroyObject(OBJECT_SELF));


}






