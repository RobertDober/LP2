defmodule Test.Meta.MakeTupleTest do
  use ExUnit.Case
  use Test.Support.MakeAst

  describe "the worker bee: make_tag" do
    test "general use case with lenient content interpretation" do
      assert make_tag(:a_tag, "some_content", attr1: "a1", attr2: :a2) ==
        {:a_tag, [{"attr1", "a1"},  {"attr2", "a2"}], ["some_content"], %{}}
    end

    test "general use case withoit lenient content interpretation" do
      assert make_tag(:another_tag, ["alpha"]) == {:another_tag, [], ["alpha"], %{}}
    end
  end

  describe "specialised tags" do
    test "p: simple case" do
      assert p("hello") == {:p, [], ["hello"], %{}}
    end
    test "p: attributes and content" do
      assert p("hello", recipient: :world) == {:p, [{"recipient", "world"}], ["hello"], %{}}
    end
    test "li: attributes and content" do
      assert li("first", odd: true, even: false) == {:li, [{"odd", "true"}, {"even", "false"}], ["first"], %{}}
    end
    test "ul: content" do
      assert ul("content") == {:ul, [], ["content"], %{}}
    end
  end

  describe "imbrications" do
    test "a typical list" do
      expected = {
        :ol,
        [{"bullet", "2."}, {"start", "2"}],
        [{:li, [], ["one"], %{}}, {:li, [], ["two"], %{}}],
        %{}}
       assert ol([li("one"), li("two")], bullet: "2.", start: "2") == expected
    end

    test "with only one item" do
      expected = {
        :ul,
        [],
        [{:li, [], ["a ul list item"], %{}}],
        %{}}
      assert ul(li("a ul list item")) == expected
    end
  end

  describe "ok" do
    test "with anything" do
      assert ok("anything") == {:ok, ["anything"], []}
    end
    test "with any list" do
      assert ok(["any list"]) == {:ok, ["any list"], []}
    end
  end

end
