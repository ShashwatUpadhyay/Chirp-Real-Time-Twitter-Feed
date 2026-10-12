defmodule Chirp.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :username, :string, default: "Anonymous"
    field :body, :string
    field :likes_count, :integer, default: 0
    field :reposts_count, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> validate_length(:body, min: 4, max: 280)
  end
end
