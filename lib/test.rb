require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst'

bst = BST::BST.new

bst.build_tree(arr: [20, 10, 5, 15, 30, 25, 35])

bst.find(value: 20).dfs2(order: :preorder) { |node, _depth| puts node.value }
