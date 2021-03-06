defmodule Talos.Types.ListTypeTest do
  use ExUnit.Case
  alias Talos.Types.ListType
  alias Talos.Types.NumberType
  import Talos

  test "#valid?" do
    assert true == ListType.valid?(%ListType{allow_nil: true}, nil)
    assert true == ListType.valid?(%ListType{}, [])
    assert true == ListType.valid?(%ListType{allow_blank: true}, [])
    assert false == ListType.valid?(%ListType{allow_blank: false}, [])
    assert true == ListType.valid?(%ListType{}, [1])
    assert true == ListType.valid?(%ListType{}, [1, 2, "string"])
    assert true == ListType.valid?(%ListType{allow_nil: true}, [1, 2, "string"])
    assert false == ListType.valid?(%ListType{allow_nil: true, min_length: 5}, [1, 2, "string"])
    assert false == ListType.valid?(%ListType{allow_nil: true, max_length: 2}, [1, 2, "string"])

    assert true ==
             ListType.valid?(%ListType{allow_nil: true, min_length: 3, max_length: 3}, [
               1,
               2,
               "string"
             ])

    assert false == ListType.valid?(%ListType{}, nil)
    assert false == ListType.valid?(%ListType{}, 1)
    assert false == ListType.valid?(%ListType{}, "string")
  end

  test "#valid? with allow_blank" do
    assert true == ListType.valid?(%ListType{allow_blank: true}, [])
  end

  test "#valid? with enum subtype" do
    assert true == ListType.valid?(list(type: enum(members: ["a", "b", "c"])), ["a", "b", "c"])
    assert true == ListType.valid?(list(type: enum(members: ["a", "b", "c"])), ["a", "b"])
    assert true == ListType.valid?(list(type: enum(members: ["a", "b", "c"])), ["a"])
    assert false == ListType.valid?(list(type: enum(members: ["a", "b", "c"])), ["a", "f"])
  end

  test "#valid? - with additional params" do
    number_type = %NumberType{gteq: 0}

    assert true == ListType.valid?(%ListType{type: number_type}, [])
    assert false == ListType.valid?(%ListType{type: number_type, allow_blank: false}, [])
    assert true == ListType.valid?(%ListType{type: number_type, allow_nil: true}, [])
    assert false == ListType.valid?(%ListType{type: number_type, allow_nil: true, allow_blank: false}, [])
    assert true == ListType.valid?(%ListType{type: number_type, allow_nil: true, allow_blank: false}, nil)
    assert true == ListType.valid?(%ListType{type: number_type, allow_blank: true}, [])
    assert true == ListType.valid?(%ListType{type: number_type, allow_blank: true, allow_nil: true}, [])
    assert true == ListType.valid?(%ListType{type: number_type}, [1])
    assert true == ListType.valid?(%ListType{type: number_type}, [0, 1, 2])

    assert false == ListType.valid?(%ListType{type: number_type}, nil)
    assert false == ListType.valid?(%ListType{type: number_type}, 1)
    assert false == ListType.valid?(%ListType{type: number_type}, [-1000, 1, 2])
    assert false == ListType.valid?(%ListType{type: number_type}, ["string"])
  end

  test "#errors - returns errors or empty list" do
    number_type = %NumberType{gteq: 0}

    assert ["list should not be empty"] == ListType.errors(%ListType{type: number_type, allow_blank: false}, [])
    assert [] == ListType.errors(%ListType{type: number_type}, [])

    assert ["1", "should be ListType"] = ListType.errors(%ListType{type: number_type}, 1)

    assert [
             "List length should be greater than 5",
             ["-1", "should be greater than or equal to 0"],
             ["-2", "should be greater than or equal to 0"]
           ] = ListType.errors(%ListType{type: number_type, min_length: 5}, [-1, -2])

    assert [
             "List length should be lower than 1",
             ["-1", "should be greater than or equal to 0"],
             ["-2", "should be greater than or equal to 0"]
           ] = ListType.errors(%ListType{type: %NumberType{gteq: 0}, max_length: 1}, [-1, -2, 3])
  end
end
