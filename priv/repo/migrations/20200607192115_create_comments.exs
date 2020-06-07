defmodule PhxBlog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text
      add :post_id, references(:posts), null: false

      timestamps()
    end

    create index(:comments, [:post_id])
  end
end
