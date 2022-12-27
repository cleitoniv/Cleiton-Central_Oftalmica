  alias Tecnovix.Endpoints.ProtheusProd
  alias Tecnovix.App.ScreensProd
  alias Tecnovix.PedidosDeVendaModel
  alias Tecnovix.Endpoints.Protheus
  alias Tecnovix.App.ScreensTest
  alias Tecnovix.ClientesModel
  alias TecnovixWeb.PedidosDeVendaController

  # {:ok, auth} = ProtheusProd.token(%{username: "TECNOVIX", password: "TecnoVix200505"})
  # token = Jason.decode!(auth.body)

  # ProtheusProd.get_client_products(%{cliente: "008828", loja: "01", count: 50, token: token["access_token"]})

  # {:ok, result} = ProtheusProd.get_contract_table_finan(%{cliente: "008828", loja: "01"}, token["access_token"])
  # result.body
  # |> Jason.decode!()

  # {:ok, result} = ProtheusProd.get_cliente(%{cnpj_cpf: "99667484076", token: token["access_token"]})
  # result.body
  # |> Jason.decode!()

  produtos_params =
    %{
      "count" => 10,
      "resources" => [
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "010C"},
                %{"id" => "TRATAM", "value" => "5.00000000"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASTEST", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "1"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "1"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "010T"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{"id" => "BM_DESC", "order" => 4, "value" => "BIOVIEW TORICA CX6"},
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "150.00000000"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "1715.00000000"},
                %{"id" => "VALORA", "order" => 8, "value" => "151.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDEwQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "011C"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASTEST", "value" => "0"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "011T"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{
                  "id" => "BM_DESC",
                  "order" => 4,
                  "value" => "BIOVIEW ASFERICA CX6"
                },
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "0"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "770.00000000"},
                %{"id" => "VALORA", "order" => 8, "value" => "82.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDExQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "013C"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "013T"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{
                  "id" => "BM_DESC",
                  "order" => 4,
                  "value" => "BIOVIEW MULTIFOCAL CX6"
                },
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "0"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "0"},
                %{"id" => "VALORA", "order" => 8, "value" => "184.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDEzQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "020C"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "010T"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{"id" => "BM_DESC", "order" => 4, "value" => "BIOSOFT TORICA CX3"},
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "455.00000000"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "1715.00000000"},
                %{"id" => "VALORA", "order" => 8, "value" => "91.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDIwQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "021C"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "011T"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{
                  "id" => "BM_DESC",
                  "order" => 4,
                  "value" => "BIOSOFT ASFERICA CX3"
                },
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "SALDO", "order" => 6, "value" => "1320.00000000"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "770.00000000"},
                %{"id" => "VALORA", "order" => 8, "value" => "50.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDIxQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "030C"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "030T"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{"id" => "BM_DESC", "order" => 4, "value" => "SILIDROGEL SIHY CX6"},
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "0"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "0"},
                %{"id" => "VALORA", "order" => 8, "value" => "110.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDMwQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "032C"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "030T"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{"id" => "BM_DESC", "order" => 4, "value" => "BIOSOFT SIHY 45 CX3"},
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "28.00000000"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "0"},
                %{"id" => "VALORA", "order" => 8, "value" => "51.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDMyQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "033C"},
                %{"id" => "BM_YGRPTES", "order" => 2, "value" => "033T"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{
                  "id" => "BM_DESC",
                  "order" => 4,
                  "value" => "SILIDROGEL TORICA CX6"
                },
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "0"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "0"},
                %{"id" => "VALORA", "order" => 8, "value" => "166.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDMzQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "051C"},
                %{"id" => "BM_YGRPTES", "order" => 2},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{
                  "id" => "BM_DESC",
                  "order" => 4,
                  "value" => "LC 1-DIA BIOSOFT 1-DAY CX10"
                },
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "46.00000000"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "0"},
                %{"id" => "VALORA", "order" => 8, "value" => "36.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDUxQw=="
        },
        %{
          "id" => "WSAPPPROUTOS",
          "models" => [
            %{
              "fields" => [
                %{"id" => "BM_GRUPO", "order" => 1, "value" => "060C"},
                %{"id" => "HASGRAU", "value" => "1"},
                %{"id" => "HASEIXO", "value" => "1"},
                %{"id" => "HASRAIO", "value" => "0"},
                %{"id" => "HASCOLOR", "value" => "0"},
                %{"id" => "HASCURVA", "value" => "1"},
                %{"id" => "HASADICAO", "value" => "0"},
                %{"id" => "HASCILIND", "value" => "1"},
                %{"id" => "HASDIAMET", "value" => "0"},
                %{"id" => "BM_YGRPTES", "order" => 2},
                %{"id" => "TPPROD", "order" => 3, "value" => "C"},
                %{
                  "id" => "BM_DESC",
                  "order" => 4,
                  "value" => "BIOSOFT COLOR 38 CX2"
                },
                %{"id" => "B1_UM", "order" => 5, "value" => "CX"},
                %{"id" => "SALDO", "order" => 6, "value" => "0"},
                %{"id" => "SALDOTESTE", "order" => 7, "value" => "0"},
                %{"id" => "VALORA", "order" => 8, "value" => "36.00000000"},
                %{"id" => "VALORC", "order" => 9, "value" => "0"},
                %{"id" => "VALORE", "order" => 10, "value" => "0"}
              ],
              "id" => "MFEST",
              "modeltype" => "FIELDS"
            }
          ],
          "operation" => 1,
          "pk" => "MDYwQw=="
        }
      ],
      "startindex" => 1,
      "total" => 14
    }

    card_params =
      %{
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

    cliente_params =
      %Tecnovix.ClientesSchema{
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

  filtro_params = "Todos"
  product_invoiced_params = %{}
  items =
  [
    %{
      "items" => [
        %{
          "descricao_generica_do_produto_id" => 1,
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
          "tests" => "Não",
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
  ]
    {:ok, clientecard} = ClientesModel.get_cliente(6113)
    |>IO.inspect(label: "cliente")
    {:ok, cards} = ScreensTest.get_cards(clientecard)
    [head | tail] = cards
    card = Map.delete(head, :__meta__)
    |> Map.delete(:__struct__)
    IO.inspect(card, label: "cartones")

    IO.inspect(label: "items vindos do change_operation")


  # {:ok, data, filters} = ScreensTest.get_product_grid(produtos_params, cliente_params, filtro_params, product_invoiced_params)
  items = PedidosDeVendaModel.change_operation_and_tipo_venda(items)
  |> IO.inspect(label: "items vindos do change_operation")
  {:ok, items_order} = PedidosDeVendaModel.items_order(items)
  IO.inspect(items_order, label: "items da order")
  {:ok, order} = PedidosDeVendaModel.order(items_order, cliente_params, 200, "2")
  {:ok, _payment} = PedidosDeVendaModel.payment(%{"id_cartao" => card.id}, order, "123", "2")
  {:ok, pedido} = PedidosDeVendaModel.create_pedido(items, cliente_params, order, "2", 200)
  IO.inspect(pedido, label: "retorno de pedido create_pedido")
  # clientecard = ClientesModel.get_cliente(6117)
  # {:ok, cards} = ScreensTest.get_cards(clientecard)
  # |> IO.inspect()
  # {:ok, _logs} = LogsClienteModel.create(
  #     ip,
  #     usuario,
  #     cliente,
  #     "Pedido id #{pedido.id} feito. Em #{installment}x e com R$ #{taxa_entrega / 100} de pagamento no frete e cartão de credito id #{id_cartao}."
  #   ),
  # {:ok, _notificacao} = NotificacoesClienteModel.verify_notification(pedido, cliente)


  # Enum.map(data, fn x -> x

  # case x["BM_YGRPTES"] == "033T" do
  #   true -> altered_value = x["value"] * 2
  #   altered_value
  #   _ -> []
  # end

  #  end)
  # |> IO.inspect()

  # {:ok, product_invoiced} = PedidosDeVendaModel.order_product_invoiced(6117)
  # protheus.get_client_products
  #ScreensProd.get_product_grid()
  #usar a função get_products_grid, do arquivo "app_test" e receber o json formatado
