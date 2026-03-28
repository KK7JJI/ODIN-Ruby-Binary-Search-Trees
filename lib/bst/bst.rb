# frozen_string_literal: true

# project namespace
module BST
  # binary search tree
  class BST
    attr_accessor :size

    def initialize(root: nil)
      @root = root
      @size = 0
    end

    def build_tree(arr: nil)
      arr.each do |value|
        insert(value: value)
      end

      root
    end

    def insert(value: nil)
      new_node = Node.new(value: value)
      if root.nil?
        self.root = new_node
        self.size += 1
      else
        self.size += root&.insert_node(node: new_node)
      end
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
      self.size += delete_node(value: value)
    end

    def delete_node(value: nil)
      # called by delete
      return 0 if empty?
      return 0 if value.nil?

      parent, node = find_parent_and_child(value: value)

      # node not found in tree
      return 0 if node.nil?

      # delete root node
      return dereference_root_node if parent.nil?

      del_node = select_child_node(node: parent, value: value)

      # delete leaf nodes
      return prune_leaf(parent: parent, node: del_node) if del_node.leaf?

      # delete all other nodes in tree
      consolidate_children(node: del_node)
      dereference_node(parent: parent, node: del_node)
    end

    def find_parent_and_child(value: nil)
      # called by delete
      parent = find_parent(value: value)
      node = find(value: value)
      [parent, node]
    end

    def dereference_root_node
      # called by delete
      consolidate_children(node: root)

      self.root = nil if root.leaf?
      self.root = root.rcld.nil? ? root.lcld : root.rcld unless root.nil?
      -1
    end

    def consolidate_children(node: nil)
      # called by delete
      return nil unless node.child_count == 2

      node.rcld.insert_node(node: node.lcld)
      node.lcld = nil
    end

    def prune_leaf(parent: nil, node: nil)
      # called by delete
      parent.lcld = nil if parent.lcld == node
      parent.rcld = nil if parent.rcld == node

      -1
    end

    def select_child_node(node: nil, value: nil)
      # called by delete
      return node.lcld if node.rcld.nil?
      return node.rcld if node.lcld.nil?

      node.lcld.value == value ? node.lcld : node.rcld
    end

    def dereference_node(parent: nil, node: nil)
      # called by delete
      if parent.lcld == node
        parent.lcld = node.lcld if node.rcld.nil?
        parent.lcld = node.rcld if node.lcld.nil?
      else
        parent.rcld = node.lcld if node.rcld.nil?
        parent.rcld = node.rcld if node.lcld.nil?
      end
      -1
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
        lhs = node.lcld.nil? ? -1 : node.lcld.node_height
        rhs = node.rcld.nil? ? -1 : node.rcld.node_height || 0
        return false unless (lhs - rhs).abs <= 1
      end

      true
    end

    def rebalance
      return nil if empty?

      count = 0
      until balanced?
        count += 1
        root.dfs(order: :preorder) do |node|
          sub_tree_heights = []
          sub_tree_heights << (node.lcld.nil? ? -1 : node.lcld.node_height)
          sub_tree_heights << (node.rcld.nil? ? -1 : node.rcld.node_height)

          rotate_sub_tree_left(node: node, sub_tree_heights: sub_tree_heights)
          rotate_sub_tree_right(node: node, sub_tree_heights: sub_tree_heights)
        end
      end
      count
    end

    def rotate_sub_tree_left(node: nil, sub_tree_heights: [])
      lhs, rhs = sub_tree_heights

      delta = rhs > lhs ? rhs - lhs : 0
      rotate = delta.abs / 2

      rotate.times do
        node.rotate_left
      end
    end

    def rotate_sub_tree_right(node: nil, sub_tree_heights: [])
      lhs, rhs = sub_tree_heights

      delta = lhs > rhs ? lhs - rhs : 0
      rotate = delta.abs / 2

      rotate.times do
        node.rotate_right
      end
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
        return node if !node.lcld.nil? && node.lcld.value == value
        return node if !node.rcld.nil? && node.rcld.value == value
      end

      nil
    end
  end
end
