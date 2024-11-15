defmodule PollsTest do
  use ExUnit.Case
  doctest Polls

  test "greets the world" do
    assert Polls.hello() == :world
  end
end
