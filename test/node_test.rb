require 'simplecov'
SimpleCov.start

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

  def test_node_defaults
    head = Node.new

    assert_equal empty_hash,  head.links
    assert_equal false,       head.end_of_word
    assert_equal 0,           head.depth
    assert_equal empty_hash,  head.weights
  end

  def test_insert_single_letter
    head = Node.new

    head.insert("a")

    assert_equal ["a"], head.links.keys
    assert_equal 1,     head.links["a"].depth
    assert_equal true,  head.links["a"].end_of_word
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

  def test_get_node_empty_string
    head = Node.new
    head.insert("bat")

    node = head.get_node("")

    assert_equal head, node
  end

  def test_get_node_no_links
    head = Node.new
    head.insert("a")

    node = head.get_node("at")

    assert_nil node
  end

  def test_get_node_short_string
    head = Node.new
    head.insert("bat")

    node = head.get_node("ba")

    assert_equal 2,     node.depth
    assert_equal ["t"], node.links.keys
  end

  def test_get_list_of_words_short_list
    head = Node.new
    head.insert("bat")
    head.insert("bar")
    suggestion = "ba"
    search_node = head.get_node(suggestion)

    words = search_node.get_list_of_words(suggestion).sort

    assert_equal [["bar",empty_hash],["bat",empty_hash]], words
  end

  def test_add_weight_no_existing_weights
    head = Node.new
    head.insert("bat")
    head.insert("bar")
    bat = head.get_node("bat")
    bar = head.get_node("bar")

    assert_equal 0, bat.weights.length
    assert_equal 0, bar.weights.length

    bat.add_weight("ba")

    assert_equal 1, bat.weights["ba"]
    assert_equal 0, bar.weights.length
  end

  def test_add_weight_existing_weight
    head = Node.new
    head.insert("bat")
    bat = head.get_node("bat")

    assert_equal 0, bat.weights.length

    bat.add_weight("ba")
    bat.add_weight("ba")

    assert_equal 2, bat.weights["ba"]
  end

  def test_get_parent_and_child_node
    head = Node.new
    head.insert("bat")
    head.insert("bar")

    parent_node, child_node = head.get_parent_and_child("bar")

    assert_equal head.links["b"].links["a"],            parent_node
    assert_equal head.links["b"].links["a"].links["r"], child_node
  end

  def test_remove_word
    head = Node.new
    head.insert("bar")
    node = head.links["b"].links["a"].links["r"]

    node.remove_word

    assert_equal false, node.end_of_word
  end

  def test_remove_link
    head = Node.new
    head.insert("bar")
    node = head.links["b"].links["a"]

    node.remove_link("r")

    assert_equal 0, node.links.length
  end

  def empty_hash
    Hash.new
  end

end
