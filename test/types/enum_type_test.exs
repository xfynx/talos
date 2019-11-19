defmodule Talos.Types.EnumTypeTest do
  use ExUnit.Case
  alias Talos.Types.EnumType

  test "#valid?" do
    assert true == EnumType.valid?(%EnumType{members: [1, 2, 3, 4, 5]}, 5)
    assert false == EnumType.valid?(%EnumType{members: [1, 2, 3, 4, 5]}, 0)
    assert true == EnumType.valid?(%EnumType{members: ["a", "b", "c", "d", "e"]}, "e")
    assert false == EnumType.valid?(%EnumType{members: ["a", "b", "c", "d", "e"]}, "z")
  end

  test "errors - returns list with error element" do
    assert [] == EnumType.errors(%EnumType{members: [1, 2, 3, 4, 5]}, 5)
    assert [value: 0] == EnumType.errors(%EnumType{members: [1, 2, 3, 4, 5]}, 0)
    assert [] == EnumType.errors(%EnumType{members: ["a", "b", "c", "d", "e"]}, "e")
    assert [value: "z"] == EnumType.errors(%EnumType{members: ["a", "b", "c", "d", "e"]}, "z")
  end

  test "#valid? - call with invalid members value" do
    assert_raise FunctionClauseError, fn ->
      EnumType.valid?(%EnumType{members: nil}, "SomeVal")
    end

    assert_raise FunctionClauseError, fn -> EnumType.valid?(%EnumType{members: 1}, "SomeVal") end

    assert_raise FunctionClauseError, fn ->
      EnumType.valid?(%EnumType{members: %{}}, "SomeVal")
    end
  end
end
