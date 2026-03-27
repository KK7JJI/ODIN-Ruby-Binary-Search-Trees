require_relative 'lib/bst/queue'
require_relative 'lib/bst/node'
require_relative 'lib/bst/bst'

bst = BST::BST.new

# arr = Array.new(10) { rand(100) }
# arr = [18, 23, 33, 74, 75, 81, 86, 88, 95]
arr = [33, 74, 95, 88, 75, 86, 18, 23, 81, 16, 70, 90, 89, 91]

bst.clear
bst.build_tree(arr: arr.sort)
bst.pretty_print
puts ''

puts bst.find(value: 16).node_height
puts bst.find(value: 95).node_height
puts bst.find(value: 91).node_height

bst.rebalance
bst.pretty_print
puts ''

bst.clear
bst.build_tree(arr: Array.new(20) { rand(100) }.sort.reverse)
bst.pretty_print
puts ''

bst.rebalance
bst.pretty_print
puts ''
