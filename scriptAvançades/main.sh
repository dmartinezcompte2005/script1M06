while true; do

clear

echo "BENVINGUTS AL NOSTRE SCRIPT AVANÇAT"
echo "1. Gestio d'usuaris"
echo "2. "
echo "3. "
echo "4. "
echo "5. Salir"
redad -p "Indica quina opcio vols triar: " opcio

case "$opcio" in

1)
	# Introduim el nom del primer fitxer
	primer;;
2)
	# Introduim el nom del segon fitxer
	segona;;
3)
	# Introduim el nom del tercer fitxer
	tercer;;
4)
	# Introduim el nom del quart fitxer
 	quart;;
5)
	exit;;


esac
	read -p "Prem el enter per continuar"
done
