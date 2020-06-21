defmodule PhxBlog.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhxBlog.Blog.Post
  alias PhxBlog.Accounts.User

  schema "comments" do
    field :body, :string
    belongs_to(:post, Post)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :post_id, :user_id])
    |> validate_required([:body, :post_id, :user_id])
  end
end
