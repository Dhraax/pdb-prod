void main()
{

    SetLocalInt(GetPCSpeaker(), "ko_quest_cerrajero", 2);
    object oLlave = CreateItemOnObject("keymurrangremio",GetPCSpeaker());
    GiveXPToCreature(GetPCSpeaker(), 1000);
}
