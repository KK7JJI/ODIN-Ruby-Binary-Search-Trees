require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst'

puts 'Create new binary search tree'
bst = BST::BST.new

arr = Array.new(20) { rand(100) }
puts arr.sort.inspect
bst.build_tree(arr: arr.sort)
bst.insert(value: 100)

puts bst.balanced?
puts bst.rebalance
puts bst.balanced?

puts bst.insert(value: 100)
puts bst.insert(value: 101)
