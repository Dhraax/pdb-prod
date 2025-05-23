void main()
{


   ////////////////////////NIVELES////////////////////////////
   object oContenedor = GetObjectByTag("spawn_encuentros");
   location lSpawn = GetLocation(GetWaypointByTag("spawn_creatura"));
   int iNivel = GetLocalInt(oContenedor, "iNivel");
   string oRes = GetLocalString(oContenedor,"Res");
   CreateObject(OBJECT_TYPE_CREATURE, oRes, lSpawn, FALSE);
   object oPC=GetPCSpeaker();
   object oTarget = GetObjectByTag(GetLocalString(oContenedor, "Raza"));
   SetLocalInt(oContenedor, "oActivo", 1);
   effect eAOE = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lSpawn);
   int iClass = GetClassByPosition(1,oTarget);
   DelayCommand(0.5,AddHenchman(oPC,oTarget));
   DelayCommand(1.0,OpenInventory(oTarget, oPC));
   int iLevel = GetHitDice(oTarget);

/////////////////////CLASE DE ARMADURA (ESQUIVA)//////////////////////////
   /*  if(GetLocalInt(oContenedor,"iAc") < 0){
   int iCA = GetLocalInt(oContenedor,"iCA");
   effect eAc = SupernaturalEffect(EffectACDecrease(iCA+10, AC_DODGE_BONUS));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAc, oTarget);
   }
   else
   {*/
   /// CANTIDAD DE ATAQUES/////////
   int iAttq = GetLocalInt(oContenedor,"Ataques");
   effect eAttf = EffectModifyAttacks(iAttq);
   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAttf,oTarget);
   //INCREMENTO DE CA
   effect eAc = SupernaturalEffect(EffectACIncrease(GetLocalInt(oContenedor,"iCA")-10, AC_DODGE_BONUS));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAc, oTarget);
   //}
   ///////////////////////////CARACTERÍSTICAS///////////////////////////////

   int iFue = GetLocalInt(oContenedor,"iFue");
   effect eFue = SupernaturalEffect(EffectAbilityIncrease(ABILITY_STRENGTH,iFue));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eFue, oTarget);

   int iDes = GetLocalInt(oContenedor,"iDes");
   effect eDes = SupernaturalEffect(EffectAbilityIncrease(ABILITY_DEXTERITY,iDes));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eDes, oTarget);

   int iCon = GetLocalInt(oContenedor,"iCon");
   effect eCon = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CONSTITUTION,iCon));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oTarget);

   int iInt = GetLocalInt(oContenedor,"iInt");
   effect eInt = SupernaturalEffect(EffectAbilityIncrease(ABILITY_INTELLIGENCE,iInt));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eInt, oTarget);

   int iSab = GetLocalInt(oContenedor,"iSab");
   effect eSab = SupernaturalEffect(EffectAbilityIncrease(ABILITY_WISDOM,iSab));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSab, oTarget);

   int iCar = GetLocalInt(oContenedor,"iCar");
   effect eCar = SupernaturalEffect(EffectAbilityIncrease(ABILITY_CHARISMA,iCar));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCar, oTarget);
   //INCREMENTO DE ATT
   int iAtt = GetLocalInt(oContenedor,"iAtt");
   effect eAtt = SupernaturalEffect(EffectAttackIncrease(iAtt));
   ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAtt,oTarget);



   if(iNivel <= 1){
   //SpeakString("No ha sido posible añadir niveles");
   }
   else
   {
   while(iLevel != iNivel)
    {
   LevelUpHenchman(oTarget,iClass,FALSE);
   iLevel = GetHitDice(oTarget);
    }

   }

}
