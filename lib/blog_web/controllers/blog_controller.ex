defmodule BlogWeb.BlogController do
  use BlogWeb, :controller

  alias Blog.Data
  alias Blog.Data.Blog

  def index(conn, _params) do
    posts = Data.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Data.change_blog(%Blog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"blog" => blog_params}) do
    case Data.create_blog(blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Blog created successfully.")
        |> redirect(to: blog_path(conn, :show, blog))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    blog = Data.get_blog!(id)
    render(conn, "show.html", blog: blog)
  end

  def edit(conn, %{"id" => id}) do
    blog = Data.get_blog!(id)
    changeset = Data.change_blog(blog)
    render(conn, "edit.html", blog: blog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "blog" => blog_params}) do
    blog = Data.get_blog!(id)

    case Data.update_blog(blog, blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, "Blog updated successfully.")
        |> redirect(to: blog_path(conn, :show, blog))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", blog: blog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    blog = Data.get_blog!(id)
    {:ok, _blog} = Data.delete_blog(blog)

    conn
    |> put_flash(:info, "Blog deleted successfully.")
    |> redirect(to: blog_path(conn, :index))
  end
end
