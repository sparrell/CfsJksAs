defmodule CfsJksAs.External.WikiTreeClient do
  @moduledoc """
  WikiTree API client .

  This mirrors the Python example (https://github.com/wikitree/wikitree-api/blob/main/examples/authentication/python.py):

    1. POST clientLogin with email/password (no redirect) to get `authcode` from Location header.
    2. POST clientLogin with `authcode` (no redirect) to get authenticated cookies.
    3. Use the cookies to call `getProfile`.

  Credentials are read from env by default:
    * LOGIN_EMAIL
    * LOGIN_PASSWORD
  """

  require Logger

  @api_url "https://api.wikitree.com/api.php"

  @type session :: %{
          cookies: %{optional(String.t()) => String.t()},
          cookie_header: String.t(),
          username: String.t()
        }

  @doc """
  Authenticates with WikiTree and returns a session struct:

      {:ok, %{
        cookies: %{...},
        cookie_header: "wikitree_wtb__session=...; wikitree_wtb_Token=...; ...",
        username: "SomeUser-1"
      }}

  Credentials default to LOGIN_EMAIL / LOGIN_PASSWORD env vars.
  """
  @spec authenticate(String.t() | nil, String.t() | nil) ::
          {:ok, session()} | {:error, term()}
  def authenticate(email \\ nil, password \\ nil) do
    email = email || System.get_env("LOGIN_EMAIL")
    password = password || System.get_env("LOGIN_PASSWORD")

    if is_nil(email) or is_nil(password) do
      {:error, :missing_credentials}
    else
      with {:ok, authcode} <- get_authcode(email, password),
           {:ok, cookies} <- finalize_auth(authcode),
           {:ok, username} <- fetch_cookie(cookies, "wikidb_wtb_UserName") do
        username_decoded = URI.decode(username)

        Logger.info("WikiTree: authenticated as #{username_decoded}")

        {:ok,
         %{
           cookies: cookies,
           cookie_header: build_cookie_header(cookies),
           username: username_decoded
         }}
      else
        {:error, reason} -> {:error, reason}
      end
    end
  end

  @doc """
  Fetches a profile by key (e.g. \"Windsor-1\").

  You can pass a session returned by `authenticate/2` for authenticated access,
  or `nil` for anonymous access.

      {:ok, profile_map} | {:error, reason}
  """
  @spec get_profile(String.t(), session() | nil) :: {:ok, map()} | {:error, term()}
  def get_profile(key, session \\ nil) do
    fields = "Id,Name,FirstName,LastNameAtBirth,LastNameCurrent,BirthDate"

    form = %{
      "action" => "getProfile",
      "key" => key,
      "fields" => fields
    }

    headers =
      case session do
        %{cookie_header: header} -> [cookie: header]
        _ -> []
      end

    case Req.post(@api_url, form: form, headers: headers, decode_json: true) do
      {:ok, %{status: 200, body: body}} when is_list(body) ->
        # TODO: Check this as Python example returns a list; first element is the result map
        {:ok, List.first(body)}

      {:ok, %{status: status, body: body}} ->
        {:error, {:http_status, status, body}}

      {:error, err} ->
        {:error, err}
    end
  end

  defp get_authcode(email, password) do
    form = %{
      "action" => "clientLogin",
      "doLogin" => "1",
      "wpEmail" => email,
      "wpPassword" => password
    }

    case Req.post(@api_url, form: form, redirect: false) do
      {:ok, resp} when resp.status == 302 ->
        location =
          resp.headers
          |> Map.get("location", [])
          |> List.first()

        cond do
          is_nil(location) ->
            {:error, :no_location_header}

          true ->
            case String.split(location, "authcode=", parts: 2) do
              [_, authcode] -> {:ok, String.trim(authcode)}
              _ -> {:error, :no_authcode_in_location}
            end
        end

      {:ok, %{status: status, body: body}} ->
        {:error, {:unexpected_status, status, body}}

      {:error, err} ->
        {:error, err}
    end
  end

  defp finalize_auth(authcode) do
    form = %{"action" => "clientLogin", "authcode" => authcode}
    dbg(authcode)

    case Req.post(@api_url, form: form, redirect: false) do
      {:ok, resp} when resp.status in 200..302 ->
        cookies = cookies_from_response(resp)

        if map_size(cookies) == 0 do
          {:error, :no_cookies_set}
        else
          {:ok, cookies}
        end

      {:ok, %{status: status, body: body}} ->
        {:error, {:unexpected_status, status, body}}

      {:error, err} ->
        {:error, err}
    end
  end

  defp fetch_cookie(cookies, name) do
    case Map.fetch(cookies, name) do
      {:ok, value} -> {:ok, value}
      :error -> {:error, {:missing_cookie, name}}
    end
  end

  defp cookies_from_response(%Req.Response{headers: headers}) do
    headers
    |> Map.get("set-cookie", [])
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn cookie_str ->
      # only take the first "name=value" segment; ignore attributes
      first_part =
        cookie_str
        |> String.split(";", parts: 2)
        |> List.first()

      case String.split(first_part, "=", parts: 2) do
        [name, value] -> {name, value}
        [name] -> {name, ""}
      end
    end)
    |> Enum.into(%{})
  end

  defp build_cookie_header(cookies) do
    cookies
    |> Enum.map(fn {k, v} -> "#{k}=#{v}" end)
    |> Enum.join("; ")
  end
end
