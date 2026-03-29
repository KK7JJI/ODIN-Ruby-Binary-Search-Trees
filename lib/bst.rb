require_relative 'bst/queue'
require_relative 'bst/node'
require_relative 'bst/bst'

def pp(bst)
  puts '========='
  puts ''
  bst.pretty_print
  puts ''
  puts '========='
  puts ''
end

puts 'Create new binary search tree'
bst = BST::BST.new
n = 5000

# arr = (0...n).to_a
arr = []
while arr.length < n
  arr << rand(n * 10)
  arr = arr.uniq
end

bst.build_tree(arr: arr.sort)

balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts bst.inorder.to_a.inspect if n < 200 && n >= 100
pp(bst) if n < 100
puts ''
puts 'Rebalancing'
bst.rebalance
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
pp(bst) if n < 100

puts ''
puts "Inserting #{n} new elements . . . "
while arr.length < n + n
  arr << rand(n * 10)
  arr = arr.uniq
end
arr.each do |i|
  bst.insert(value: i)
end
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts bst.inorder.to_a.inspect if n < 200 && n >= 100
pp(bst) if n < 100

puts ''
puts 'Rebalancing'
bst.rebalance
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
pp(bst) if n < 100

puts ''
puts "Delete #{n} random nodes from tree . . . "

n.times do
  value = bst.inorder.to_a.sample
  bst.delete(value: value)
end
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
puts bst.inorder.to_a.inspect if n < 200 && n >= 100
pp(bst) if n < 100

puts ''
puts 'Rebalancing'
bst.rebalance
balance_state = bst.balanced? ? 'balanced' : 'not balanced'
puts "Binary Search tree w/ #{bst.size} nodes is #{balance_state}."
pp(bst) if n < 100

if n < 200
  puts ''
  puts '=== preorder ======'
  puts bst.preorder.to_a.inspect
  puts ''
  puts '=== postorder ======'
  puts bst.postorder.to_a.inspect
  puts ''
  puts '=== inorder ======'
  puts bst.inorder.to_a.inspect
  puts ''
  puts '=== level order ======'
  puts bst.level_order.to_a.inspect
  puts ''
end
