require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test

  def test_file_setup_correctly
    assert true
  end

  def test_node_exists
    node = Node.new

    assert node
  end

  def test_create_head_node
    head = Node.new

    assert_equal 0,         head.depth
    assert_equal Hash.new,  head.links
  end

  def test_insert_single_letter
    head = Node.new

    head.insert("a")

    assert_equal ["a"], head.links.keys
    assert_equal 1,     head.links["a"].depth
  end

  def test_insert_short_word
    head = Node.new

    head.insert("bat")

    assert_equal ["b"], head.links.keys
    assert_equal 1,     head.links["b"].depth
    assert_equal false, head.links["b"].end_of_word
    assert_equal false, head.links["b"].links["a"].end_of_word
    assert_equal true,  head.links["b"].links["a"].links["t"].end_of_word
  end

  def test_insert_short_words_overlap
    head = Node.new

    head.insert("bat")
    head.insert("bar")

    assert_equal ["b"], head.links.keys
    assert_equal 1,     head.links["b"].depth
    assert_equal false, head.links["b"].end_of_word
    assert_equal false, head.links["b"].links["a"].end_of_word
    assert_equal true,  head.links["b"].links["a"].links["r"].end_of_word
    assert_equal true,  head.links["b"].links["a"].links["t"].end_of_word
  end

  def test_get_node_returns_node
    head = Node.new
    head.insert("bat")

    head.get_node("ba")

    assert_equal 2,     head.links["b"].links["a"].depth
    assert_equal ["t"], head.links["b"].links["a"].links.keys
  end

  def test_get_list_of_words_short_list
    head = Node.new
    head.insert("bat")
    head.insert("bar")
    suggestion = "ba"
    search_node = head.get_node(suggestion)

    words = search_node.get_list_of_words(suggestion).sort

    assert_equal ["bar","bat"], words
  end

  def test_weights_shor
    head = Node.new
    head.insert("bat")
    head.insert("bar")

    bat = head.get_node("bat")
    bar = head.get_node("bar")

    assert_equal Hash.new, bat.weights
    assert_equal Hash.new, bar.weights

    bat.add_weight("ba")
    bat = head.get_node("bat")
    bar = head.get_node("bar")

    hash_test = {}
    hash_test["ba"] = 1

    assert_equal hash_test, bat.weights
    assert_equal Hash.new,  bar.weights
  end

end