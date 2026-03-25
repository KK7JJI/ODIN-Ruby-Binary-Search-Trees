# frozen_string_literal: true

# project namespace
module BST
  # binary search tree
  class BST
    def initialize(root: nil)
      @root = root
    end

    def build_tree(arr: nil)
      arr.each do |value|
        insert(value: value)
      end
    end

    def insert(value: nil)
      insert_node(node: root, value: value) unless root.nil?
      self.root = Node.new(value: value) if root.nil?
    end

    def to_a(order: :inorder)
      return preorder.to_a if order == :preorder
      return postorder.to_a if order == :postorder

      inorder.to_a
    end

    def pretty_print
      puts "\n********* BST **********"
      arr = []
      pp_tree(node: root, level: 0, msg: 'R', arr: arr)

      arr1 = []
      arr.each do |level, value, msg|
        arr1 << "(#{msg}:#{level}:#{value})" if level.zero?
        arr1 << "#{' ' * level}#{'  ' * (level - 1)}└─(#{msg}:#{level}:#{value})" unless level.zero?
      end
      puts arr1.join("\n")
    end

    def include?(value)
    end

    def delete(value)
    end

    def level_order
    end

    def inorder(&block)
      root.traverse(order: :inorder, &block)
    end

    def preorder(&block)
      root.traverse(order: :preorder, &block)
    end

    def postorder(&block)
      root.traverse(order: :postorder, &block)
    end

    def height
    end

    def depth
    end

    def balanced?
    end

    def rebalance
    end

    def empty?
      return true if root.nil?

      false
    end

    private

    attr_accessor :root

    def insert_node(node: nil, value: nil)
      return Node.new(value: value) if node.nil?

      if value <= node.value
        result = insert_node(node: node.lc, value: value)
        node.lc = result if result
      else
        result = insert_node(node: node.rc, value: value)
        node.rc = result if result
      end

      nil
    end

    def pp_tree(node: nil, level: 0, msg: '', arr: [])
      return if node.nil?

      arr << [level, node.value, msg]
      level += 1
      pp_tree(node: node.lc, level: level, arr: arr, msg: 'LC')
      pp_tree(node: node.rc, level: level, arr: arr, msg: 'RC')
    end
  end

  # binary search tree node
  class Node
    attr_accessor :value, :lc, :rc

    def initialize(value: nil, lc: nil, rc: nil)
      @value = value
      @lc = lc
      @rc = rc
    end

    def traverse(order: nil, &block)
      return enum_for(:traverse, order: order) unless block

      yield value if order == :preorder
      lc&.traverse(order: order, &block)
      yield value if order == :inorder
      rc&.traverse(order: order, &block)
      yield value if order == :postorder
    end
  end
end
