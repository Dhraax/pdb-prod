void main()
{
    object oArea=GetArea(GetPCSpeaker());
    int ciel=GetLocalInt(oArea,"skybox");
    int fogamountsun=GetLocalInt(oArea,"fogamountsun");
    int fogamountmoon=GetLocalInt(oArea,"fogamountmoon");
    int fogcolorsun=GetLocalInt(oArea,"fogcolorsun");
    int fogcolormoon=GetLocalInt(oArea,"fogcolormoon");

    SetWeather(oArea,WEATHER_USE_AREA_SETTINGS);
    SetSkyBox(ciel,oArea);
    SetFogAmount(FOG_TYPE_SUN,fogamountsun,oArea);
    SetFogAmount(FOG_TYPE_MOON,fogamountmoon,oArea);
    SetFogColor(FOG_TYPE_SUN,fogcolorsun,oArea);
    SetFogColor(FOG_TYPE_MOON,fogcolormoon,oArea);
}
