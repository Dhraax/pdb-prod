#include "henchman_inv"

void main()
{
  object oPC = GetLastSpeaker();

  //Guardamos el que corresponda
    if(GetResRef(OBJECT_SELF) == "ow_sum_barb" ) GuardarOrcBarb(oPC);
    else if (GetResRef(OBJECT_SELF) == "ow_sum_fght" ) GuardarOrcFght(oPC);
    else if (GetResRef(OBJECT_SELF) == "ow_sum_axe" ) GuardarOrcAxe(oPC);
    else if (GetResRef(OBJECT_SELF) == "ow_sum_sham" ) GuardarOrcSham(oPC);
    else if(GetResRef(OBJECT_SELF) == "conj_ladsombras" )  GuardarLadron1(oPC);
    else if(GetResRef(OBJECT_SELF) == "conj_ladsombras2" ) GuardarLadron2(oPC);
    else if(GetResRef(OBJECT_SELF) == "conj_ladsombras3" )  GuardarLadron3(oPC);
    else if(GetResRef(OBJECT_SELF) == "conj_lider" )  GuardarLiderazgo(oPC);
    else if(GetResRef(OBJECT_SELF) == "conj_mdl" )  GuardarMDL(oPC);
}

