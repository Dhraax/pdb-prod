void main()
{
    DelayCommand(6000.0, DeleteLocalInt(GetModule(), "CHICO_PLANO_AGUA"));
    ExecuteScript("nw_c2_default7", OBJECT_SELF);
}

