require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst'
require_relative 'bst/bst_adder'

bst = BST::BST.new

bst.insert([20, 10, 5, 15, 30, 25, 35])
bst.insert(100)
bst.pretty_print

bst.delete(value: 35)
bst.delete(value: 10)
bst.pretty_print

bst.find(value: 20).dfs(order: :preorder) { |node, _depth| puts node.value }
