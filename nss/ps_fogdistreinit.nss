void main()
{

    object oArea=GetArea(GetPCSpeaker());
    int fogamountsun=GetLocalInt(oArea,"fogamountsun");
    int fogamountmoon=GetLocalInt(oArea,"fogamountmoon");

    SetFogAmount(FOG_TYPE_SUN,fogamountsun,oArea);
    SetFogAmount(FOG_TYPE_MOON,fogamountmoon,oArea);

}
