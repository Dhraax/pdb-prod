//::////////////////////////////////////////////////////////////////////////:://
//:: HCR 3.3 GUION ESTANDAR ON_ACTIVATE_ITEM */                             :://
//:: Modificado por Monti, servidor Puerta de Baldur                        :://
//::////////////////////////////////////////////////////////////////////////:://

#include "hc_inc"

void CrearPuerta(location lPoint, object oPC)
{
  lPoint = Location(GetArea(oPC), GetPositionFromLocation(lPoint) + Vector(0.0, 0.0, -0.5), GetFacingFromLocation(lPoint));
  object oPuerta = CreateObject(OBJECT_TYPE_PLACEABLE,"puertamansion",lPoint);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE), oPuerta);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_LIGHT_BLUE_20), oPuerta);
  SetLocalObject(oPuerta, "CASTER", oPC);
}

void main()
{
  object oItem = GetItemActivated();
  object oUser = GetItemActivator();
  object oOther = GetItemActivatedTarget();
  string sItemTag = GetTag(oItem);

  // HABILIDAD DE CURACION
  if(sItemTag == "hc_healkit" || sItemTag == "HC_HEAL_NODROP")
  {
      SetLocalObject(oUser,"OTHER",oOther);
      SetLocalObject(oUser,"ITEM",oItem);
      ExecuteScript("hc_act_healkit",oUser);
      return;
  }

  // BASTON MAGOS ENCAPUCHADOS
  if(sItemTag ==  "qk_bastonmagos")
  {
      if(GetLocalInt(GetArea(oUser), "NOTELEPORT"))
      {
          FloatingTextStringOnCreature("<cþ<<>Una gran fuerza te impide usar este conjuro aquí.</c>", oUser);
          return;
      }

      else if(GetTag(GetArea(oUser)) == "SANATORIO")
      {
          FloatingTextStringOnCreature("<cþ<<>¡No puedes usar tu bastón del mago encapuchado cuando te encuentras en el sanatorio!</c>", oUser);
          return;
      }
      else
      {
          location lLoc = GetItemActivatedTargetLocation();
          effect eSum = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2);
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSum,lLoc);
          DelayCommand(1.0, CrearPuerta(lLoc, oUser));
          return;
      }
  }

  SetLocalObject(oUser,"OTHER",oOther);
  SetLocalObject(oUser,"ITEM",oItem);
  SetLocalString(oUser,"TAG",sItemTag);
  ExecuteScript("hc_act_others",oUser);
}
