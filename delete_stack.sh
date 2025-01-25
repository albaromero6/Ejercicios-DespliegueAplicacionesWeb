#!/bin/bash

# Variables
STACK_NAME="MyTomcatStack"  # Mismo nombre que en deploy_stack.sh
REGION="us-east-1"  # Misma región que en deploy_stack.sh

# Eliminar la pila
aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region $REGION

# Verificar si la pila se eliminó correctamente
if [ $? -eq 0 ]; then
    echo "Eliminación de la pila $STACK_NAME iniciada correctamente."
    echo "Esperando a que la pila se elimine completamente..."
    aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME --region $REGION
    echo "Pila $STACK_NAME eliminada correctamente."
else
    echo "Error al eliminar la pila $STACK_NAME."
fi