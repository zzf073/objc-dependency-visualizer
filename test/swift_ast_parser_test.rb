require 'minitest/autorun'
require 'parser/swift_ast_parser'

class SwiftAstParserTest < Minitest::Test

  def test_simple_objects
    node = SwiftAST::Node.new("name")
    assert node != nil, "it should be able to create simple node"
    assert_equal node.name, "name"

    assert SwiftAST::Parser.new != nil, "Parser should be created!"

  end  

  def test_simple_node_parse
    parser = SwiftAST::Parser.new
    ast = parser.parse("(hello )")
    assert ast != nil, "Parser should return ast1"
    assert_kind_of SwiftAST::Node, ast, "Parser should have correct root node"
  end  

  def test_simple_node_parse_name
    ast = SwiftAST::Parser.new.parse("(hello )")
    assert_equal ast.name, "hello"
  end  

  def test_simple_node_parameters
    ast = SwiftAST::Parser.new.parse("(hello one)")
    assert_equal ast.name, "hello"
    assert_equal ast.parameters, ["one"]
  end  

  def test_multiple_node_parameters
    ast = SwiftAST::Parser.new.parse("(hello one two)")
    assert_equal ast.name, "hello"
    assert_equal ast.parameters, ["one", "two"]
  end  

  def test_multiple_string_parameters
    ast = SwiftAST::Parser.new.parse("(hello 'one' \"two\")")
    assert_equal ast.name, "hello"
    assert_equal ast.parameters, ["one", "two"]

  end  

  def test_custom_node_with_assignment
    ast = SwiftAST::Parser.new.parse("(assignment weather=cool")
    assert_equal ast.name, "assignment"
    assert_equal ast.parameters, ["weather=cool"]
  end  

  def test_custom_node_paramters
    ast = SwiftAST::Parser.new.parse("(hello \"Protocol1\" <Self : Protocol1> interface type='Protocol1.Protocol' access=internal @_fixed_layout requirement signature=<Self>)")
    assert_equal ast.name, "hello"
    assert_equal ast.parameters, ["Protocol1", "<Self : Protocol1>", "interface", "type='Protocol1.Protocol'", "access=internal", "@_fixed_layout", "requirement", "signature=<Self>" ] 
  end  

  def test_node_filetype_parameter
    ast = SwiftAST::Parser.new.parse("(component id='Protocol1' bind=SourcekittenWithComplexDependencies.(file).Protocol1@/Users/paultaykalo/Projects/objc-dependency-visualizer/test/fixtures/sourcekitten-with-properties/SourcekittenExample/FirstFile.swift:12:10)")
    assert_equal ast.name, "component"
    assert_equal ast.parameters, ["id='Protocol1'", "bind=SourcekittenWithComplexDependencies.(file).Protocol1@/Users/paultaykalo/Projects/objc-dependency-visualizer/test/fixtures/sourcekitten-with-properties/SourcekittenExample/FirstFile.swift:12:10" ] 
  end  

  def test_node_range_parameter
    ast = SwiftAST::Parser.new.parse("(constructor_ref_call_expr implicit type='(_MaxBuiltinIntegerType) -> Int' location=/Users/paultaykalo/Projects/objc-dependency-visualizer/test/fixtures/sourcekitten-with-properties/SourcekittenExample/FirstFile.swift:23:22 range=[/Users/paultaykalo/Projects/objc-dependency-visualizer/test/fixtures/sourcekitten-with-properties/SourcekittenExample/FirstFile.swift:23:22 - line:23:22] nothrow)")
    assert_equal ast.name, "constructor_ref_call_expr"
    assert_equal ast.parameters, ["implicit", "type='(_MaxBuiltinIntegerType) -> Int'", "location=/Users/paultaykalo/Projects/objc-dependency-visualizer/test/fixtures/sourcekitten-with-properties/SourcekittenExample/FirstFile.swift:23:22", "range=[/Users/paultaykalo/Projects/objc-dependency-visualizer/test/fixtures/sourcekitten-with-properties/SourcekittenExample/FirstFile.swift:23:22 - line:23:22]", "nothrow"]
  end  

  def test_children_parsing
    source = """
    (brace_stmt\
        (return_stmt implicit))
    """
    ast = SwiftAST::Parser.new.parse(source)
    assert_equal ast.name, "brace_stmt"
    assert_equal ast.parameters, []
    assert !ast.children.empty?, "Parser should be able to parse subtrees"

    return_statement = ast.children.first
    assert_equal return_statement.name, "return_stmt"
    assert_equal return_statement.parameters, ["implicit"]

  end
    

end
