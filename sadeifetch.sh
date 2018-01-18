#!/bin/bash

#for each id in the range of i below,
#prints the year, type, conceyu, party, votes, & pct (valid), separated by |

#usage: ./sadeifetch.sh YEAR TYPE (i.e. ./sadeifetch.sh 1977 cong)
#usage detail: possible types: cong = congreso, mun = municipales, sen = senado, aut = autonómicas, eur = europeas

#create directories necessary
mkdir -p $1/$2

#SECTION 1 - pulls URLs to text files ---------------

#first loop, to account for stupid leading 0 in url for <10
for i in {0..9}
do
url="http://www.sadei.es/datos/sad/Eleccionesasp/eleccioneshtml.aspx?vano=$1&vmun=0$i&vele=$2"
page=$(curl -s $url)
conceyu_raw=$(echo $page | grep -oP "(?<=nombreConcejo\"\>).*?(?=\<\/h3)")
conceyu="$(echo -e "${conceyu_raw}" | sed -e 's/\s/\_/g' -e 's/\,//')"
echo "$conceyu"
echo "$page" > $1/$2/$1-$2-$conceyu.txt

#second loop, to account for stupid leading 0 in url for <10
 for j in {10..78}
  do
    url2="http://www.sadei.es/datos/sad/Eleccionesasp/eleccioneshtml.aspx?vano=$1&vmun=$j&vele=$2"
    page2=$(curl -s $url2)
    conceyu_name_raw=$(echo $page2 | grep -oP "(?<=nombreConcejo\"\>).*?(?=\<\/h3)")
    conceyu_name="$(echo -e "${conceyu_name_raw}" | sed -e 's/\s/\_/g' -e 's/\,//')"
    echo "$conceyu_name"
    echo "$conceyu_name" > sadeifetch-$1-$2.log
    echo "$page2" > $1/$2/$1-$2-$conceyu_name.txt
done
#END SECTION 1 ---------------

#SECTION 2 - Runs parser
output=$( bash sadeiparse $1 $2 )

  echo $output
#END SECTION 2 ---------------

#SECTION 3 - Cleanup files | uncomment if you want to clean up after yourself, after you know this is working well. ---------------

#rm -r $1/$2

#END SECTION 3
