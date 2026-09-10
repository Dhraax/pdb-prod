#!/bin/bash

$PWD/tools/linux/nasher/nasher unpack default --file:modules/PB_EE_PGCC --removeDeleted --erfUtil:"$PWD/tools/linux/neverwinter/nwn_erf" --gffUtil:"$PWD/tools/linux/neverwinter/nwn_gff" --tlkUtil:"$PWD/tools/linux/neverwinter/nwn_tlk" --nssFlags:"-l" --gffFlags="--nwn-encoding windows-1252" --yes 