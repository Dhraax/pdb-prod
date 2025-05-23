//::///////////////////////////////////////////////
//:: CONTROLAR EL CLIMA (lluvia, nieve y soleado)
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Controlar el clima.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 17 de Octubre de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "colors_inc"

// Put in nCastTimes to stop the change back in weather if this is cast
// again. Note that it just resets to area settings.
void SetWeatherBack(object oArea, int nCastTimes)
{
    // Check nCastTimes
    if(GetLocalInt(oArea, "CONTROL_WEATHER_CAST_TIMES") == nCastTimes)
    {
        // Reset the weather
        SetWeather(oArea, WEATHER_USE_AREA_SETTINGS);
    }
}

void DesactivarMonzon(object oArea, int nCastTimes)
{
  if(GetLocalInt(oArea, "CONTROL_WEATHER_CAST_TIMES") == nCastTimes &&
     GetLocalInt(oArea, "CONJ_MONZON"))
  {
      DeleteLocalInt(oArea,"CONJ_MONZON");

      int iskybox = GetLocalInt(oArea,"skybox");
      int ifogamountsun = GetLocalInt(oArea,"fogamountsun");
      int ifogamountmoon = GetLocalInt(oArea,"fogamountmoon");
      int ifogcolorsun = GetLocalInt(oArea,"fogcolorsun");
      int ifogcolormoon = GetLocalInt(oArea,"fogcolormoon");
      DeleteLocalInt(oArea,"skybox");
      DeleteLocalInt(oArea,"fogamountsun");
      DeleteLocalInt(oArea,"fogamountmoon");
      DeleteLocalInt(oArea,"fogcolorsun");
      DeleteLocalInt(oArea,"fogcolormoon");

      SetSkyBox(iskybox,oArea);
      SetWeather(oArea,WEATHER_USE_AREA_SETTINGS);
      DelayCommand(1.0,SetFogAmount(FOG_TYPE_ALL,ifogamountmoon + 45,oArea));
      DelayCommand(2.0,SetFogAmount(FOG_TYPE_ALL,ifogamountmoon + 30,oArea));
      DelayCommand(3.0,SetFogAmount(FOG_TYPE_ALL,ifogamountmoon + 15,oArea));
      DelayCommand(4.0,SetFogAmount(FOG_TYPE_ALL,ifogamountmoon,oArea));
      DelayCommand(1.0,SetFogAmount(FOG_TYPE_ALL,ifogamountsun + 45,oArea));
      DelayCommand(2.0,SetFogAmount(FOG_TYPE_ALL,ifogamountsun + 30,oArea));
      DelayCommand(3.0,SetFogAmount(FOG_TYPE_ALL,ifogamountsun + 15,oArea));
      DelayCommand(4.0,SetFogAmount(FOG_TYPE_ALL,ifogamountsun,oArea));
      DelayCommand(1.0,SetFogColor(FOG_TYPE_MOON,ifogcolormoon,oArea));
      DelayCommand(1.0,SetFogColor(FOG_TYPE_SUN,ifogcolorsun,oArea));
  }
}

int IncreaseStoredInteger(object oTarget, string sName, int nAmount = 1)
{
    // Get old
    int nOriginal = GetLocalInt(oTarget, sName);
    // Add new
    int nNew = nOriginal + nAmount;
    // Set new
    SetLocalInt(oTarget, sName, nNew);
    // Return the new value
    return nNew;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  object oCaster = OBJECT_SELF;
  object oArea = GetArea(oCaster);
  int nWeather = GetWeather(oArea);

  // Doesn't work belowground...
  if(!GetIsAreaAboveGround(oArea))
  {
      SendMessageToPC(oCaster, ColorToken(254,60,60) + "No puedes Controlar el Clima bajo tierra.</c>");
      return;
  }
  // ...or indoors.
  if(GetIsAreaInterior(oArea))
  {
      SendMessageToPC(oCaster, ColorToken(254,60,60) + "No puedes Controlar el Clima en interiores.</c>");
      return;
  }
  // ...or with invalid weather (turned off?)
  if(nWeather == WEATHER_INVALID)
  {
      SendMessageToPC(oCaster, ColorToken(254,60,60) + "No puedes Controlar el Clima aquí.</c>");
      return;
  }

  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
  int nCastTimes = GetLocalInt(oArea, "CONTROL_WEATHER_CAST_TIMES");
  float fDuration = HoursToSeconds(d12(4)); // Duration - 4d12 hours

  if(nMetaMagic == METAMAGIC_MAXIMIZE)
  {
      fDuration = 48.0;
  }

  if(nMetaMagic == METAMAGIC_EMPOWER)
  {
      fDuration = fDuration + (fDuration / 2);
  }

  // Double duration for druids
  if(GetLastSpellCastClass() == CLASS_TYPE_DRUID)
  {
      fDuration *= 2;
  }

  effect eEspecial = EffectVisualEffect(134);
  DelayCommand(1.0,AssignCommand(oCaster,ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0,15.0)));
  DelayCommand(1.1,SetCommandable(FALSE,oCaster));
  DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oCaster));
  DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oCaster));
  DelayCommand(6.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oCaster));
  DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eEspecial,oCaster));
  DelayCommand(8.1,SetCommandable(TRUE,oCaster));

  // Rain, snow, clear or monzon?
  switch(GetSpellId())
  {
      case 1133:
      {
          // Change to rain
          if(nWeather == WEATHER_RAIN)
          {
              SendMessageToPC(oCaster, ColorToken(254,60,60) + "Ya está lloviendo, Controlar el Clima no causará efecto alguno.</c>");
              return;
          }
          else
          {
              DesactivarMonzon(oArea, nCastTimes);

              // Add one to the times it has been cast on this area
              nCastTimes = IncreaseStoredInteger(oArea, "CONTROL_WEATHER_CAST_TIMES");
              // Set and delay the changing back
              SetWeather(oArea, WEATHER_RAIN);
              DelayCommand(fDuration, SetWeatherBack(oArea, nCastTimes));
          }
      }
      break;
      case 1134:
      {
          // Change to snow
          if(nWeather == WEATHER_SNOW)
          {
              SendMessageToPC(oCaster, ColorToken(254,60,60) + "Ya está nevando, Controlar el Clima no causará efecto alguno.</c>");
              return;
          }
          else
          {
              DesactivarMonzon(oArea, nCastTimes);

              // Add one to the times it has been cast on this area
              nCastTimes = IncreaseStoredInteger(oArea, "CONTROL_WEATHER_CAST_TIMES");
              // Set and delay the changing back
              SetWeather(oArea, WEATHER_SNOW);
              DelayCommand(fDuration, SetWeatherBack(oArea, nCastTimes));
          }
      }
      break;
      case 1135:
      {
          // Change to clear
          if(nWeather == WEATHER_CLEAR)
          {
              SendMessageToPC(oCaster, ColorToken(254,60,60) + "Ya está soleado, Controlar el Clima no causará efecto alguno.</c>");
              return;
          }
          else
          {
              DesactivarMonzon(oArea, nCastTimes);

              // Add one to the times it has been cast on this area
              nCastTimes = IncreaseStoredInteger(oArea, "CONTROL_WEATHER_CAST_TIMES");
              // Set and delay the changing back
              SetWeather(oArea, WEATHER_CLEAR);
              DelayCommand(fDuration, SetWeatherBack(oArea, nCastTimes));
          }
      }
      break;
      case 1140:
      {
          // Change to clear
          if(GetLocalInt(oArea, "CONJ_MONZON"))
          {
              SendMessageToPC(oCaster, ColorToken(254,60,60) + "Ya hay un monzón, Controlar el Clima no causará efecto alguno.</c>");
              return;
          }

          // Add one to the times it has been cast on this area
          nCastTimes = IncreaseStoredInteger(oArea, "CONTROL_WEATHER_CAST_TIMES");
          SetLocalInt(oArea, "CONJ_MONZON", TRUE);

          int ciel = GetSkyBox(oArea);
          int fogamountsun = GetFogAmount(FOG_TYPE_SUN,oArea);
          int fogamountmoon = GetFogAmount(FOG_TYPE_MOON,oArea);
          int fogcolorsun = GetFogColor(FOG_TYPE_SUN,oArea);
          int fogcolormoon = GetFogColor(FOG_TYPE_MOON,oArea);
          SetLocalInt(oArea,"skybox",ciel);
          SetLocalInt(oArea,"fogamountsun",fogamountsun);
          SetLocalInt(oArea,"fogamountmoon",fogamountmoon);
          SetLocalInt(oArea,"fogcolorsun",fogcolorsun);
          SetLocalInt(oArea,"fogcolormoon",fogcolormoon);

          SetFogColor(FOG_TYPE_ALL,FOG_COLOR_BLACK,oArea);
          DelayCommand(1.0,SetFogAmount(FOG_TYPE_ALL,fogamountsun + 15,oArea));
          DelayCommand(3.0,SetFogAmount(FOG_TYPE_ALL,fogamountsun + 30,oArea));
          DelayCommand(5.0,SetFogAmount(FOG_TYPE_ALL,fogamountsun + 45,oArea));
          DelayCommand(7.0,SetFogAmount(FOG_TYPE_ALL,fogamountsun + 60,oArea));

          SetFogAmount(FOG_TYPE_ALL,fogamountmoon + 15,oArea);
          DelayCommand(1.0,SetFogAmount(FOG_TYPE_ALL,fogamountmoon + 15,oArea));
          DelayCommand(3.0,SetFogAmount(FOG_TYPE_ALL,fogamountmoon + 30,oArea));
          DelayCommand(5.0,SetFogAmount(FOG_TYPE_ALL,fogamountmoon + 45,oArea));
          DelayCommand(7.0,SetFogAmount(FOG_TYPE_ALL,fogamountmoon + 60,oArea));

          DelayCommand(4.0,SetWeather(oArea,WEATHER_RAIN));
          DelayCommand(4.0,SetSkyBox(SKYBOX_GRASS_STORM,oArea));

          int n = 1;
          while(n<=100)
          {
              location loc = GetLocation(oCaster);
              float ori = GetFacingFromLocation(loc);
              vector pos = GetPositionFromLocation(loc);
              effect eff=EffectVisualEffect(VFX_IMP_LIGHTNING_M,TRUE);
              DelayCommand(IntToFloat(n),ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eff,Location(oArea,Vector(pos.x+(Random(50)-25), pos.y+(Random(50)-25),pos.z), ori)));
              n++;
          }

          DelayCommand(fDuration, DesactivarMonzon(oArea, nCastTimes));
          DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
      }
      break;
  }
}
