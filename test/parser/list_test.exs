defmodule Test.Parser.ListTest do
  use ExUnit.Case
  alias LP2.Parser
  import Parser
  import Test.Support.MakeAst

  describe "simple as Bonjour ;)" do
    test "single ul list item" do
      input    = [
        "* a ul list item"
      ]
      expected = ok(ul(li("a ul list item")))
     
      assert parse(input) == expected
    end
    
  end
  
end
