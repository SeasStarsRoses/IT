#!/bin/bash 

######################################################################################################################
#                                                                                                                    #
# Scan a document with several pages using the manual document feeder                                                # 
# Use a resolution of 300 Pixel, page size DIN A4, and Color mode                                                    #
# After each scanned page the user can press <Enter> to continue. Or choose between y for yes and n for no           # 
# Convert the document to pdf                                                                                        #
# Convert the document to txt using ocr                                                                              #
#                                                                                                                    #
# The OCR is done in the background, so that you can scan the next page at the same time                             #
#                                                                                                                    #
######################################################################################################################

continue="y"
page="0"
scan="scan"
output="output"
tiffs=""

echo "Welcome to the Scanner script"
echo "Author: Peter Heide, pheide@t-online.de"
read -p "Please type in the name of the scanned file you would like to choose: " name
echo "The name is $name"

while [ $continue == "y" ]  
do
   page=$(( $page + 1))	
   echo Scanning page $page...
   in="$scan$page.tiff"
   scanimage -x 210 -y 297 --mode Color --resolution 300 --format tiff > $in
   echo "Please put the next page on the scanner"
   echo
   read -p "Do you want to scan another page?. You can simply hit <Enter> to continue scanning. Or you can type 'y' for yes or 'n' for no." line
   if [ ${#line} -eq 0 ]; then 
      continue="y"
   else 
      continue="n"
   fi
   echo 
   choice=""
   if [ $continue == "y" ]; then
      choice="yes" 
   else
      choice="no" 
   fi
   echo You have chosen $choice
   tiffs="$tiffs $in"
done

echo "Executing: convert $tiffs $name.tiff"
convert $tiffs $name.tiff

echo "Converting TIFF into searchable PDF"
tesseract $name.tiff -l deu+eng "$name" pdf txt

echo Welcome to the converter PDF to PDF Archive 
echo more info at https://unix.stackexchange.com/questions/79516/converting-pdf-to-pdf-a
pdf_input=$name.pdf
ps_output=${pdf_input%.*}.ps
pdfa_output=${pdf_input%.*}_a.pdf
pdftops $pdf_input $ps_output
gs -dPDFA -dBATCH -dNOPAUSE -dNOOUTERSAVE -sProcessColorModel=DeviceCMYK -sDEVICE=pdfwrite -sPDFACompatibilityPolicy=1 -sOutputFile=$pdfa_output $ps_output

echo "Finished scanning"
