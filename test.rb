require_relative 'lib/bst/queue'
require_relative 'lib/bst/node'
require_relative 'lib/bst/bst'

bst = BST::BST.new

arr = Array.new(10) { rand(100) }

bst.clear
bst.build_tree(arr: arr.sort)
bst.pretty_print
puts ''

puts bst.inorder.to_a.inspect
puts bst.preorder.to_a.inspect
puts bst.postorder.to_a.inspect
puts bst.level_order.to_a.inspect

puts ''
bst = BST::BST.new
bst.build_tree(arr: [10, 5, 15, 7, 6, 8, 12, 18])
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''

bst.delete(value: 8)
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''

bst.delete(value: 15)
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''

bst.delete(value: 5)
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''

bst.delete(value: 10)
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''

puts ''

return

arr1 = bst.inorder.to_a
arr2 = bst.preorder.to_a
arr3 = bst.postorder.to_a
arr4 = bst.level_order.to_a

puts bst.clear
bst.build_tree(arr: arr1)
bst.pretty_print
puts ''
puts bst.clear
bst.build_tree(arr: arr2)
bst.pretty_print
puts ''
puts bst.clear
bst.build_tree(arr: arr3)
bst.pretty_print
puts ''
puts bst.clear
bst.build_tree(arr: arr4)
bst.pretty_print

return

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

bst = BST::BST.new
bst.build_tree(arr: [10, 15])
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''
bst.delete(value: 10)
bst.pretty_print
puts ''
puts bst.inorder.inspect
puts ''

bst = BST::BST.new
bst.build_tree(arr: [15, 11, 98, 5, 4])
puts ''
puts bst.inorder.to_a.inspect
puts ''
bst.pretty_print
puts ''
bst.delete(value: 15)
puts ''
puts bst.inorder.to_a.inspect
bst.pretty_print
puts bst.include?(value: 98)
