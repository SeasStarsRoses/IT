#!/bin/bash

######################################################################################################################
#                                                                                                                    #
# Scan a document with several pages using the manual document feeder                                                # 
# Use a resolution of 300 Pixel, page size DIN A4, and Color mode                                                    #
# After each scanned page the user can press <Enter> to continue. Or choose between y for yes and n for no           # 
# Convert the document to pdf                                                                                        #
# Convert the document to txt using ocr                                                                              #
#                                                                                                                    #
######################################################################################################################

continue="y"
pages="0"
scan="scan"
output="output"

echo "Welcome to the Scanner script"
echo "Author: Peter Heide, pheide@t-onlinne.de"
read -p "Please type in the name of the scanned file you would like to choose: " name
echo "The name is $name"

while [ $continue == "y" ]  
do
   pages=$(( $pages + 1))	
   out="$output$pages"
   in="$scan$pages.png"
   echo Scanning page $pages...
   scanimage -x 210 -y 297 --mode Color --resolution 300 --format png > $in
   echo "Please put the next page on the scanner"
   echo Converting to TXT...
   tesseract $in $out -l deu+eng
   read -p "Do you want to scan another page?. You can simply hit <Enter> to continue scanning. Or you can type 'y' for yes or 'n' for no." line
   if [ ${#line} -eq 0 ]; then 
      continue="y"
   else 
      continue=${line:0:1}
      continue="${continue,,}"
   fi
done

txt=""
png=""

for (( page=1; page<=pages; page++ ))
do
  txt="$txt $output$page.txt"
  png="$png $scan$page.png"
done

echo "Creating $name.txt..."
cat $txt > $name.txt
echo "Creating $name.pdf..."
echo "Command: convert $png $name.pdf"
convert $png $name.pdf

echo removing intermediate files
rm *.png
for (( page=1; page<=pages; page++))
do
   rm $output$page.txt
done

echo "Finished scanning"


