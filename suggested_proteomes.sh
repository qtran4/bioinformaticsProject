#!/bin/bash
# Usage: bash suggested_proteome.sh
# This script is for using the results of an mcra and hsp70 gene count search to find proteomes that are methanogemic (has at least 1 mcra gene) and pH-resistant (at least 1 hsp70 gene).
# This script can only be used following the gene_count.sh for "mcra" and "hsp70".
cat proteome_final.txt | grep -v -E '[[:blank:]]+0' | sed 's/  /,/g' | cut -d , -f1 > suggested_proteomes.txt
