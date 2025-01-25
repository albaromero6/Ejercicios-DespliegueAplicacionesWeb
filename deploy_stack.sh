#!/bin/bash

# Variables
STACK_NAME="MyTomcatStack"  # Nombre de mi pila
TEMPLATE_FILE="instance_Tomcat.yaml"  # Nombre de mi archivo YAML
REGION="us-east-1"  # Región donde voy a desplegar mi pila

# Desplegar la pila
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_FILE \
    --region $REGION

# Verificar si la pila se desplegó correctamente
if [ $? -eq 0 ]; then
    echo "Despliegue de la pila $STACK_NAME iniciado correctamente."
    echo "Esperando a que la pila se cree completamente..."
    aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION
    echo "Pila $STACK_NAME desplegada correctamente."
else
    echo "Error al desplegar la pila $STACK_NAME."
fi