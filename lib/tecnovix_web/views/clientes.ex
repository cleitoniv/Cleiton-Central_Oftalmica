defmodule TecnovixWeb.ClientesView do
  use Tecnovix.Resource.View, model: Tecnovix.ClientesModel
  import TecnovixWeb.ErrorParserView

  def build(%{item: item}) do
    %{
      id: item.id,
      uid: item.uid,
      role: item.role,
      codigo: item.codigo,
      loja: item.loja,
      cadastrado: item.cadastrado,
      fisica_jurid: item.fisica_jurid,
      cnpj_cpf: item.cnpj_cpf,
      nome: item.nome,
      email: item.email,
      email_fiscal: item.email_fiscal,
      data_nascimento: formatting_dtnasc(item.data_nascimento),
      nome_empresarial: item.nome_empresarial,
      endereco: item.endereco,
      numero: item.numero,
      complemento: item.complemento,
      bairro: item.bairro,
      cep: item.cep,
      cdmunicipio: item.cdmunicipio,
      municipio: item.municipio,
      estado: item.estado,
      ddd: item.ddd,
      telefone: item.telefone,
      bloqueado: item.bloqueado,
      sit_app: item.sit_app,
      cod_cnae: item.cod_cnae,
      ramo: item.ramo,
      vendedor: item.vendedor,
      crm_medico: item.crm_medico,
      dia_remessa: item.dia_remessa,
      wirecard_cliente_id: item.wirecard_cliente_id,
      fcm_token: item.fcm_token,
      status: item.status,
      nome_usuario: item.nome_usuario,
      apelido: item.apelido
    }
  end

  def formatting_dtnasc(data) do
    case data do
      nil ->
        ""

      data ->
        [ano, mes, dia] = String.split(Date.to_string(data), ["/", "-"])
        "#{dia}-#{mes}-#{ano}"
    end
  end

  def render("app_clientes.json", %{clientes: clientes}) do
    render_many(clientes, __MODULE__, "clientes.json", as: :item)
  end

  def render("show_cliente.json", %{item: item}) do
    %{
      success: true,
      data: %{
        id: item.id,
        uid: item.uid,
        apelido: item.apelido,
        role: item.role,
        codigo: item.codigo,
        cadastrado: item.cadastrado,
        loja: item.loja,
        fisica_jurid: item.fisica_jurid,
        cnpj_cpf: item.cnpj_cpf,
        data_nascimento: item.data_nascimento,
        nome: item.nome,
        nome_empresarial: item.nome_empresarial,
        email: item.email,
        email_fiscal: item.email_fiscal,
        endereco: item.endereco,
        numero: item.numero,
        complemento: item.complemento,
        bairro: item.bairro,
        estado: item.estado,
        cep: item.cep,
        cdmunicipio: item.cdmunicipio,
        municipio: item.municipio,
        ddd: item.ddd,
        telefone: item.telefone,
        bloqueado: item.bloqueado,
        sit_app: item.sit_app,
        cod_cnae: item.cod_cnae,
        ramo: item.ramo,
        vendedor: item.vendedor,
        crm_medico: item.crm_medico,
        dia_remessa: item.dia_remessa,
        wirecard_cliente_id: item.wirecard_cliente_id,
        fcm_token: item.fcm_token,
        inserted_at: item.inserted_at,
        updated_at: item.updated_at,
        atend_pref_cliente: %{
          seg_manha: item.atend_pref_cliente.seg_manha,
          seg_tarde: item.atend_pref_cliente.seg_tarde,
          ter_manha: item.atend_pref_cliente.ter_manha,
          ter_tarde: item.atend_pref_cliente.ter_tarde,
          qua_manha: item.atend_pref_cliente.qua_manha,
          qua_tarde: item.atend_pref_cliente.qua_tarde,
          qui_manha: item.atend_pref_cliente.qui_manha,
          qui_tarde: item.atend_pref_cliente.qui_tarde,
          sex_manha: item.atend_pref_cliente.sex_manha,
          sex_tarde: item.atend_pref_cliente.sex_tarde,
          sab_manha: item.atend_pref_cliente.sab_manha,
          sab_tarde: item.atend_pref_cliente.sab_tarde,
          observacoes: item.atend_pref_cliente.observacoes
        }
      }
    }
  end

  def render("show_usuario.json", %{item: item}) do
    %{
      success: true,
      data: %{
        nome: item.nome,
        email: item.email,
        cargo: item.cargo,
        status: item.status,
        cliente: %{
          id: item.cliente.id,
          uid: item.cliente.uid,
          codigo: item.cliente.codigo,
          role: item.role,
          loja: item.cliente.loja,
          fisica_jurid: item.cliente.fisica_jurid,
          cnpj_cpf: item.cliente.cnpj_cpf,
          data_nascimento: item.cliente.data_nascimento,
          nome: item.cliente.nome,
          nome_empresarial: item.cliente.nome_empresarial,
          email: item.cliente.email,
          email_fiscal: item.email_fiscal,
          endereco: item.cliente.endereco,
          numero: item.cliente.numero,
          complemento: item.cliente.complemento,
          bairro: item.cliente.bairro,
          estado: item.cliente.estado,
          cep: item.cliente.cep,
          cdmunicipio: item.cliente.cdmunicipio,
          municipio: item.cliente.municipio,
          ddd: item.cliente.ddd,
          telefone: item.cliente.telefone,
          bloqueado: item.cliente.bloqueado,
          sit_app: item.cliente.sit_app,
          cod_cnae: item.cliente.cod_cnae,
          ramo: item.cliente.ramo,
          apelido: item.apelido,
          vendedor: item.cliente.vendedor,
          crm_medico: item.cliente.crm_medico,
          dia_remessa: item.cliente.dia_remessa,
          wirecard_cliente_id: item.cliente.wirecard_cliente_id,
          fcm_token: item.cliente.fcm_token,
          inserted_at: item.cliente.inserted_at,
          updated_at: item.cliente.updated_at
        },
        atend_pref_cliente: %{
          seg_manha: item.atend_pref_cliente.seg_manha,
          seg_tarde: item.atend_pref_cliente.seg_tarde,
          ter_manha: item.atend_pref_cliente.ter_manha,
          ter_tarde: item.atend_pref_cliente.ter_tarde,
          qua_manha: item.atend_pref_cliente.qua_manha,
          qua_tarde: item.atend_pref_cliente.qua_tarde,
          qui_manha: item.atend_pref_cliente.qui_manha,
          qui_tarde: item.atend_pref_cliente.qui_tarde,
          sex_manha: item.atend_pref_cliente.sex_manha,
          sex_tarde: item.atend_pref_cliente.sex_tarde,
          sab_manha: item.atend_pref_cliente.sab_manha,
          sab_tarde: item.atend_pref_cliente.sab_tarde,
          observacoes: item.atend_pref_cliente.observacoes
        }
      }
    }
  end

  multi_parser("clientes.json", [:loja, :codigo, :cnpj_cpf])

  def render("clientes.json", %{item: item}) do
    %{
      success: true,
      data: %{
        id: item.id,
        uid: item.uid,
        codigo: item.codigo,
        cadastrado: item.cadastrado,
        role: item.role,
        loja: item.loja,
        fisica_jurid: item.fisica_jurid,
        cnpj_cpf: item.cnpj_cpf,
        data_nascimento: item.data_nascimento,
        nome: item.nome,
        nome_empresarial: item.nome_empresarial,
        email: item.email,
        email_fiscal: item.email_fiscal,
        endereco: item.endereco,
        numero: item.numero,
        complemento: item.complemento,
        bairro: item.bairro,
        cep: item.cep,
        estado: item.estado,
        cdmunicipio: item.cdmunicipio,
        municipio: item.municipio,
        ddd: item.ddd,
        telefone: item.telefone,
        bloqueado: item.bloqueado,
        sit_app: item.sit_app,
        cod_cnae: item.cod_cnae,
        ramo: item.ramo,
        vendedor: item.vendedor,
        crm_medico: item.crm_medico,
        dia_remessa: item.dia_remessa,
        wirecard_cliente_id: item.wirecard_cliente_id,
        fcm_token: item.fcm_token,
        apelido: item.apelido
      }
    }
  end

  def render("current_user.json", %{
        item: item,
        credits: credits,
        notifications: notifications,
        dia_remessa: dia_remessa
      }) do
    case item do
      %Tecnovix.UsuariosClienteSchema{} ->
        TecnovixWeb.UsuariosClienteView.build(%{item: item})
        |> Map.put(:points, credits.points)
        |> Map.put(:money, credits.money)
        |> Map.put(:notifications, notifications)
        |> Map.put(:dia_remessa, dia_remessa)

      _ ->
        __MODULE__.build(%{item: item})
        |> Map.put(:points, credits.points)
        |> Map.put(:money, credits.money)
        |> Map.put(:notifications, notifications)
        |> Map.put(:dia_remessa, dia_remessa)
    end
  end
end
