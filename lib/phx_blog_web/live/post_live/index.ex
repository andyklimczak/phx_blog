defmodule PhxBlogWeb.PostLive.Index do
  use Phoenix.LiveView
  alias PhxBlogWeb.PostView
  alias PhxBlog.Blog

  def mount(_params, _session, socket) do
    Blog.subscribe()
    posts = Blog.list_posts()
    {:ok, assign(socket, posts: posts)}
  end

  def render(assigns) do
    PostView.render("index.html", assigns)
  end

  def handle_info({Posts, [:post | _], _}, socket) do
    posts = Blog.list_posts()
    {:noreply, assign(socket, posts: posts)}
  end
end