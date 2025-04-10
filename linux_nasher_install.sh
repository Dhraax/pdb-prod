#!/bin/bash

echo "WARNING: 'Y' will delete all unsaved changes! Commit or stash them before continuing."


$PWD/tools/linux/nasher/nasher install default --verbose --erfUtil:"$PWD/tools/linux/neverwinter/nwn_erf" --gffUtil:"$PWD/tools/linux/neverwinter/nwn_gff" --tlkUtil:"$PWD/tools/linux/neverwinter/nwn_tlk" --installDir:"$PWD" --yes --noCompile