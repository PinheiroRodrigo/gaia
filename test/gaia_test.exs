defmodule GaiaTest do
  use ExUnit.Case
  doctest Gaia

  test "greets the world" do
    assert Gaia.hello() == :world
  end
end
