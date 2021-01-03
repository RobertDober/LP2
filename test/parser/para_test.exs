defmodule Test.Lp2.Parser.ParaTest do
  use ExUnit.Case
  alias LP2.Parser
  import Parser
  import Test.Support.MakeAst

  describe "empty" do
    test "empty → empty" do
      assert parse("") == {:ok, [], []}
    end
  end

  describe "parahgraphs" do
    test "one line" do
      assert parse("hello") == ok(p("hello"))
    end
    test "more lines" do
      assert parse(["hello", "world"]) == ok(p(["hello", "world"]))
    end
    test "two paragraphs" do
      assert parse(["hello", "", "world"]) == 
        ok([p("hello"), p("world")])
    end
  end
end
