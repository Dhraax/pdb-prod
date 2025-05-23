void main()
{
    object oArea=GetArea(GetPCSpeaker());
    int fogcolorsun=GetLocalInt(oArea,"fogcolorsun");
    int fogcolormoon=GetLocalInt(oArea,"fogcolormoon");

    SetFogColor(FOG_TYPE_SUN,fogcolorsun,oArea);
    SetFogColor(FOG_TYPE_MOON,fogcolormoon,oArea);
}
