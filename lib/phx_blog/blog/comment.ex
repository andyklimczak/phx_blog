defmodule PhxBlog.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhxBlog.Blog.Post

  schema "comments" do
    field :body, :string
    belongs_to(:post, Post)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
