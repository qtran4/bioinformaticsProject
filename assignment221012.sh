#usage: bash assignment221012.sh

#get paths of related files from user
echo -e "Please enter the absolute path to the directory that contains your reference sequences: \c" 
read ref_path
echo -e "Please enter the absolute path to the directory that contains your proteomes: \c"
read proteome_path
echo -e "Please enter the absolute path to the directory that contains your tools: \c"
read tool_path

#integrate reference sequences
for file in $ref_path/hsp70*.fasta
do
    cat $file >> hsp70_gene.fasta
done

for file in $ref_path/mcrAgene*.fasta
do
    cat $file >> mcrAgene.fasta
done

#align reference sequences
$tool_path/muscle -in hsp70_gene.fasta -out aligned_hsp70_gene.fasta
$tool_path/muscle -in mcrAgene.fasta -out aligned_mcrAgene.fasta

#generate hmm models
$tool_path/hmmbuild hsp70_gene.hmm aligned_hsp70_gene.fasta
$tool_path/hmmbuild mcrAgene.hmm aligned_mcrAgene.fasta

#generate the hmmsearch result and write the count numbers into a csv file
echo "proteome,hsp70_countnumber,mcrA_countnumber" > hmmsearch_result.csv
for file in $proteome_path/proteome*.fasta
do
    name=${file:0-17:11}
    $tool_path/hmmsearch --tblout hsp70_search_$name.out hsp70_gene.hmm $file
    $tool_path/hmmsearch --tblout mcrAgene_search_$name.out mcrAgene.hmm $file
    hsp70_countnumber=$(cat hsp70_search_$name.out | grep -v "#" | wc -l)
    mcrA_countnumber=$(cat mcrAgene_search_$name.out | grep -v "#" | wc -l)
    echo "$name,$hsp70_countnumber,$mcrA_countnumber" >> hmmsearch_result.csv
done

#what to do next: sort the data in hmmsearch_result.csv and select candidates
echo 'Recommended Proteomes (ordered by number of HSP70 genes and contain at least one mcrA gene)' >>selectedCandidates.csv

echo 'name,hsp70 count,mcrA count' >> selectedCandidates.csv

cat hmmsearch_result.csv | sed '1d' | grep -v ',0' | sort -t, -k2,2rn >> selectedCandidates.csv

cat selectedCandidates.csv | cut -d ',' -f 1 > Recommended_Candidates.txt