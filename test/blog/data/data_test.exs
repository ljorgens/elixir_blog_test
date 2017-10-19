defmodule Blog.DataTest do
  use Blog.DataCase

  alias Blog.Data

  describe "posts" do
    alias Blog.Data.Blog

    @valid_attrs %{author: "some author", content: "some content", title: "some title"}
    @update_attrs %{author: "some updated author", content: "some updated content", title: "some updated title"}
    @invalid_attrs %{author: nil, content: nil, title: nil}

    def blog_fixture(attrs \\ %{}) do
      {:ok, blog} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_blog()

      blog
    end

    test "list_posts/0 returns all posts" do
      blog = blog_fixture()
      assert Data.list_posts() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = blog_fixture()
      assert Data.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      assert {:ok, %Blog{} = blog} = Data.create_blog(@valid_attrs)
      assert blog.author == "some author"
      assert blog.content == "some content"
      assert blog.title == "some title"
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_blog(@invalid_attrs)
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = blog_fixture()
      assert {:ok, blog} = Data.update_blog(blog, @update_attrs)
      assert %Blog{} = blog
      assert blog.author == "some updated author"
      assert blog.content == "some updated content"
      assert blog.title == "some updated title"
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = blog_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_blog(blog, @invalid_attrs)
      assert blog == Data.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = blog_fixture()
      assert {:ok, %Blog{}} = Data.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Data.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = blog_fixture()
      assert %Ecto.Changeset{} = Data.change_blog(blog)
    end
  end
end
