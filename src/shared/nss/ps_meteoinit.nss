void main()
{object oArea=GetArea(GetPCSpeaker());
int ciel=GetSkyBox(oArea);int fogamountsun=GetFogAmount(FOG_TYPE_SUN,oArea);
int fogamountmoon=GetFogAmount(FOG_TYPE_MOON,oArea);int fogcolorsun=GetFogColor(FOG_TYPE_SUN,oArea);
int fogcolormoon=GetFogColor(FOG_TYPE_MOON,oArea);
if(GetLocalInt(oArea,"skybox")==0)SetLocalInt(oArea,"skybox",ciel);
if(GetLocalInt(oArea,"fogamountsun")==0)SetLocalInt(oArea,"fogamountsun",fogamountsun);
if(GetLocalInt(oArea,"fogamountmoon")==0)SetLocalInt(oArea,"fogamountmoon",fogamountmoon);
if(GetLocalInt(oArea,"fogcolorsun")==0)SetLocalInt(oArea,"fogcolorsun",fogcolorsun);
if(GetLocalInt(oArea,"fogcolormoon")==0)SetLocalInt(oArea,"fogcolormoon",fogcolormoon);
;


}
