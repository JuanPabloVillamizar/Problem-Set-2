# Limpiar entorno
rm(list = ls())

library(haven)
library(readr)

#------------------------------------------------------------------------------#
# 1.1 Lista de archivos en input                                               #
#------------------------------------------------------------------------------#

# Obtener la lista de archivos
lista_archivos <- list.files(pattern = "\\.csv$", recursive = TRUE, full.names = TRUE)

# Crear vector con rutas completas
vector_rutas <- file.path(lista_archivos)

# Verificar el vector de rutas
print(vector_rutas)

#------------------------------------------------------------------------------#
# 1.2 Importar archivos                                                        #
#------------------------------------------------------------------------------#

# Filtrar las rutas que contienen "Resto - Características generales (Personas)"
rutas_personas <- vector_rutas[grep("Resto - Características generales (Personas)", vector_rutas)]

# Importar los archivos
datos_personas <- list()
for (ruta in rutas_personas) {
  datos_personas[[ruta]] <- read_csv(ruta)
}

# Verificar los datos importados
print(datos_personas)

#------------------------------------------------------------------------------#
# 1.3 Combinar conjuntos de datos
#------------------------------------------------------------------------------#

# Convertir todas las variables en formato carácter
for (ruta in rutas_personas) {
  datos_personas[[ruta]] <- as.character(datos_personas[[ruta]])
}

# Combinar los data.frames utilizando la función rbindlist() del paquete data.table
library(data.table)

cg <- rbindlist(datos_personas)

# Cargar el paquete dplyr
library(dplyr)

# Combinar los data.frames utilizando bind_rows()
cg <- bind_rows(datos_personas)

# Imprimir la estructura del data.frame
str(cg)

# Imprimir los primeros registros del data.frame
head(cg)

#------------------------------------------------------------------------------#
# 1.4 Describir el conjunto de datos
#------------------------------------------------------------------------------#

# Cargar el paquete openxlsx
library(openxlsx)

# Calcular la tabla de frecuencias de la variable "mes"
tabla_frecuencias <- table(cg$mes)

# Convertir la tabla de frecuencias en un data.frame
tabla_frecuencias <- as.data.frame(tabla_frecuencias)

# Renombrar las columnas del data.frame
colnames(tabla_frecuencias) <- c("mes", "frecuencia")

# Exportar la tabla de frecuencias a un archivo .xlsx
write.xlsx(tabla_frecuencias, "tabla_frecuencias.xlsx", row.names = FALSE)


