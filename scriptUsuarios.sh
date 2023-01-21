#!/bin/bash

function sinarchivos(){
        echo "Cuentas de usuario sin archivos:"
        suma=0
        for user in $(cat /etc/passwd | cut -d ':' -f1); do #itera por cada primer campo en /etc/passwd (el de usuarios)
                if [ $(find -user $user | wc -l ) -eq 0 ]; then #si el usuario no tiene archivos a su nombre
                        echo $user | tr '\n' ',' #los muestra
                        suma=`expr $suma + 1` #función básica de contar el número de veces que se itera el bucle para saber cuántos usuarios sin archivos hay.
                fi
        done
}

sinarchivos
echo -e "\n\nHay un total de $suma usuarios sin archivos"

function 6meses(){
        echo -e "\n\nCuentas de usuario que hace más de 6 meses que no modifican un archivo:"
        for user in $(cat /etc/passwd | cut -d ':' -f1); do #itera por cada usuario en /etc/passwd
                if ! [ $(find -user $user -type f -mtime -180 ! -name '.*' -not -path '*/\.*/*' | wc -l ) -gt 0 ]; then #comprueba que el usuario tenga archivos modificados en un plazo de tiempo desde la fecha actual hasta 6 meses

                        echo $user | tr '\n' ',' #los muestra cambiando los saltos de línea por comas
                fi
#Explicación de la línea find -user $user -type f -mtime -180 ! -name '.*' -not -path '*/\.*/*' -type f --> -user $user: busca archivos propiedad del usuario $user, -type f: busca solo archivos regulares,
#-time -180: busca archivos cuyo tiempo de modificación sea menor a 180 días, ! -name '.*': busca que esos archivos no empiecen por .algo (no sean archivos ocultos, ya que pueden aparecer .bashrc o archivos así que realmente tú no has modificado de forma manual
#-not -path '*/\.*/*': mediante este patrón le estaremos indicando que el archivo que se ha modificado, tampoco se halle en un directorio oculto /*/.loquesea/archivo.txt por la misma razón que lo anterior (~/.ssh/archivo)

        done
}
6meses

function 1year(){
        echo -e "\n\nCuentas de usuario que hace más de 1 año que no modifican un archivo:"
        for user in $(cat /etc/passwd | cut -d ':' -f1); do #itera por cada usuario en /etc/passwd
                if ! [ $(find -user $user -type f -mtime -360 ! -name '.*' -not -path '*/\.*/*' | wc -l ) -gt 0 ]; then #comprueba que el usuario tenga archivos modificados en un plazo de 1 año
                        echo $user | tr '\n' ',' #los muestra cambiando los saltos de línea por comas
                fi
       done
       #echo -e "\n\nCuentas que sí han modificado archivos no ocultos en un plazo máx. de 1 año"
       #for user in $(cat /etc/passwd | cut -d ':' -f1); do #itera por cada usuario en /etc/passwd
       #if [ $(find -user $user -type f -mtime -360 ! -name '.*' -not -path '*/\.*/*' | wc -l ) -gt 0 ]; then
       #          echo -e "$user con los archivos:\n"
       #          find -user $user -type f -mtime -360 ! -name '.*' -not -path '*/\.*/*' -type f -printf '%TY-%Tm-%Td %TT %p\n'
       #fi
       #done
}
1year

function sinarchivosy1year(){
        echo -e "\n\nCuentas de usuario que no tienen archivos o hace más de 1 año que no los modifican:"
        for user in $(cat /etc/passwd | cut -d ':' -f1); do #itera por cada usuario en /etc/passwd
                if ! [ $(find -user $user -type f -mtime -360 ! -name '.*' -not -path '*/\.*/*' | wc -l ) -gt 0 ] || [ $(find -user $user | wc -l ) -eq 0 ]; then #Si hace más de un año que no modifica archivos o si no tiene archivos,
                        echo $user | tr '\n' ',' #muestra los usuarios cambiando los saltos de línea por comas

                fi
        done
       echo -e "\n"
}
sinarchivosy1year
