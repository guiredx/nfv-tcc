#!/bin/bash

echo "🔍 Verificando sessão BGP..."
bgp_summary=$(vtysh -c "show ip bgp summary" | grep 192.168.33.11)

if echo "$bgp_summary" | grep -q "ESTABLISHED"; then
    echo "✅ Sessão BGP ESTABLISHED com 192.168.33.11"
else
    echo "⚠️ Sessão BGP ainda não estabelecida:"
    echo "$bgp_summary"
fi

echo ""
echo "📡 Testando ping para rede recebida via BGP (20.0.0.1)..."
ping -c 3 20.0.0.1

if [ $? -eq 0 ]; then
    echo "✅ Conectividade BGP OK: 20.0.0.1 está acessível"
else
    echo "❌ Falha no ping para 20.0.0.1 - verifique rotas e BGP"
fi

echo ""
echo "📍 Verificando rota para 20.0.0.1:"
ip route get 20.0.0.1
