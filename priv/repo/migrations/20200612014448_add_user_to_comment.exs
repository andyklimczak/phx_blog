defmodule PhxBlog.Repo.Migrations.AddUserToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :user_id, references(:users)
    end
  end
end
