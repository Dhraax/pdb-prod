// 5.3 changed public cd key to player name
#include "hc_inc_pwdb_func"

void main()
{
  object oRespawner = OBJECT_SELF;
  string sID=GetName(oRespawner, TRUE)+GetPCPlayerName(oRespawner);
  int iConPen ;
  iConPen = GetPersistentInt(GetModule(),"CONPEN"+sID);
  effect eRessickness;
  eRessickness = EffectAbilityDecrease ( ABILITY_CONSTITUTION, iConPen);
  ApplyEffectToObject( DURATION_TYPE_PERMANENT,  SupernaturalEffect(eRessickness), oRespawner );
}
