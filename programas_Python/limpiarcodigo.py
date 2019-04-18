import re
from io import open

#lineas
def cortar(lineas,n,lista_chida,long):
    linea=lineas[n]
    if n<long:
        #X coordenada en x
        #Y coordenada en y
        #penetrate empezar a escribir
        #path inicio de una ruta o fin de una ya definida
        #footer fin de la imagen y se vuelve a colocar en el principio
        listaX=re.findall("X\d*",linea)
        listaY=re.findall("Y\d*",linea)
        escribir=re.findall("Penetrate",linea)
        path=re.findall("path ",linea)
        footer=re.findall("Footer",linea)
        if listaX != []:
            listaX+=listaY
            elemento=[listaX]
            lista_chida+=elemento
        elif escribir != []:
            elemento=[["e"]]
            lista_chida+=elemento
        elif path != []:
            elemento=[["p"]]
            lista_chida+=elemento
        elif footer != []:
            elemento=[["f"]]
            lista_chida+=elemento
        n=n+1
        cortar(lineas,n,lista_chida,long)
    else:
        print("lista chida")
    return lista_chida

file_gcode=open("casa_0001.ngc","r")
lineas_gcode=file_gcode.readlines()
file_gcode.close()
lista_chida=[]
long_listas=(len(lineas_gcode)-1)
n=0
lista_chida_formal=cortar(lineas_gcode,n,lista_chida,long_listas)
print(lista_chida_formal)
