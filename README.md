# PROTÓTIPO DE NFV PARA UM ISP - Laboratório de Virtualização de Funções de Rede (NFV)

Este projeto é uma Prova de Conceito (PoC) acadêmica que simula a infraestrutura de um pequeno provedor de serviços de Internet (ISP) utilizando **virtualização de funções de rede (NFV)** com ferramentas de código aberto como **Vagrant**, **Open vSwitch**, **FRRouting**, **iptables**, **BIND9**, **PPP** e **FreeRADIUS**.

## 🧩 Arquitetura

A arquitetura está dividida de acordo com os princípios do **ETSI NFV**, com os seguintes elementos:

- **VNFs (Virtual Network Functions):**
  - `firewall`: filtro de pacotes com iptables
  - `cgnat`: NAT de saída para IP público
  - `pppoe-server`: autenticação PPPoE
  - `dns`: resolução de nomes (BIND9)
  - `bgp_internal` e `bgp_external`: roteadores com BGP (FRRouting)
  - `cliente`: simulação do usuário final conectado via PPPoE

- **NFVI (Network Functions Virtualization Infrastructure):**
  - Host Linux com interfaces TAP, Open vSwitch e Vagrant
  - Bridges criadas para segmentação: `br-wan`, `br-lan`, `br-cgnat-fw`, etc.

- **MANO (Management and Orchestration):**
  - Provisionamento automatizado via `Vagrantfile` e scripts `*.sh`

## 🔧 Tecnologias Utilizadas

- Vagrant + VirtualBox
- Open vSwitch (OVS)
- FRRouting (BGP)
- iptables + ip_forward
- PPPoE + FreeRADIUS
- BIND9 DNS Server
- conntrack (monitoramento de NAT)
- Bash scripts para provisionamento

## 📁 Estrutura do Projeto

```

```

## 🛠️ Como Subir o Ambiente

1. Clone o repositório:

```bash
git clone https://github.com/guiredx/nfv-tcc.git
cd nfv-tcc
```

2. Certifique-se de ter instalado:
   - Vagrant
   - VirtualBox
   - Open vSwitch
   - Linux com suporte a TAP interfaces

3. Suba o ambiente:

```bash
vagrant up
```

4. Para acessar uma VM:

```bash
vagrant ssh firewall
```

## 🧪 Casos de Teste Demonstráveis

- Conexão PPPoE do cliente com autenticação
- Acesso à internet via CGNAT
- Resolução de nomes via DNS local
- Monitoramento de conexões NAT com `conntrack`
- Roteamento dinâmico com BGP
- Bloqueio de sites via DNS + firewall + redirecionamento

## 🧠 Objetivo Acadêmico

Este projeto foi desenvolvido como parte do Trabalho de Conclusão de Curso (TCC), com o objetivo de demonstrar a aplicação prática do conceito de **NFV** e das boas práticas de automação de rede.

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

## 🙋‍♂️ Autor

**Guilherme Aguiar**  
Engenheiro de Dados e entusiasta de redes, virtualização e automação.  
[LinkedIn](https://www.linkedin.com/in/guilhermesaguiar) • [GitHub](https://github.com/guiredx)
