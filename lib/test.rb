require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst'

bst = BST::BST.new

bst.clear
arr = [2, 3, 20, 21, 26, 31, 34, 35, 37, 46, 47, 48, 65, 68, 88, 89, 90, 92, 93]
bst.build_tree(arr: arr)

bst.rebalance
bst.pretty_print
puts ''
