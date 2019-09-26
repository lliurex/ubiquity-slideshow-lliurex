#!/bin/bash

TITLE="Slideshow tester"

SOURCE=.
BUILD=$SOURCE/build
SOURCESLIDES=$SOURCE/slideshows
LANG1="Valenciano:ca_es"
LANG2="Valenciano:qcv"
LANG3="Valenciano:ca_ES@valencia"
LANG4="Valenciano:ca_ES.UTF-8@valencia"
LANG5="Castellano:es_ES.UTF-8"
LANG6="English:en"

slideshow=$1
if [ -z "$slideshow" ]
	then
		slideshows=""
		for show in $SOURCESLIDES/*; do
			showname=$(basename $show)
			#oddly placed files we need to ignore
			[ $showname = "link-core" ] && continue
			#if we're still going, add this slideshow to the list
			select=FALSE
			[ $showname = "lliurex" ] && select=TRUE
			slideshows="$slideshows $select $showname"
		done
		slideshow=$(zenity --list --radiolist --column="Pick" --column="Slideshow" $slideshows --title="$TITLE" --text="Choose a slideshow to test")
		[ "$slideshow" = "" ] | [ "$slideshow" = "(null)" ] && exit
fi

#language=$2
#language=$2
language=$(zenity --list --radiolist --column="Pick" --column="Language" FALSE "$LANG1" FALSE "$LANG2" FALSE "$LANG3" FALSE "$LANG4" TRUE "$LANG5" FALSE "$LANG6" --title="$TITLE" --text="Choose a language to test")

case $language in
        "Valenciano:ca_es")
                language=ca
                ;;
        "Valenciano:qcv")
                language=qcv
                ;;
        "Valenciano:ca_ES@valencia")
                language=ca_ES@valencia
                ;;
        "Valenciano:ca_ES.UTF-8@valencia")
                language=ca_ES.UTF-8@valencia
                ;;
        "Castellano:es_ES.UTF-8")
                language=es_ES.UTF-8
                ;;
        "English:Other")
                language=en
                ;;
        *)
                language=""
                ;;
esac
echo "You select language:$language"
echo "TRANSLATIONS............"
if [ -n "$language" ]
        then
                make test.$slideshow.$language
        else
                make clean
                make test.$slideshow
fi

echo "You select language:$language"
make clean
rm po/lliurex/*.mo
echo ""
echo ""
echo -e "\e[95m------------------- Test Ubiquity-Slideshow finished & cleaned --------------\e[0m"
echo ""
echo""

