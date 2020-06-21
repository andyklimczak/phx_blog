defmodule PhxBlogWeb.CommentController do
  use PhxBlogWeb, :controller

  alias PhxBlog.Blog
  alias PhxBlog.Blog.Comment

  def index(conn, %{"post_id" => post_id}) do
    post = Blog.get_post!(post_id)
    comments = Blog.list_comments(post)
    render(conn, "index.html", comments: comments, post: post)
  end

  def new(conn, %{"post_id" => post_id}) do
    post = Blog.get_post!(post_id)
    changeset = Blog.change_comment(%Comment{post_id: post.id})
    render(conn, "new.html", changeset: changeset, post: post)
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    post = Blog.get_post!(post_id)
    user = conn.assigns.current_user
    case Blog.create_comment(Map.merge(comment_params, %{"post_id" => post_id, "user_id" => user.id})) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    render(conn, "show.html", comment: comment)
  end

  def edit(conn, %{"post_id" => post_id, "id" => id}) do
    post = Blog.get_post!(post_id)
    comment = Blog.get_comment!(post, id)
    changeset = Blog.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset, post: post)
  end

  def update(conn, %{"post_id" => post_id, "id" => id, "comment" => comment_params}) do
    post = Blog.get_post!(post_id)
    comment = Blog.get_comment!(post, id)

    case Blog.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset, post: post)
    end
  end

  def delete(conn, %{"post_id" => post_id, "id" => id}) do
    post = Blog.get_post!(post_id)
    comment = Blog.get_comment!(post, id)
    {:ok, _comment} = Blog.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :show, post))
  end
end
