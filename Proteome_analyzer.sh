# 
# Usage: bash Proteome_analyzer.sh mcrA_reference_files hsp70_reference_files proteome_sequences

# cat "$1" | ~/Private/Biocomputing2022/tools/muscle -out mcrA_alignment | ~/Private/Biocomputing2022/tools/hmmbuild mcrA_HMM
cat ref_sequences/mcrAgene_*.fasta | ~/Private/Biocomputing2022/tools/muscle -out mcrA_alignment
~/Private/Biocomputing2022/tools/hmmbuild mcrA_HMM mcrA_alignment | ~/Private/Biocomputing2022/tools/h


