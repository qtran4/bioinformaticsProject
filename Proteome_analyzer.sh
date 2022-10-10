# 
# Usage: bash Proteome_analyzer.sh mcrA_reference_files hsp70_reference_files proteome_sequences

~/Private/Biocomputing2022/tools/muscle -in "$1" -out mcrA_alignment | ~/Private/Biocomputing2022/tools/hmmbuild mcrA_HMM

for proteome in "$3"
do


