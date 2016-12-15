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

  def test_create_head_node
    head = Node.new

    assert_equal 0,         head.depth
    assert_equal empty_hash,  head.links
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

    assert_equal [["bar",empty_hash],["bat",empty_hash]], words
  end

  def test_weights_short
    head = Node.new
    head.insert("bat")
    head.insert("bar")

    bat = head.get_node("bat")
    bar = head.get_node("bar")

    assert_equal empty_hash, bat.weights
    assert_equal empty_hash, bar.weights

    bat.add_weight("ba")
    bat = head.get_node("bat")
    bar = head.get_node("bar")

    hash_test = {}
    hash_test["ba"] = 1

    assert_equal hash_test,   bat.weights
    assert_equal empty_hash,  bar.weights
  end

  def test_get_parent_and_child_node
    head = Node.new
    head.insert("bat")
    head.insert("bar")

    parent_node, child_node = head.get_parent_and_child("bar")

    assert_equal head.links["b"].links["a"],            parent_node
    assert_equal head.links["b"].links["a"].links["r"], child_node
  end

  def test_remove_link_works
    head = Node.new
    head.insert("bar")

    head.links["b"].links["a"].links["r"].remove_word

    assert_equal false, head.links["b"].links["a"].links["r"].end_of_word
  end

  def test_remove_link_works
    head = Node.new
    head.insert("bar")

    head.links["b"].links["a"].remove_link("r")

    assert_equal empty_hash, head.links["b"].links["a"].links
  end

  def empty_hash
    Hash.new
  end

end