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

    test "returns error for an email of a none existing user" do
      # Step 1 - Get the auth code
      auth_request()

      assert {:error, _reason} =
               WikiTreeClient.authenticate("some_email@email.com", "some_password")
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

  describe "get_profile/2" do
    test "returns error message for user with key that does not exists" do
      key = "example_key"
      # mock profile data
      profile_data(key, :non_existing)

      assert {:error, reason} = WikiTreeClient.get_profile(key)
      assert reason == "Wiki tree user with the key: #{key} does not exist"
    end

    test "returns full user profile details for public profiles" do
      key = "windsor"
      # mock profile data
      profile_data(key, :public)

      assert {:ok, result} = WikiTreeClient.get_profile(key)
      assert result["page_name"] == key

      profile = result["profile"]

      assert profile["Name"] == @user.name
      assert profile["FirstName"] == "Simba"
      assert profile["BirthDate"] == "1990-00-00"
      assert profile["Id"] == 49_486_485
      assert profile["LastNameAtBirth"] == "simba last name"
      assert profile["LastNameCurrent"] == "simab last name"
    end

    test "returns limited user profile details for unauthenticated user" do
      #   #mock profile data
      key = @user.name

      profile_data(key, :private, false)

      assert {:ok, result} = WikiTreeClient.get_profile(key)
      assert result["page_name"] == key

      profile = result["profile"]

      assert profile["Name"] == @user.name
      assert profile["Id"] == 49_486_485

      refute profile["FirstName"]
      refute profile["BirthDate"]
      refute profile["LastNameAtBirth"]
      refute profile["LastNameCurrent"]
    end

    test "returns a full user profile  details for a authenticated user" do
      #   #mock profile data
      key = @user.name

      profile_data(key, :private, true)

      session = %{
        cookies: %{"wikitree_wtb__session" => "2aievg24"},
        cookie_header: @cookie_header
      }

      assert {:ok, result} = WikiTreeClient.get_profile(key, session)
      assert result["page_name"] == key

      profile = result["profile"]
      assert profile["Name"] == @user.name
      assert profile["FirstName"] == "Simba"
      assert profile["BirthDate"] == "1990-00-00"
      assert profile["Id"] == 49_486_485
      assert profile["LastNameAtBirth"] == "simba last name"
      assert profile["LastNameCurrent"] == "simab last name"
    end
  end

  defp auth_request do
    Req.Test.expect(WikiTreeClient, fn conn ->
      assert conn.method == "POST"
      assert conn.request_path == "/api.php"
      assert conn.params["action"] == "clientLogin"
      assert conn.params["doLogin"] == "1"

      if expected_user?(conn.params) do
        conn
        |> Plug.Conn.put_resp_header("location", "https://example.com?authcode=#{@auth_code}")
        |> Plug.Conn.send_resp(302, "get auth code")
      else
        Plug.Conn.send_resp(conn, 200, "auth code")
      end
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

  defp expected_user?(params) do
    params["wpEmail"] == @user.email && params["wpPassword"] == @user.password
  end

  defp profile_data(key, type, auth \\ false) do
    profile_details = build_profile_details(key, type, auth)

    Req.Test.expect(WikiTreeClient, fn conn ->
      assert conn.body_params["action"] == "getProfile"
      Req.Test.json(conn, [profile_details])
    end)
  end

  defp build_profile_details(key, :non_existing, _),
    do: %{"page_name" => key, "status" => "Invalid WikiTree ID"}

  defp build_profile_details(key, :private, true) do
    %{
      "page_name" => key,
      "profile" => full_profile(),
      "status" => 0
    }
  end

  defp build_profile_details(key, :private, false) do
    %{
      "page_name" => key,
      "profile" => %{
        "Id" => 49_486_485,
        "Name" => @user.name
      },
      "status" => 0
    }
  end

  defp build_profile_details(key, :public, _) do
    profile = Map.merge(full_profile(), %{"Privacy" => 50})

    %{
      "page_name" => key,
      "profile" => profile,
      "status" => 0
    }
  end

  defp full_profile do
    %{
      "BirthDate" => "1990-00-00",
      "FirstName" => "Simba",
      "Id" => 49_486_485,
      "LastNameAtBirth" => "simba last name",
      "LastNameCurrent" => "simab last name",
      "Name" => @user.name
    }
  end
end
