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

    def pretty_print
      root.pp
    end

    def include?(value)
      return false if empty?

      root.bfs { |node| return true if node.value == value }
      false
    end

    def find(value: nil)
      return nil if empty?

      root.bfs { |node| return node if node.value == value }
      nil
    end

    def delete(value: nil)
      return nil if empty?
      return nil if value.nil?

      delete_node(find(value: value))
    end

    def level_order
      return nil if empty?

      root.bfs.to_a.map(&:value)
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
