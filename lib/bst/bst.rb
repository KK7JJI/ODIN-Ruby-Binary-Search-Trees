# frozen_string_literal: true

# project namespace
module BST
  # binary search tree
  class BST
    include BSTEnum

    attr_accessor :size, :root

    def initialize(root: nil)
      @root = root
      @size = 0
      @adder = BSTAdder.new
      @remover = BSTRemover.new
    end

    def insert(arg)
      self.size += @adder.insert(self, arg)
    end

    def delete(arg)
      self.size -= @remover.delete(self, arg)
    end

    def clear
      self.root = nil
      self.size = 0
    end

    def pretty_print
      return nil if empty?

      root.pp
    end

    def include?(value)
      return false if empty?

      bfs(start_node: root) { |node| return true if node.value == value }
      false
    end

    def find(value: nil)
      return nil if empty?

      bfs(start_node: root) { |node| return node if node.value == value }
      nil
    end

    def level_order
      return nil if empty?

      bfs(start_node: root).to_a.map(&:value)
    end

    def inorder
      return nil if empty?

      dfs(start_node: root, order: :inorder).to_a.map { |node, _level| node.value }
    end

    def preorder
      return nil if empty?

      dfs(start_node: root, order: :preorder).to_a.map { |node, _level| node.value }
    end

    def postorder
      return nil if empty?

      dfs(start_node: root, order: :postorder).to_a.map { |node, _level| node.value }
    end

    def height(value: nil)
      return nil if empty?
      return nil if value.nil?

      node = find(value: value)
      return nil if node.nil?

      node.node_height
    end

    def depth(value: nil)
      return nil if empty?
      return nil if value.nil?

      node = find(value: value)
      return nil if node.nil?

      node.node_depth(ref_node: root)
    end

    def balanced?
      return true if empty?
      return true if root.leaf?

      bfs(start_node: root) do |node|
        lhs = node.lcld.nil? ? -1 : node.lcld.node_height
        rhs = node.rcld.nil? ? -1 : node.rcld.node_height || 0
        return false unless (lhs - rhs).abs <= 1
      end

      true
    end

    def rebalance
      arr = inorder.to_a
      clear
      rebuild_tree(arr: arr)
    end

    def rebuild_tree(arr: nil)
      return nil if arr.length.zero?

      insert(arr[0]) if arr.length == 1

      mid = arr.length / 2
      insert(arr[mid])

      arr_left = arr.slice(0...mid)
      rebuild_tree(arr: arr_left)
      arr_right = arr.slice((mid + 1)...arr.length)
      rebuild_tree(arr: arr_right)
    end

    def empty?
      return true if root.nil?

      false
    end
  end
end
