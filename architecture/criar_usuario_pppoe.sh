#!/bin/bash

# Script para criar usuário PPPoE no servidor que usa autenticação via login

read -p "Digite o nome do usuário PPPoE: " USUARIO
read -s -p "Digite a senha do usuário: " SENHA
echo

# Criar usuário com shell bloqueado e home padrão
sudo adduser --shell /bin/false --disabled-password --gecos "" "$USUARIO"

# Definir a senha do usuário
echo "$USUARIO:$SENHA" | sudo chpasswd

# Mostrar confirmação
echo "Usuário '$USUARIO' criado com sucesso para autenticação PPPoE via login."
