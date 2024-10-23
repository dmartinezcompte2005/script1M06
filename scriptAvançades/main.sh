while true; do

clear

echo "BENVINGUTS AL NOSTRE SCRIPT AVANÇAT"
echo "1. Gestio d'usuaris"
echo "2. "
redad -p "Indica quina opcio vols triar: " opcio

case "$opcio" in

1)
	primer;;
2)
	segona;;
3)
	exit;;


esac
	read -p "Prem el enter per continuar"
done
