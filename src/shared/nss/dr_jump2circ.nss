
void main()
{
    object oDestPortal = GetObjectByTag("tg_port_circ");
    if (GetIsObjectValid(oDestPortal) == TRUE)
    {
        AssignCommand(GetPCSpeaker(), JumpToObject(oDestPortal));
    }
}
