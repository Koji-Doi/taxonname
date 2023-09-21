# wget https://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz 

# 1. dumpファイルからcbsファイルを作る
# 2. 和名-学名対応票の再整備
# 3. taxonコマンドの更新

SRCDIR=/home/kdoi2/raid/proj230314newtaxonomy/taxdump_230314_1720
WDIR=/home/kdoi2/raid/proj230314newtaxonomy
HTML_HACHU=hachuu-ryousei.html
TSV_HACHU=hachuu-ryousei.tsv
JSON_TOGO=species_names_latin_vs_japanese.json
TSV_TOGO=species_names_latin_vs_japanese.tsv
TSV_FINAL=final.tsv
TSV_FINAL_PERSONAL=final_personal.tsv
HTML_ALGAE=Brown_A_all.html   Brown_Ma_all.html  Brown_Sa_all.html   Green_A_all.html   Green_Ma_all.html	Green_Sa_all.html  Red_A_all.html   Red_Ma_all.html  Red_Sa_all.html Brown_Ha_all.html  Brown_Na_all.html  Brown_Ta_all.html   Green_Ha_all.html  Green_Na_all.html Green_Ta_all.html  Red_Ha_all.html  Red_Na_all.html  Red_Ta_all.html Brown_Ka_all.html  Brown_Ra_all.html  Brown_Ya_all.html  Green_Ka_all.html  Green_Ra_all.html Green_Ya_all.html  Red_Ka_all.html  Red_Ra_all.html  Red_Ya_all.html
TSV_ALGAE0=algae.tsv
CSV_FISH=20230801_JAFList.csv
TSV_FISH=jaflist.tsv
CSV_FUNGI=DB20200311.csv
TSV_FUNGI=fungi.tsv
CSV_FUNGIOLD=Katumoto-Wamei.csv
TSV_FUNGIOLD=fungi_old.tsv
CSV_VPLANT=wamei_checklist_ver.1.10a.csv
TSV_VPLANT=vplant.tsv
#TXT_PLANT0=20210514YList_download_tab.txt
#TSV_PLANT0=ylist.tsv
CSV_MAMMAL0=list_20211223.csv
TSV_MAMMAL0=mammal.tsv

SRC_ALL=$(TSV_TOGO) $(TSV_ALGAE0) $(TSV_HACHU) $(TSV_FISH) $(TSV_FUNGI) $(TSV_PLANT0) $(TSV_VPLANT) $(TSV_MAMMAL0)
SRC_PERSONAL=$(TSV_TOGO) $(TSV_ALGAE0) $(TSV_HACHU) $(TSV_FISH) $(TSV_FUNGI) $(TSV_PLANT0) $(TSV_VPLANT) $(TSV_MAMMAL0)

all: $(TSV_FINAL_PERSONAL)

$(TSV_FINAL_PERSONAL): $(TSV_TOGO) $(TSV_ALGAE0) $(TSV_HACHU) $(TSV_FISH) $(TSV_FUNGI) $(TSV_PLANT0) $(TSV_VPLANT) $(TSV_MAMMAL0) merge.pl Taxon.pm
	perl merge.pl $(filter %.tsv,$^) > $@

public: $(TSV_FINAL)

$(TSV_FINAL): $(TSV_TOGO) $(TSV_HACHU) $(TSV_FISH) $(TSV_FUNGI) $(TSV_VPLANT) merge.pl Taxon.pm
	perl merge.pl $(filter %.tsv,$^) > $@

test: $(TSV_ALGAE0) $(TSV_FISH) $(TSV_FUNGI)

testdb:
	perl $(WDIR)/readtaxon.pl -s $(SRCDIR)
#^ modify *.cdb in $(SRCDIR)

hachuu-ryousei: $(TSV_HACHU)

$(TSV_HACHU): $(HTML_HACHU) hachuu-ryousei.pl Taxon.pm
	perl hachuu-ryousei.pl $< > $@

# The published tsv file is useless, so remake it from json file
$(TSV_TOGO): $(JSON_TOGO) togodb.pl
	perl togodb.pl

$(TSV_ALGAE0): $(HTML_ALGAE) algae.pl Taxon.pm
	perl algae.pl $< > $@

$(TSV_FISH): $(CSV_FISH) fish.pl Taxon.pm
	perl fish.pl $< > $@

$(TSV_FUNGI): $(CSV_FUNGIOLD) $(CSV_FUNGI) fungi.pl Taxon.pm
	perl fungi.pl $(filter %.csv,$^) > $@

#$(TSV_PLANT0): $(TXT_PLANT0) vlist.pl Taxon.pm
#	perl vlist.pl $< > $@

$(TSV_VPLANT): $(CSV_VPLANT) vlist.pl Taxon.pm 
	perl vlist.pl $< > $@

$(TSV_MAMMAL0): $(CSV_MAMMAL0) mammal.pl Taxon.pm
	perl mammal.pl $< > $@
