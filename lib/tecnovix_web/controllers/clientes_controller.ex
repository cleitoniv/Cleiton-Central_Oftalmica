defmodule TecnovixWeb.ClientesController do
  use TecnovixWeb, :controller
  use Tecnovix.Resource.Routes, model: Tecnovix.ClientesModel

  alias Tecnovix.{
    ClientesModel,
    UsuariosClienteModel,
    AtendPrefClienteModel,
    UsuariosClienteSchema,
    ClientesSchema,
    Services.ConfirmationSMS,
    PreDevolucaoModel
  }

  alias Tecnovix.{App.Screens, Services.Devolucao, Services.Auth, Endpoints.Protheus}
  alias TecnovixWeb.Auth.Firebase
  alias Tecnovix.Endpoints.Protheus
  action_fallback Tecnovix.Resources.Fallback

  def get_period(conn, _params) do
    with {:ok, period} <- ClientesModel.get_period() do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: period}))
    else
      _ -> {:error, :invalid_parameter}
    end
  end

  def verify_email(conn, %{"email" => email}) do
    with {:ok, _email} <- ClientesModel.verify_email(email) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    end
  end

  def verify_phone(conn, %{"phone" => phone}) do
    with {:ok, phone} <- ClientesModel.verify_phone(phone) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: phone}))
    end
  end

  def termo_responsabilidade(conn, _params) do
    with {:ok, termo} <- ClientesModel.termo_responsabilidade() do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: termo}))
    end
  end

  # clicou em submit -> envia o sms -> guarda o codigo do sms na memoria -> depois de 120 apaga o codigo
  def send_sms(conn, %{"phone_number" => phone_number} = params) do
    code_sms = Enum.random(1_000..9_999)

    params =
      Map.put(params, "code_sms", code_sms)
      |> Map.put("ddd", ClientesModel.get_ddd(phone_number))
      |> Map.put("telefone", ClientesModel.formatting_phone_number(phone_number))

    with {:ok, _telefone} <-
           ClientesModel.phone_number_existing?(params["telefone"], params["ddd"]),
         {:ok, %{"codigo" => "000"}} <-
           ClientesModel.send_sms(%{phone_number: phone_number}, code_sms),
         {:ok, _} <- ClientesModel.confirmation_sms(params),
         {:ok, _} <-
           ConfirmationSMS.deleting_coding(code_sms, params["ddd"] <> params["telefone"]) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: code_sms}))
    else
      {:ok, %{"codigo" => "006"}} ->
        {:error, :not_authorized}

      {:error, :number_found} ->
        {:error, :number_found}

      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
        {:error, :service_fail}

      _ ->
        {:error, :service_fail}
    end
  end

  def confirmation_code(conn, %{"code_sms" => code_sms, "phone_number" => phone_number}) do
    with {:ok, confirmation} <-
           ClientesModel.confirmation_code(code_sms, phone_number) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: confirmation}))
    end
  end

  def insert_or_update(conn, params) do
    with {:ok, cliente} <- ClientesModel.insert_or_update(params) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("clientes.json", %{item: cliente})
    else
      {:error, %Ecto.Changeset{} = error} -> {:error, error}
      _ -> {:error, :invalid_parameter}
    end
  end

  def first_access(conn, %{"param" => params}) do
    params = Map.put(params, "ddd", ClientesModel.get_ddd(params["telefone"]))

    with {:ok, cliente} <- ClientesModel.create_first_access(params) do
      conn
      |> put_status(201)
      |> put_resp_content_type("application/json")
      |> render("clientes.json", %{item: cliente})
    end
  end

  def update_password(conn, %{"idToken" => idToken, "new_password" => new_password}) do
    with {:ok, _password} <- Firebase.update_password(%{idToken: idToken, password: new_password}) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    end
  end

  def verify_field_cadastrado(conn, %{"email" => email}) do
    with {:ok, result} <- ClientesModel.verify_field_cadastrado(email) do
      conn
      |> put_resp_content_type("applicaton/json")
      |> send_resp(200, Jason.encode!(%{success: result}))
    end
  end

  def create_user(conn, %{"param" => params}) do
    params =
      Map.put(
        params,
        "data_nascimento",
        ClientesModel.formatting_dtnasc(params["data_nascimento"])
      )
      |> Map.put("cadastrado", true)

    {:ok, jwt} = conn.private.auth
    params = Map.put(params, "email", jwt.fields["email"])
    params = Map.put(params, "uid", jwt.fields["user_id"])

    with {:ok, cliente} <- ClientesModel.insert_or_update_first(params),
         {:ok, _endereco} <-
           Tecnovix.EnderecoEntregaModel.create(Map.put(params, "cliente_id", cliente.id)) do
      conn
      |> put_status(201)
      |> put_resp_content_type("application/json")
      |> render("clientes.json", %{item: cliente})
    end
  end

  def show(conn, _params) do
    case conn.private.auth do
      {:ok, %Tecnovix.ClientesSchema{} = cliente} ->
        {:ok, map} = ClientesModel.show(cliente.id)

        user =
          Map.put(map, :atend_pref_cliente, AtendPrefClienteModel.get_by(cliente_id: cliente.id))

        conn
        |> put_status(:ok)
        |> put_resp_content_type("applicaton/json")
        |> put_view(TecnovixWeb.ClientesView)
        |> render("show_cliente.json", %{item: user})

      {:ok, %Tecnovix.UsuariosClienteSchema{} = usuario} ->
        {:ok, map} = UsuariosClienteModel.show(usuario.id)

        user =
          Map.put(map, :cliente, ClientesModel.get_by(id: usuario.cliente_id))
          |> Map.put(
            :atend_pref_cliente,
            AtendPrefClienteModel.get_by(cliente_id: usuario.cliente_id)
          )

        conn
        |> put_status(:ok)
        |> put_resp_content_type("applicaton/json")
        |> put_view(TecnovixWeb.ClientesView)
        |> render("show_usuario.json", %{item: user})

      _ ->
        {:error, :invalid_parameter}
    end
  end

  def get_clientes_app(conn, %{"filtro" => filtro}) do
    with {:ok, clientes} <- ClientesModel.get_clientes_app(filtro) do
      conn
      |> put_status(200)
      |> put_resp_content_type("application/json")
      |> render("app_clientes.json", %{clientes: clientes})
    else
      _ ->
        {:error, :not_found}
    end
  end

  def get_endereco_entrega(conn, _params) do
    stub = Screens.stub()
    protheus = Protheus.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, auth} <- Auth.token(),
         {:ok, response = %{status_code: 200}} <-
           stub.get_endereco_entrega_protheus(%{
             cnpj_cpf: cliente.cnpj_cpf,
             token: auth["access_token"]
           }),
         {:ok, cliente} <- protheus.organize_cliente(response),
         {:ok, endereco} <- stub.get_endereco_entrega(cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: endereco}))
    else
      _ -> {:error, :invalid_parameter}
    end
  end

  def current_user(conn, _params) do
    {:ok, user} = conn.private.auth
    {:ok, auth_user} = conn.private.auth_user

    case auth_user do
      %UsuariosClienteSchema{} ->
        user = Tecnovix.Repo.preload(auth_user, :cliente)

        stub = Screens.stub()

        credits_info = stub.get_credits(user.cliente)
        {:ok, notifications} = stub.get_notifications(user.cliente)
        dia_remessa = stub.get_dia_remessa(user.cliente)

        conn
        |> put_view(TecnovixWeb.ClientesView)
        |> render("current_user.json", %{
          item:
            Map.put(user.cliente, :role, "USUARIO")
            |> Map.put(:status, auth_user.status)
            |> Map.put(:nome_usuario, auth_user.nome),
          credits: credits_info,
          notifications: notifications,
          dia_remessa: dia_remessa,
        })

      _ ->
        stub = Screens.stub()

        credits_info = stub.get_credits(user) |> IO.inspect
        {:ok, notifications} = stub.get_notifications(user) |> IO.inspect
        dia_remessa = stub.get_dia_remessa(user) |> IO.inspect

        conn
        |> put_view(TecnovixWeb.ClientesView)
        |> render("current_user.json", %{
          item: user |> Map.put(:status, nil) |> Map.put(:nome_usuario, nil),
          credits: credits_info,
          notifications: notifications,
          dia_remessa: dia_remessa,
        })
    end
  end

  def verify_auth({:ok, cliente}) do
    case cliente do
      %UsuariosClienteSchema{} ->
        user = Tecnovix.Repo.preload(cliente, :cliente)
        {:ok, user.cliente}

      v ->
        {:ok, v}
    end
  end

  def products(conn, %{"filtro" => filtro}) do
    stub = Screens.stub()
    protheus = Protheus.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, auth} <- Auth.token(),
         {:ok, product_invoiced} <-
           Tecnovix.PedidosDeVendaModel.order_product_invoiced(cliente.id),
         {:ok, products} <-
           protheus.get_client_products(%{
             cliente: cliente.codigo,
             loja: cliente.loja,
             count: 50,
             token: auth["access_token"]
           }),
         {:ok, grid, filters} <-
           stub.get_product_grid(products, cliente, filtro, product_invoiced) do

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{success: true, data: grid, filters: filters})
      )
    else
      _ -> {:error, :not_found}
    end
  end

  def offers(conn, _params) do
    protheus = Protheus.stub()
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, auth} <- Auth.token(),
         {:ok, resp} <-
           protheus.get_contract_table_finan(
             %{cliente: cliente.codigo, loja: cliente.loja},
             auth["access_token"]
           ),
         {:ok, offers} <- Tecnovix.CreditoFinanceiroModel.get_package(resp) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: offers}))
    end
  end

  def products_credits(conn, _params) do
    stub = Screens.stub()
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, products} <- stub.get_products_credits(cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: products}))
    end
  end

  def info_product(conn, %{"id" => id}) do
    stub = Screens.stub()
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, info} <- stub.get_info_product(cliente, id) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: info}))
    end
  end

  def detail_order(conn, %{"filtro" => filtro}) do
    stub = Screens.stub()
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, detail} <- stub.get_detail_order(cliente, filtro) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: detail}))
    end
  end

  def get_cards(conn, _params) do
    stub = Screens.stub()

    {:ok, cliente} =
      case conn.private.auth do
        {:ok, %ClientesSchema{} = cliente} ->
          {:ok, cliente}

        {:ok, %UsuariosClienteSchema{} = usuario} ->
          ClientesModel.get_cliente(usuario.cliente_id)
      end

    with {:ok, cards} <- stub.get_cards(cliente) do
      conn
      |> put_status(200)
      |> put_view(TecnovixWeb.CartaoCreditoClienteView)
      |> put_resp_content_type("application/json")
      |> render("cards.json", %{item: cards})
    end
  end

  def get_payments(conn, %{"filtro" => filtro}) do
    stub = Screens.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, creditsFinan} <- Tecnovix.CreditoFinanceiroModel.get_payments(cliente.id),
         {:ok, pedidos} <- Tecnovix.PedidosDeVendaModel.get_payments_credit_card(cliente.id),
         {:ok, pedidos_com_boleto} <-
           Tecnovix.PedidosDeVendaModel.get_payments_boleto(cliente.id),
         {:ok, payments} <- stub.get_payments(creditsFinan, pedidos, pedidos_com_boleto, filtro) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: payments}))
    end
  end

  def get_mypoints(conn, _params) do
    stub = Screens.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, pedidos_points} <- stub.get_mypoints(cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: pedidos_points}))
    end
  end

  def convert_points(conn, %{"points" => points}) do
    stub = Screens.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, points} <- stub.convert_points(cliente, points) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: points}))
    end
  end

  def get_notifications(conn, _params) do
    stub = Screens.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, notifications} <- stub.get_notifications(cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: notifications}))
    end
  end

  def get_product_serie(conn, %{"num_serie" => num_serie}) do
    num_serie = String.upcase(num_serie)
    stub = Screens.stub()
    stub_protheus = Protheus.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, auth} <- Auth.token(),
         {:ok, %{status_code: 200} = product_serial} <-
           stub_protheus.get_product_by_serial(%{
             cliente: cliente.codigo,
             loja: cliente.loja,
             serial: num_serie,
             token: auth["access_token"]
           }),
         {:ok, product} <- stub.get_product_serie(cliente, product_serial, num_serie),
         {:ok, true} <- PreDevolucaoModel.serial_authorized?(num_serie) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: product}))
    else
      {:ok, %{status_code: 401}} ->
        {:error, :not_authorized}

      {:ok, %{status_code: 400}} ->
        {:error, :product_serial_error}

      {:error, %Ecto.Changeset{} = error} ->
        {:error, error}

      {:error, :repeated} ->
        data =
          Map.new()
          |> Map.put("mensagem", "Esse produto já consta em uma devolução")
          |> Map.put("success", false)

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(%{success: true, data: data}))

      _ ->
        {:error, :not_found}
    end
  end

  def devolution_continue(conn, %{"products" => products, "tipo" => "T" = tipo}) do
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, devolution} <- Devolucao.insert(products, cliente.id, tipo) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{"success" => true, "data" => devolution}))
    end
  end

  def devolution_continue(conn, %{"products" => products, "tipo" => "C"}) do
    {:ok, cliente} = conn.private.auth

    with {:ok, _} <- PreDevolucaoModel.insert_dev(cliente, products) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{"success" => true, "data" => "Inserido."}))
    end
  end

  def devolution_continue(_conn, %{"products" => products, "tipo" => _tipo})
      when is_list(products) do
    {:error, :invalid_parameter}
  end

  def next_step(conn, %{"group" => group, "quantidade" => quantidade, "devolution" => devolution}) do
    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, next} <- Devolucao.next(cliente.id, group, quantidade, devolution) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{"success" => true, "data" => next, "status" => "continue"})
      )
    else
      :finish ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          200,
          Jason.encode!(%{"success" => true, "data" => %{}, "status" => "completed"})
        )
    end
  end

  def get_extrato_finan(conn, _params) do
    stub = Screens.stub()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, finan} <- stub.get_extrato_finan(cliente) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: finan}))
    end
  end

  def get_extrato_prod(conn, _params) do
    protheus = Protheus.stub()
    stub = Screens.stub()
    data_hoje = Date.utc_today()

    {:ok, cliente} = verify_auth(conn.private.auth)

    with {:ok, auth} <- Auth.token(),
         {:ok, products} <-
           protheus.get_client_products(%{
             cliente: cliente.codigo,
             loja: cliente.loja,
             count: 50,
             token: auth["access_token"]
           }),
         {:ok, grid, _filters} <- stub.get_product_grid(products, cliente, "Todos", %{}),
         {:ok, prod} <- stub.get_extrato_prod(cliente, grid) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(
        200,
        Jason.encode!(%{
          success: true,
          data: prod,
          date: stub.parse_month(data_hoje) <> Integer.to_string(data_hoje.year)
        })
      )
    end
  end

  def get_and_send_email_dev(_conn, %{"email" => email}) when is_nil(email) or email == "" do
    {:error, :invalid_parameter}
  end

  def get_and_send_email_dev(conn, %{"email" => email}) do
    stub = Screens.stub()

    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join()

    {:ok, cliente} = verify_auth(conn.private.auth)
    {:ok, usuario} = conn.private.auth_user

    with {:ok, _} <- stub.get_and_send_email_dev(email),
         {:ok, _} <- stub.get_and_send_email_dev(cliente.email),
         {:ok, _logs} <-
           Tecnovix.LogsClienteModel.create(
             ip,
             usuario,
             cliente,
             "Email de devolução enviado para #{email}"
           ) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true}))
    end
  end

  def get_graus(conn, %{"grupo" => grupo}) do
    stub = Screens.stub()

    with {:ok, graus} <- stub.get_graus(grupo) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: graus}))
    end
  end

  def get_endereco_by_cep(conn, %{"cep" => cep}) do
    with {:ok, %{status_code: 200} = endereco} <- ClientesModel.get_endereco_by_cep(cep) do
      endereco = Jason.decode!(endereco.body)

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(%{success: true, data: formatting_endereco(endereco)}))
    else
      {:error, %{status_code: 401}} -> {:error, :not_authorized}
      _ -> {:error, :not_found}
    end
  end

  defp formatting_endereco(endereco) do
    endereco
    |> Map.put("ibge", String.slice(endereco["ibge"], 2..7))
  end
end
