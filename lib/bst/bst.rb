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

      root
    end

    def insert(value: nil)
      insert_node(node: root, value: value) unless root.nil?
      self.root = Node.new(value: value) if root.nil?
    end

    def pp
      root.pp
    end

    def include?(value)
      return false if empty?

      root.bfs { |node| return true if node.value == value }
      false
    end

    def delete(value)
    end

    def level_order
      return nil if empty?

      root.bfs.to_a.map { |node| node.value }
    end

    def inorder
      return nil if empty?

      root.dfs(order: :inorder).to_a.map { |node, _level| node.value }
    end

    def preorder
      return nil if empty?

      root.dfs(order: :preorder).to_a.map { |node, _level| node.value }
    end

    def postorder
      return nil if empty?

      root.dfs(order: :postorder).to_a.map { |node, _level| node.value }
    end

    def height(value: nil)
      return nil if empty?
      return nil if value.nil?

      cur_node = nil
      root.dfs { |node| cur_node = node if node.value == value }
      return nil if cur_node.nil?

      height = 0
      cur_node.dfs.to_a.map { |_node, level| height = level if level > height }
      height
    end

    def depth(value: nil)
      return nil if empty?
      return nil if value.nil?

      depth = nil # remains nil if value not found.
      root.dfs { |node, level| depth = level if node.value == value }
      return nil if depth.nil?

      depth
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

      if value < node.value
        result = insert_node(node: node.lc, value: value)
        node.lc = result if result
      elsif value > node.value
        result = insert_node(node: node.rc, value: value)
        node.rc = result if result
      end

      # duplicate values are not permitted in this BST.
      nil
    end
  end
end
