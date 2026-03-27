require_relative 'lib/bst/queue'
require_relative 'lib/bst/node'
require_relative 'lib/bst/bst'

bst = BST::BST.new

# arr = Array.new(10) { rand(100) }
# arr = [18, 23, 33, 74, 75, 81, 86, 88, 95]
arr = [33, 74, 95, 88, 75, 86, 18, 23, 81, 16, 70, 90, 89, 91]

bst.clear
bst.build_tree(arr: arr)
bst.pretty_print
puts ''

puts bst.inorder.to_a.inspect
puts bst.preorder.to_a.inspect
puts bst.postorder.to_a.inspect

bst.delete(value: 23)
bst.pretty_print
puts ''

bst.delete(value: 88)
bst.pretty_print
puts ''

bst.delete(value: 75)
bst.pretty_print
puts ''

bst.delete(value: 33)
bst.pretty_print
puts ''

puts '===================='
puts ''
bst.clear
bst.build_tree(arr: [10, 5])
bst.pretty_print
puts ''
bst.delete(value: 10)

bst.pretty_print
puts ''
