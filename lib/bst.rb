require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst'

puts 'Create new binary search tree'
bst = BST::BST.new

arr = Array.new(20) { rand(100) }
puts arr.sort.inspect
bst.build_tree(arr: arr.sort)

balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts ''
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts '========='
puts ''
bst.pretty_print
puts ''
puts '========='
puts ''

puts 'Rebalancing'
bst.rebalance
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts ''
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts '========='
puts ''
bst.pretty_print

puts ''
puts ''

puts 'Inserting 10 new elements . . . '
arr = (100...110).to_a

arr.each do |i|
  bst.insert(value: i)
end
balance_state = bst.balanced? ? 'balanced' : 'not balanced'

puts ''
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts '========='
puts ''
bst.pretty_print

puts ''
puts 'Rebalancing'
bst.rebalance
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts ''
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts '========='
puts ''
bst.pretty_print

puts ''
puts 'Delete 10 random nodes from tree . . . '

10.times do
  value = bst.inorder.to_a.sample
  bst.delete(value: value)
end
balance_state = bst.balanced? ? 'balanced' : 'not balanced'

puts ''
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts '========='
puts ''
bst.pretty_print

puts ''
puts 'Rebalancing'
bst.rebalance
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts ''
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts '========='
puts ''
bst.pretty_print
