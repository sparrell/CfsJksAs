defmodule CfsJksAs.External.GeniAuth do
  require Logger
  @token_url "https://www.geni.com/platform/oauth/request_token"
  @profile_url "https://www.geni.com/api/profile"

  def login(app_id \\ nil, user_name \\ nil, password \\ nil, scope \\ nil) do
    response =
      with {:ok, app_id} <- get_app_id(app_id),
           {:ok, user_name} <- get_username(username),
           {:ok, password} <- get_password(password) do
        params =
          %{
            client_id: app_id,
            username: username,
            password: password,
            grant_type: "password"
          }
          |> then(fn p -> if scope, do: Map.put(p, :scope, scope), else: p end)

        Logger.info("🔐 Requesting access token from Geni...")
        Req.get!(@token_url, params: params)
      end

    case response.status do
      200 ->
        body = response.body

        if Map.has_key?(body, "access_token") do
          {:ok, body}
          Logger.info("Geni, login successful")
        else
          Logger.error("Geni login failed")

          {:error, body["error_description"] || body["error"] || "Unknown error"}
        end

      status ->
        Logger.error("Geni login failed")
        {:error, "HTTP #{status}: #{inspect(response.body)}"}
    end
  end

  defp get_app_id(app_id) do
    app_id = app_id || System.get_env("APP_ID")

    case app_id do
      nil -> {:error, :missing_app_id}
      app_id -> {:ok, app_id}
    end
  end

  defp get_username(username) do
    username = username || System.get_env("USERNAME")

    case username do
      nil -> {:error, :missing_username}
      username -> {:ok, username}
    end
  end

  defp get_password(password) do
    password = password || System.get_env("PASSWORD")

    case password do
      nil -> {:error, :missing_password}
      password -> {:ok, password}
    end
  end
end
