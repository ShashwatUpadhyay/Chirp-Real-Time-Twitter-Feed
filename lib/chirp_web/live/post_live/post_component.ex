defmodule ChirpWeb.PostLive.PostComponent do
  use ChirpWeb, :live_component

  def render(assigns) do
    ~H"""
    <article
      id={@id}
      class="flex gap-3 border-b border-base-300 px-4 py-3 transition-colors hover:bg-base-200/50"
    >
      <div class="flex size-10 shrink-0 items-center justify-center rounded-full bg-sky-500 text-lg font-bold text-white">
        {String.first(@post.username) |> String.upcase()}
      </div>

      <div class="min-w-0 flex-1">
        <div class="flex items-center gap-1 text-sm">
          <span class="truncate font-bold">{@post.username}</span>
          <span class="truncate text-base-content/60">
            @{@post.username |> String.downcase() |> String.replace(" ", "")}
          </span>
          <span class="text-base-content/60">·</span>
          <time class="text-base-content/60" datetime={@post.inserted_at}>
            {Calendar.strftime(@post.inserted_at, "%b %d")}
          </time>
        </div>

        <p class="mt-1 whitespace-pre-wrap break-words text-[15px] leading-snug">{@post.body}</p>

        <div class="mt-3 flex max-w-md justify-between text-sm text-base-content/60">
          <button
            id={"#{@id}-reply"}
            type="button"
            class="group flex items-center gap-1 transition-colors hover:text-sky-500"
          >
            <span class="rounded-full p-1.5 transition-colors group-hover:bg-sky-500/10">
              <.icon name="hero-chat-bubble-oval-left" class="size-5" />
            </span>
          </button>

          <button
            id={"#{@id}-repost"}
            type="button"
            phx-click="repost"
            phx-target={@myself}
            class="group flex items-center gap-1 transition-colors hover:text-green-500"
          >
            <span class="rounded-full p-1.5 transition-colors group-hover:bg-green-500/10">
              <.icon name="hero-arrow-path-rounded-square" class="size-5" />
            </span>
            <span>{@post.reposts_count}</span>
          </button>

          <button
            id={"#{@id}-like"}
            type="button"
            phx-click="like"
            phx-target={@myself}
            class="group flex items-center gap-1 transition-colors hover:text-pink-500"
          >
            <span class="rounded-full p-1.5 transition-colors group-hover:bg-pink-500/10">
              <.icon name="hero-heart" class="size-5" />
            </span>
            <span>{@post.likes_count}</span>
          </button>

          <button
            id={"#{@id}-share"}
            type="button"
            class="group flex items-center gap-1 transition-colors hover:text-sky-500"
          >
            <span class="rounded-full p-1.5 transition-colors group-hover:bg-sky-500/10">
              <.icon name="hero-arrow-up-tray" class="size-5" />
            </span>
          </button>
        </div>
      </div>
    </article>
    """
  end

  def handle_event("like", _params, socket) do
    Chirp.Timeline.increment_likes(socket.assigns.post)
    {:noreply, socket}
  end

  def handle_event("repost", _params, socket) do
    Chirp.Timeline.increment_reposts(socket.assigns.post)
    {:noreply, socket}
  end
end
