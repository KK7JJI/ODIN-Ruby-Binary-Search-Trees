require_relative 'bst/bst_enum'
require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst_adder'
require_relative 'bst/bst_remover'
require_relative 'bst/bst'

bst = BST::BST.new

bst.insert([20, 10, 5, 15, 30, 25, 35])
bst.insert(100)
bst.pretty_print

bst.delete(35)
bst.delete(10)
bst.pretty_print

bst.insert(Array.new(10) { rand(100) })
bst.pretty_print

bst.rebalance
bst.pretty_print

puts bst.level_order.inspect
