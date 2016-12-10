require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test

  def test_file_setup_correctly
    assert true
  end
  def test_complete_me_exists
    trie = CompleteMe.new

    assert trie
  end

  def test_head_exists
    trie = CompleteMe.new

    assert trie.head
  end

  def test_insert_single_letter
    trie = CompleteMe.new
    trie.insert("a")

    assert_equal ["a"], trie.head.links.keys
    assert_equal 1,     trie.head.links["a"].depth
  end

  def test_insert_short_word
    trie = CompleteMe.new
    trie.insert("bat")

    assert_equal ["b"], trie.head.links.keys
    assert_equal 1,     trie.head.links["b"].depth
    assert_equal false, trie.head.links["b"].end_of_word
    assert_equal false, trie.head.links["b"].links["a"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["t"].end_of_word
  end

  def test_insert_short_words_overlap
    trie = CompleteMe.new
    trie.insert("bat")
    trie.insert("bar")
    trie.insert("bats")

    assert_equal ["b"], trie.head.links.keys
    assert_equal 1,     trie.head.links["b"].depth
    assert_equal false, trie.head.links["b"].end_of_word
    assert_equal false, trie.head.links["b"].links["a"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["r"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["t"].end_of_word
    assert_equal true,  trie.head.links["b"].links["a"].links["t"].links["s"].end_of_word
  end

end