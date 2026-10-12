defmodule ChirpWeb.PostLive.Index do
  use ChirpWeb, :live_view

  alias Chirp.Timeline

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Timeline
        <:actions>
          <.button variant="primary" navigate={~p"/posts/new"}>
            <.icon name="hero-plus" /> New Post
          </.button>
        </:actions>
      </.header>

      <div id="posts" phx-update="prepend">
        <div :for={{dom_id, post} <- @streams.posts} id={dom_id} phx-click={JS.navigate(~p"/posts/#{post}")}>
          <.live_component module={ChirpWeb.PostLive.PostComponent} id={"post-#{post.id}"} post={post} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do

    if connected?(socket), do: Timeline.subscribe()
    {:ok,
     socket
     |> assign(:page_title, "Listing Posts")
     |> stream(:posts, list_posts()), temporary_assigns: [posts: []]}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  def handle_info({:post_updated, post}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  defp list_posts() do
    Timeline.list_posts()
  end
end
