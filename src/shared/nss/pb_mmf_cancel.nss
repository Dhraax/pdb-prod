void main()
{
    object oPC = OBJECT_SELF;
    effect eFirst = GetFirstEffect(oPC);
    while(GetIsEffectValid(eFirst))
    {
        if(GetEffectTag(eFirst) == "POLY_HP_BONUS" || GetEffectSpellId(eFirst)== 412 || GetEffectTag(eFirst) == "MMF_MOV_SPEED" ||
        GetStringLeft(GetEffectTag(eFirst),13) == "MDF_POLYMORPH") RemoveEffect(oPC,eFirst);
        eFirst = GetNextEffect(oPC);
    }
}
