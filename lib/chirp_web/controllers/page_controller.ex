defmodule ChirpWeb.PageController do
  use ChirpWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
