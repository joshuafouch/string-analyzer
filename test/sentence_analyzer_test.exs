defmodule SentenceAnalyzerTest do
  use ExUnit.Case
  doctest SentenceAnalyzer

  test "greets the world" do
    assert SentenceAnalyzer.hello() == :world
  end
end
