int CheckBlighterSpellcast() {
    object oItem = GetSpellCastItem();
    if(oItem != OBJECT_INVALID) return TRUE;
    int nSpellId = GetSpellId();
    int bDruid = GetLastSpellCastClass() == CLASS_TYPE_DRUID;
    if(bDruid == FALSE) return TRUE;
    string sLvl = Get2DAString("spells","Druid",nSpellId);
    int bDruidSpell = sLvl != "";
    if(bDruidSpell == TRUE) {
        int bBlighter = GetLevelByClass(CLASS_TYPE_BLIGHTER, OBJECT_SELF) > 0;
        int nLvl = StringToInt(sLvl);
        if(nSpellId >= 1184 && nSpellId <= 1310) {
            if(!bBlighter) {
                 FloatingTextStringOnCreature("Un druida no puede lanzar conjuros de asolador.", OBJECT_SELF, FALSE);
                 return FALSE;
            }
            /*if(nLvl > GetLevelByClass(CLASS_TYPE_BLIGHTER, OBJECT_SELF)) {
                 FloatingTextStringOnCreature("Solo puedes lanzar conjuros de nivel igual o inferior a tu nivel de asolador", OBJECT_SELF, FALSE);
                 return FALSE;
            }*/
        } else {
            if(bBlighter) {
                if(nSpellId < 800) {
                    FloatingTextStringOnCreature("Un asolador no puede lanzar conjuros de druida.", OBJECT_SELF, FALSE);
                    return FALSE;
                } /*else if(nLvl > GetLevelByClass(CLASS_TYPE_BLIGHTER, OBJECT_SELF)) {
                    FloatingTextStringOnCreature("Solo puedes lanzar conjuros de nivel igual o inferior a tu nivel de asolador", OBJECT_SELF, FALSE);
                    return FALSE;
                }*/
            } /*else if(nLvl > GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF)/2) {
                 FloatingTextStringOnCreature("Solo puedes lanzar conjuros de nivel igual o inferior a la mitad de tu nivel de druida", OBJECT_SELF, FALSE);
                 //FloatingTextStringOnCreature("Current max: " + ((GetLevelByClass(CLASS_TYPE_DRUID, OBJECT_SELF)/2-1)), OBJECT_SELF, FALSE);
                 return FALSE;
            }*/
        }
    }
    return TRUE;

}