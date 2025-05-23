#include "pb_nivellanzador"

void setAOE(location lTarget, int nValue){
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lTarget);
    string sVarName = "AoEDispellCD";
    if(GetIsObjectValid(oAOE)){
        location lAOE = GetLocation(oAOE);
        if(GetDistanceBetweenLocations(lTarget, lAOE) == 0.0){
            //Guardamos el nivel de lanzador y el tipo de urdimbre utilizada.
            SetLocalInt(oAOE, sVarName, nValue);
            SetLocalInt(oAOE, "SHADOW_WEAVE_AOE", GetHasFeat(1354));
            SetLocalInt(oAOE, "TENACIOUS_MAGIC_AOE", GetHasFeat(1355));
            SetLocalString(oAOE, "SCHOOL_OF_MAGIC_AOE", Get2DAString("spells", "School", GetSpellId()));
        }
    }
}

void main()
{
    /*
        Script encargado de obtener el nivel de lanzador real y guardarlo
        en una variable local para poder ser leido por los disipar.
    */
    object oTarget = GetSpellTargetObject();
    location lTarget = GetSpellTargetLocation();
    int nValue = GetTotalCasterLevel(OBJECT_SELF);
    string sVarName = GetName(OBJECT_SELF);
    sVarName += IntToString(GetSpellId());

    //Guardamos el nivel de lanzador y si se lanzo con la dote magia tenaz.
    SetLocalInt(oTarget, sVarName, nValue);
    SetLocalInt(oTarget, "SHADOW_WEAVE_"+sVarName, GetHasFeat(1354));
    SetLocalInt(oTarget, "TENACIOUS_MAGIC_"+sVarName, GetHasFeat(1355));
    /*
        Dejamos que se ejecute el conjuro y luego revisamos
        si es de area de efecto.
    */
    DelayCommand(2.0, setAOE(lTarget, nValue));
}
