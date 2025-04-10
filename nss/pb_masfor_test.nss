#include "x2_inc_itemprop"
#include "x3_inc_horse"
#include "mti_libreria"

void main()
{
    int nSpell = GetSpellId();
    int nDuration = GetLevelByClass(63);
    effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
    int iConstant;

    if(nSpell == 1435)   iConstant = 168;       //Orco
    else if(nSpell == 1436) iConstant = 169;    //Troglodita
    else if(nSpell == 1437) iConstant = 170;    //Hombre Lagarto
    else if(nSpell == 1438) iConstant = 171;    //Trasgo
    else if(nSpell == 1439) iConstant = 172;    //Kobold
    else if(nSpell == 1441) iConstant = 173;    //Drow
    else if(nSpell == 1442) iConstant = 174;    //Duergar
    else if(nSpell == 1444) iConstant = 175;    //Ogro
    else if(nSpell == 1445) iConstant = 176;    //Ettin
    else if(nSpell == 1446) iConstant = 177;    //Troll
    else if(nSpell == 1448) iConstant = 178;    //Ogro Hechicero
    else if(nSpell == 1449) iConstant = 179;    //Gigante de las colinas
    else if(nSpell == 1451) iConstant = 180;    //Gignate de fuego
    else if(nSpell == 1452) iConstant = 181;    //Gigante de hielo
    else if(nSpell == 1454) iConstant = 182;    //Minotauro
    else if(nSpell == 1455) iConstant = 183;    //Yeti
    else if(nSpell == 1460) iConstant = 184;    //Centauro
    else if(nSpell == 1459) iConstant = 185;    //Aguijoneador
    else if(nSpell == 1456) iConstant = 186;    //Gargola
    else if(nSpell == 1457) iConstant = 187;    //Arpia
    else if(nSpell == 1462) iConstant = 188;    //Meudsa
    else if(nSpell == 1464) iConstant = 189;    //Driada
    else if(nSpell == 1465) iConstant = 190;    //Ninfa
    else if(nSpell == 1468) iConstant = 191;    //Pixi
    else if(nSpell == 1466) iConstant = 192;    //Satiro
    else if(nSpell == 1470) iConstant = 193;    //Araña gigante
    else if(nSpell == 1471) iConstant = 194;    //Escarabajo de fuego
    else if(nSpell == 1473) iConstant = 195;    //Araña Gargantuesca
    else if(nSpell == 1478) iConstant = 196;    //Azotamentes
    else if(nSpell == 1475) iConstant = 197;    //Draña
    else if(nSpell == 1476) iConstant = 198;    //Oseogarfio
    else if(nSpell == 1480) iConstant = 199;    //Miconido
    else if(nSpell == 1482) iConstant = 200;    //Ent
    else if(nSpell == 1484) iConstant = 201;    //Cieno
    else if(nSpell == 1486) iConstant = 202;    //Cubo Gelatinoso
    else if(nSpell == 1488) iConstant = 203;    //Elemental de fuego
    else if(nSpell == 1489) iConstant = 204;    //Elemental de aire
    else if(nSpell == 1490) iConstant = 205;    //Elemental de tierra
    else if(nSpell == 1491) iConstant = 206;    //Elemental de agua
    else if(nSpell == 1493) iConstant = 207;    //Dragon rojo
    else if(nSpell == 1494) iConstant = 208;    //Dragon azul
    else if(nSpell == 1495) iConstant = 209;    //Dragon negro
    else if(nSpell == 1496) iConstant = 210;    //Dragon verde
    else if(nSpell == 1497) iConstant = 211;    //Dragon blanco
    else if(nSpell == 1499) iConstant = 212;    //Dragon oro
    else if(nSpell == 1500) iConstant = 213;    //Dragon oropel
    else if(nSpell == 1501) iConstant = 214;    //Dragon bronce
    else if(nSpell == 1502) iConstant = 215;    //Dragon cobre
    else if(nSpell == 1503) iConstant = 216;    //Dragon plata
    //effect ePoly = EffectPolymorph(iConstant);
    effect ePoly = EffectRunScript("pb_mmf_effect","pb_mmf_effect","",0.0,IntToString(iConstant));
    if(ObtenerIntPersistente(OBJECT_SELF,"POLYMORPH_COUNT_1") == FALSE) {
        ePoly = TagEffect(ePoly,"MDF_POLYMORPH_1");
        GuardarIntPersistente(OBJECT_SELF,"POLYMORPH_COUNT_1",TRUE);
    }
    else
    {
        ePoly = TagEffect(ePoly,"MDF_POLYMORPH_2");
        GuardarIntPersistente(OBJECT_SELF,"POLYMORPH_COUNT_2",TRUE);
    }
    ePoly = ExtraordinaryEffect(ePoly);
    //Fire cast spell at event for the specified target
    //SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_WILD_SHAPE, FALSE));

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoly, OBJECT_SELF);

}
