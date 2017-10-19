defmodule Blog.Data.Blog do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.Data.Blog


  schema "posts" do
    field :author, :string
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Blog{} = blog, attrs) do
    blog
    |> cast(attrs, [:title, :author, :content])
    |> validate_required([:title, :author, :content])
  end
end
