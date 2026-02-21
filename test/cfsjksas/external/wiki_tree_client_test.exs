defmodule CfsJksAs.External.WikiTreeClientTest do
  use ExUnit.Case, async: false
  alias CfsJksAs.External.WikiTreeClient

  @user %{name: "Simba", id: "simba-mkali", email: "simba@email.com", password: "1234"}
  @auth_code "123abcd"
  @cookie_header "wikidb_wtb__session=2aievg24"

  describe "authentication/2" do
    test "returns session on successful login" do
      # Step 1 -set up mock auth response data.return authcode via 302 + location header
      auth_request()
      # Step 2 – finalize auth
      finalize_auth()

      assert {:ok, session} =
               WikiTreeClient.authenticate(@user.email, @user.password)

      assert session.user_name == @user.name
      assert session.user_id == @user.id
      assert session.cookie_header == @cookie_header
    end

    test "returns error when authcode missing in location header" do
      Req.Test.expect(WikiTreeClient, fn conn ->
        Plug.Conn.send_resp(conn, 302, "get auth code")
      end)

      assert {:error, :no_location_header} =
               WikiTreeClient.authenticate(@user.email, @user.password)
    end

    test "returns error when get auth code request has a different status than 302" do
      Req.Test.expect(WikiTreeClient, fn conn ->
        Plug.Conn.send_resp(conn, 200, "auth code")
      end)

      assert {:error, {:unexpected_status, 200, "auth code"}} =
               WikiTreeClient.authenticate(@user.email, @user.password)
    end

    test "returns error when auth verification fails" do
      # Step 1 - Get the auth code
      auth_request()

      # Step 2 – failed auth
      Req.Test.expect(WikiTreeClient, fn conn ->
        body = %{
          "clientLogin" => %{
            "result" => "Failed"
          }
        }

        Req.Test.json(conn, body)
      end)

      assert {:error, _reason} =
               WikiTreeClient.authenticate(@user.email, @user.password)
    end

    test "returns error when both args are nil" do
      assert {:error, :missing_credentials} = WikiTreeClient.authenticate(nil, nil)
    end

    test "returns error when only email is given" do
      assert {:error, :missing_credentials} = WikiTreeClient.authenticate("a@b.com", nil)
    end

    test "returns error when only password is given" do
      assert {:error, :missing_credentials} = WikiTreeClient.authenticate(nil, "secret")
    end
  end

  defp auth_request do
    Req.Test.expect(WikiTreeClient, fn conn ->
      assert conn.method == "POST"
      assert conn.request_path == "/api.php"
      assert conn.params["action"] == "clientLogin"
      assert conn.params["doLogin"] == "1"

      conn
      |> Plug.Conn.put_resp_header("location", "https://example.com?authcode=#{@auth_code}")
      |> Plug.Conn.send_resp(302, "get auth code")
    end)
  end

  defp finalize_auth do
    Req.Test.expect(WikiTreeClient, fn conn ->
      assert conn.params["authcode"] == @auth_code

      body = %{
        "clientLogin" => %{
          "result" => "Success",
          "username" => @user.name,
          "userid" => @user.id
        }
      }

      conn
      |> Plug.Conn.put_resp_header("set-cookie", @cookie_header)
      |> Req.Test.json(body)
    end)
  end
end
