#!/bin/bash
#Monitor del sistema v3
#Este script es comaptible con la mayoría de distribuciones GNU/Linux,
#en caso de encontrar algún inconveniente, por favor comunicarse al e-mail
#indicado abajo.
#Creado por Daniel Villalobos, San José, Costa Rica
#e-mail: djvvr91@gmail.com
#This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

echo "Actualizando la base de datos de nombres de ficheros"
echo "Por favor espere"
updatedb
opcion=1

while [ $opcion -ne 0 ]
do

clear
echo "Monitor del sistema"
echo "----------------------------"
echo " 1-)Lista de Sistemas de Ficheros."
echo " 2-)Información de un sistema de ficheros." 
echo " 3-)Estadísticas de la memoria sistema." 
echo " 4-)Cantidad de usuarios logueados en el sistema." 
echo " 5-)Tamaño de un directorio." 
echo " 6-)Estadísticas de la memoria física."
echo " 7-)Estadísticas de la memoria swap."
echo " 8-)Cantidad de procesos del sistema."
echo " 9-)Procesos específicos de un usuario."
echo " 10-)Cantidad de Bytes I/O en una interface de red."
echo " 11-)Encontrar la ruta de un archivo."
echo " 12-)Información del sistema."
echo " 13-)Mostrar la tabla de enrutamiento."
echo " 14-)Consultar la tabla de particiones."
echo " 15-)Mostrar los dispositivos PCI del sistema"
echo " 16)Mostrar los dispositivos USB del sistema"
echo " 0-)Salir."
echo "----------------------------"

echo -n "Elija una opción:";


read opcion

case $opcion in
	
	0 )	echo "Gracias por usar el programa";;


	1 )	

		echo "Ha elegido 1-)Lista de Sistemas de Ficheros."
		echo -n | df -h | awk '{print $1}'
		;;

  	2 )
		clear
		echo "Ha elegido 2-)Información de un sistema de ficheros."
		echo "Digite el sistema de ficheros del cual desea obtener información "
		echo -n "o presione ENTER para mostrar todos los sistemas de ficheros: "
		read file_sys

		if df -h | awk '{print $1}' | grep ^$file_sys > /dev/null
		then 
			echo "Informacion de $file_sys"
			df -h $file_sys
		else 
			echo "El sistema de archivos $file_sys no existe"
		fi
		
		;;

  	3 )
		clear
		echo "Ha elegido 3-)Estadísticas de la memoria sistema."
		echo -n | vmstat -sSM | head -10
		;;

  	4 )
		clear
		echo "Ha elegido 4-)Cantidad de usuarios logueados en el sistema."
		echo -n | uptime | awk {'print $4'}
		;;
  	5 )
		clear
		echo "Ha elegido 5-)Tamaño de un directorio."
		echo "Digite la ruta absoluta del directorio"
		read directorio	
		
		if [ -d $directorio ]
		then 
			echo "Informacion de $directorio"
			du -sh $directorio 2>/dev/null
		else 
			echo "$directorio no es un nombre de directorio valido"
		fi
		;;

  	6 )
		clear
		echo "Ha elegido 6-)Memoria física."
		
		echo "Memoria fisica total MB"
		echo -n | free -mto | awk {'print $2'} | tail -3 | head -1
		
		echo "Memoria fisica utilizada MB"
		echo -n | free -mto | awk {'print $3'} | tail -3 | head -1
		
		;;

  	7 )
		clear
		echo "Ha elegido 7-)Memoria swap."
		
		echo "Memoria swap total MB"
		echo -n | free -mto | awk {'print $2'} | tail -2 | head -1
		
		echo "Memoria swap utilizada MB"
		echo -n | free -mto | awk {'print $3'} | tail -2 | head -1
		;;

  	8 )
		clear
		echo "Ha elegido 8-)Cantidad de procesos."
		
		echo "Cantidad de procesos en el sistema"
		echo -n | ps -ef | wc -l
		
		;;

  	9 )
		clear
		echo "Ha elegido 9-)Procesos específicos de un usuario."
		echo -n "Digite el nombre del usuario: "
		
		read nombre

		if grep ^$nombre /etc/passwd > /dev/null
		     then 
			if who | grep "^$nombre " > /dev/null
			then
				echo "El usuario $nombre esta en el sistema "
				echo "Cantidad de procesos para el usuario $nombre"
				echo -n | ps -U $nombre | wc -l
			else
			  echo "El usuario $nombre no esta conectado al sistema"
			fi
		     else
		       echo "El $nombre no existe en este sistema"
		     fi
		;;
		
	10 )
		clear
		echo "Ha elegido 10-)Cantidad de datos I/O en una interface."

		echo "Digite el nombre de la interface"
		read interface



		if ifconfig | grep $interface 1>/dev/null 2>/dev/null
		then 
			if test "$interface" = "lo"
			then 
			echo "Cantidad de datos recibidos/transmitidos en loopback"
			ifconfig lo | tail -2 | head -1
			else
			echo "Cantidad de datos recibidos/transmitidos en $interface"
			ifconfig $interface | tail -3 | head -1
			fi
		else echo "Esta interface no existe en el sistema"
		fi	
		;;
		
	11 )
		clear
		echo "Ha elegido 11-)Encontrar la ruta de un archivo."
		echo "Digite 1 para utilizar FIND o 2 para LOCATE"
		read buscar

			echo "Digite el nombre del archivo"
			read archivo

			case $buscar in

			1 )
			a=`find / -name $archivo  2>/dev/null`
			if test ! -z $archivo
			then 
			echo "La ruta del archivo es: "
			echo $a
			else echo "$archivo no existe"
			fi

			;;


			 2 )

			if locate $archivo 1>/dev/null 2>/dev/null
			then
				echo "Directorio actual: " `pwd`
				echo "Ruta de $archivo: "
				locate $archivo
			else echo "$archivo no existe"
			fi


			;;

			*) echo "Error opción no válida"


			;;


			esac
		;;

	12)
		clear
		echo "Ha elegido 12-)Información del sistema"
		echo -n "Versión del Sistema Operativo: "
		head -n1 /etc/issue
		echo -n "Información General"| uname -a
		echo -n "Fecha y hora de inicio del sistema" | who -b
		echo -n "Arquitectura"| arch	
		echo -n "Información del procesador: "		
		grep "model name" /proc/cpuinfo | cut -d":" -f2
		echo "Tamaño total del disco duro"
		fdisk -l | head -2 | cut -d"," -f1 | tail -1
		;;

	13)
		clear
		echo "Ha elegido 13-)Mostrar la tabla de enrutamiento"
		echo -n | route

		;;
	
	14)
		clear
		echo "Ha elegido 14-)Consultar la tabla de particiones"
		echo -n | fdisk -l|more

		;;

	15)
		clear
		echo "Ha elegido 15-)Mostrar los dispositivos PCI del sistema"
		echo -n | lspci|more

		;;

	16)
		clear
		echo "Ha elegido 16-)Mostrar los dispositivos USB del sistema"
		echo -n | lsusb

		;;



	* )	echo "Error! Opción no válida"
	        echo "Digite números entre 0 y 16"
	        opcion=1;;

esac

if [ $opcion -ne 0 ]
then echo -n "Presione [ENTER] para continuar"
   read nada
fi
done
