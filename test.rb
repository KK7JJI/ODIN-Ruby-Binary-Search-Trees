require_relative 'lib/bst/bst'

bst = BST::BST.new

bst.build_tree(arr: [10, 5, 15])
# puts bst.to_a
puts bst.inorder
puts bst.height(value: 10)
puts bst.height(value: 15)
puts ''

bst = BST::BST.new
bst.build_tree(arr: [10, 5, 15, 14, 20, 17, 22, 7, 0, 1])

bst.pretty_print

puts bst.height(value: 10)
puts bst.height(value: 15)
puts bst.height(value: 14)
puts bst.height(value: 17)
puts bst.height(value: 22)
puts ''

puts bst.depth(value: 10)
puts bst.depth(value: 15)
puts bst.depth(value: 14)
puts bst.depth(value: 17)
puts bst.depth(value: 22)

bst = BST::BST.new
arr = Array.new(20) { rand(100) }
puts arr.inspect
bst.build_tree(arr: arr)
bst.insert(value: 50)

bst.pretty_print
puts bst.inorder.inspect
puts bst.postorder.inspect
puts bst.preorder.inspect
puts bst.level_order.inspect

puts bst.include?(50)
puts bst.include?(101)
