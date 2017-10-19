defmodule BlogWeb.BlogControllerTest do
  use BlogWeb.ConnCase

  alias Blog.Data

  @create_attrs %{author: "some author", content: "some content", title: "some title"}
  @update_attrs %{author: "some updated author", content: "some updated content", title: "some updated title"}
  @invalid_attrs %{author: nil, content: nil, title: nil}

  def fixture(:blog) do
    {:ok, blog} = Data.create_blog(@create_attrs)
    blog
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, blog_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new blog" do
    test "renders form", %{conn: conn} do
      conn = get conn, blog_path(conn, :new)
      assert html_response(conn, 200) =~ "New Blog"
    end
  end

  describe "create blog" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, blog_path(conn, :create), blog: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == blog_path(conn, :show, id)

      conn = get conn, blog_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Blog"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, blog_path(conn, :create), blog: @invalid_attrs
      assert html_response(conn, 200) =~ "New Blog"
    end
  end

  describe "edit blog" do
    setup [:create_blog]

    test "renders form for editing chosen blog", %{conn: conn, blog: blog} do
      conn = get conn, blog_path(conn, :edit, blog)
      assert html_response(conn, 200) =~ "Edit Blog"
    end
  end

  describe "update blog" do
    setup [:create_blog]

    test "redirects when data is valid", %{conn: conn, blog: blog} do
      conn = put conn, blog_path(conn, :update, blog), blog: @update_attrs
      assert redirected_to(conn) == blog_path(conn, :show, blog)

      conn = get conn, blog_path(conn, :show, blog)
      assert html_response(conn, 200) =~ "some updated author"
    end

    test "renders errors when data is invalid", %{conn: conn, blog: blog} do
      conn = put conn, blog_path(conn, :update, blog), blog: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Blog"
    end
  end

  describe "delete blog" do
    setup [:create_blog]

    test "deletes chosen blog", %{conn: conn, blog: blog} do
      conn = delete conn, blog_path(conn, :delete, blog)
      assert redirected_to(conn) == blog_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, blog_path(conn, :show, blog)
      end
    end
  end

  defp create_blog(_) do
    blog = fixture(:blog)
    {:ok, blog: blog}
  end
end
