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
      new_node = Node.new(value: value)
      root&.insert_node(node: new_node)
      self.root = new_node if root.nil?
    end

    def clear
      self.root = nil
    end

    def pretty_print
      return nil if empty?

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

      node = nil

      # delete root node
      if value == root.value
        self.root = nil if root.leaf?
        root.node_delete unless empty?
        return nil
      end

      # find parent of node to be deleted
      parent = find_parent(value: value)
      return nil if parent.nil?

      node = parent.lc if !parent.lc.nil? && value == parent.lc.value
      node = parent.rc if !parent.rc.nil? && value == parent.rc.value
      return nil if node.nil?

      # delete body nodes
      return node.node_delete unless node.leaf?

      # delete leaves
      return parent.lc = nil if node.leaf? && node == parent.lc
      return parent.rc = nil if node.leaf? && node == parent.rc

      return nil if node.nil?

      value
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
      return true if empty?
      return true if root.leaf?

      root.bfs do |node|
        lhs = node.lc.nil? ? 0 : node.lc.node_height
        rhs = node.rc.nil? ? 0 : node.rc.node_height || 0
        return false unless (lhs - rhs).abs <= 1
      end

      true
    end

    def rebalance
    end

    def empty?
      return true if root.nil?

      false
    end

    private

    attr_accessor :root

    def find_parent(value: nil)
      return nil if empty?

      root.bfs do |node|
        return node if !node.lc.nil? && node.lc.value == value
        return node if !node.rc.nil? && node.rc.value == value
      end

      nil
    end
  end
end
