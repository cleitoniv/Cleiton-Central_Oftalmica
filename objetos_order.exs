Map<String, dynamic> generateParams(Map data, PaymentMethod paymentMethod) {
  List items = data['cart'].map<Map>((e) {
    if (e["operation"] == "01" || e["operation"] == "13") {
      return {
        'type': e['type'],
        'operation': e['operation'],
        'paciente': {
          'nome': e['pacient']['name'],
          'numero': e['pacient']['number'],
          'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
        },
        'items': [
          {
            'grupo_teste': e['product'].groupTest,
            'produto_teste': e['product'].produtoTeste,
            'produto': e['product'].title,
            'quantidade': e['quantity'],
            'quantity_for_eye': e['quantity_for_eye'],
            'grupo': e['tests'] == "Não"
                ? e['product'].group
                : e['product'].groupTest,
            'valor_credito_finan': e['product'].valueFinan ?? 0,
            'valor_credito_prod': e['product'].valueProduto ?? 0,
            'duracao': e['product'].duracao,
            'prc_unitario': e['product'].value,
            "valor_test": e['product'].valueTest * 100,
            'tests': e['tests']
          }
        ],
        'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
        'olho_direito': e['Olho direito'] ?? null,
        'olho_esquerdo': e['Olho esquerdo'] ?? null,
        'olho_ambos': e['Mesmo grau em ambos'] ?? null
      };
    } else if (e["operation"] == "07") {
      return {
        'type': e['type'],
        'operation': e['operation'],
        'paciente': {
          'nome': e['pacient']['name'],
          'numero': e['pacient']['number'],
          'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
        },
        'items': [
          {
            'grupo_teste': e['product'].groupTest,
            'produto_teste': e['product'].produtoTeste,
            'produto': e['product'].title,
            'quantidade': e['quantity'],
            'quantity_for_eye': e['quantity_for_eye'],
            'grupo': e['tests'] == "Não"
                ? e['product'].group
                : e['product'].groupTest,
            'valor_credito_finan': e['product'].valueFinan ?? 0,
            'valor_credito_prod': e['product'].valueProduto ?? 0,
            'duracao': e['product'].duracao,
            'prc_unitario': e['product'].value,
            "valor_test": e['product'].valueTest * 100,
            'tests': e['tests']
          }
        ],
        'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
        'olho_direito': e['Olho direito'] ?? null,
        'olho_esquerdo': e['Olho esquerdo'] ?? null,
        'olho_ambos': e['Mesmo grau em ambos'] ?? null
      };
    } else if (e["operation"] == "04") {
      return {
        'type': e['type'],
        'operation': e['operation'],
        'paciente': {
          'nome': e['pacient']['name'],
          'numero': e['pacient']['number'],
          'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
        },
        'items': [
          {
            'grupo_teste': e['product'].groupTest,
            'produto_teste': e['product'].produtoTeste,
            'produto': e['product'].title,
            'quantidade': e['quantity'],
            'quantity_for_eye': e['quantity_for_eye'],
            'grupo': e['tests'] == "Não"
                ? e['product'].group
                : e['product'].groupTest,
            'valor_credito_finan': e['product'].valueFinan ?? 0,
            'valor_credito_prod': e['product'].valueProduto ?? 0,
            'duracao': e['product'].duracao,
            'prc_unitario': e['product'].value,
            "valor_test": e['product'].valueTest * 100,
            'tests': e['tests']
          }
        ],
        'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
        'olho_direito': e['Olho direito'] ?? null,
        'olho_esquerdo': e['Olho esquerdo'] ?? null,
        'olho_ambos': e['Mesmo grau em ambos'] ?? null
      };
    } else if (e['operation'] == '03') {
      return {
        'type': e['type'],
        'operation': e['operation'],
        'paciente': {
          'nome': e['pacient']['name'],
          'numero': e['pacient']['number'],
          'data_nascimento': parseDtNascimento(e['pacient']['birthday'])
        },
        'items': [
          {
            'grupo_teste': e['product'].groupTest,
            'produto_teste': e['product'].produtoTeste,
            'produto': e['product'].title,
            'quantidade': e['quantity'],
            'quantity_for_eye': e['quantity_for_eye'],
            'grupo': e['tests'] == "Não"
                ? e['product'].group
                : e['product'].groupTest,
            'valor_credito_finan': e['product'].valueFinan ?? 0,
            'valor_credito_prod': e['product'].valueProduto ?? 0,
            'duracao': e['product'].duracao,
            'prc_unitario': e['product'].value,
            "valor_test": e['product'].valueTest * 100,
            'tests': e['tests'] ?? 'N'
          }
        ],
        'olho_diferentes': e['Graus diferentes em cada olho'] ?? null,
        'olho_direito': e['Olho direito'] ?? null,
        'olho_esquerdo': e['Olho esquerdo'] ?? null,
        'olho_ambos': e['Mesmo grau em ambos'] ?? null
      };
    } else {
      return {
        'operation': e['operation'],
        'type': e['type'],
        'items': [
          {
            'percentage_test': e['percentage_test'],
            'produto': e['product'].title,
            'codigo': e['product'].produto,
            'grupo': e['product'].group,
            'quantidade': e['quantity'],
            'valor_credito_finan': e['product'].valueFinan ?? 0,
            'valor_credito_prod': e['product'].valueProduto ?? 0,
            'prc_unitario': e['product'].value,
            'duracao': e['product'].duracao
          }
        ]
      };
    }
  }).toList();
  return {
    'items': items,
    'id_cartao':
        paymentMethod.creditCard != null ? paymentMethod.creditCard.id : 0,
    'ccv': data['ccv'],
    'installment': data['installment'],
    'taxa_entrega': data['taxa_entrega']
  };
}


objeto_create_credit_card =
  {
    "ccv" => "123",
  "id_cartao" => 35,
  "installment" => 2,
  "items" => [
    %{
      "items" => [
        %{
          "descricao_generica_do_produto_id" => 80041,
          "duracao" => "180.00000",
          "filial" => "teste",
          "nocontrato" => "teste",
          "nota_fiscal" => "123456789",
          "num_pedido" => "123456",
          "prc_unitario" => 15100,
          "produto" => "BIOVIEW ASFERICA CX6",
          "quantidade" => 1,
          "quantity_for_eye" => %{"direito" => 1, "esquerdo" => 2},
          "serie_nf" => "123",
          "tests" => "N├úo",
          "type" => "A"
        }
      ],
      "olho_diferentes" => %{
        "direito" => %{"axis" => 180, "cylinder" => 5.5, "degree" => 0.5},
        "esquerdo" => %{"axis" => 180, "cylinder" => 2.5, "degree" => 2.5}
      },
      "operation" => "01",
      "paciente" => %{
        "data_nascimento" => "1998-07-07",
        "nome" => "Victor",
        "numero" => "132"
      },
      "type" => "A"
    }
  ],
  "taxa_entrega" => 200
}
cliente/usuario_create_cc =
  %{
    id: 6117,
    uid: "6gpStUXX5XXbl0hvVGO9iMpJncv1",
    codigo: "008828",
    loja: "01",
    fisica_jurid: "F",
    cnpj_cpf: "99667484076",
    data_nascimento: ~D[1995-03-25],
    nome: "Jose Renato Madeira Valerio",
    nome_empresarial: "Jose Renato Madeira Valerio",
    email: "renatomadeira73@gmail.com",
    email_fiscal: "renatomadeira73@gmail.com",
    endereco: ", 10",
    numero: "10",
    complemento: "loja",
    bairro: "Santa Lucia",
    estado: "ES",
    cep: "29056230",
    cdmunicipio: "05309",
    municipio: "VITORIA",
    ddd: "27",
    telefone: "998339013",
    bloqueado: "2",
    sit_app: "A",
    cod_cnae: nil,
    ramo: "2",
    vendedor: "000033",
    crm_medico: "555555",
    dia_remessa: nil,
    wirecard_cliente_id: nil,
    fcm_token: nil,
    cadastrado: true,
    role: "CLIENTE",
    apelido: nil,
    inserted_at: ~U[2022-12-26 16:39:37Z],
    updated_at: ~U[2022-12-26 16:39:37Z]
  }
