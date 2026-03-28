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

    def dereference_root_node
      consolidate_children(node: root)

      return self.root = nil if root.leaf?

      self.root = root.rc.nil? ? root.lc : root.rc
      nil
    end

    def consolidate_children(node: nil)
      return nil unless node.child_count == 2

      node.rc.insert_node(node: node.lc)
      node.lc = nil
    end

    def delete(value: nil)
      return nil if empty?
      return nil if value.nil?

      parent, node = find_parent_and_child(value: value)

      return nil if node.nil?
      return dereference_root_node if parent.nil?

      del_node = select_child_node(node: parent, value: value)
      return nil if prune_leaf(parent: parent, node: del_node)

      consolidate_children(node: del_node)
      dereference_node(parent: parent, node: del_node)

      nil
    end

    def find_parent_and_child(value: nil)
      parent = find_parent(value: value)
      node = find(value: value)
      [parent, node]
    end

    def prune_leaf(parent: nil, node: nil)
      return nil unless node.leaf?

      parent.lc = nil if parent.lc == node
      parent.rc = nil if parent.rc == node

      node
    end

    def select_child_node(node: nil, value: nil)
      return node.lc if node.rc.nil?
      return node.rc if node.lc.nil?

      node.lc.value == value ? node.lc : node.rc
    end

    def dereference_node(parent: nil, node: nil)
      if parent.lc == node
        parent.lc = node.lc if node.rc.nil?
        parent.lc = node.rc if node.lc.nil?
      else
        parent.rc = node.lc if node.rc.nil?
        parent.rc = node.rc if node.lc.nil?
      end
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
        lhs = node.lc.nil? ? -1 : node.lc.node_height
        rhs = node.rc.nil? ? -1 : node.rc.node_height || 0
        return false unless (lhs - rhs).abs <= 1
      end

      true
    end

    def rebalance
      return nil if empty?

      root.dfs(order: :preorder) do |node|
        lhs = node.lc.nil? ? -1 : node.lc.node_height
        rhs = node.rc.nil? ? -1 : node.rc.node_height || 0

        delta = rhs > lhs ? rhs - lhs : 0
        rotate = delta.abs / 2

        rotate.times do
          node.rotate_left
        end

        delta = lhs > rhs ? lhs - rhs : 0
        rotate = delta.abs / 2

        rotate.times do
          node.rotate_right
        end
      end

      nil
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
