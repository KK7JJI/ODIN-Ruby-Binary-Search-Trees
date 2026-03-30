# frozen_string_literal: true

# project namespace
module BST
  # binary search tree node delete

  class BSTRemover
    include BSTEnum

    def delete(bst, arg)
      delete_count = 0
      delete_count += delete_node(bst: bst, value: arg)
      delete_count
    end

    private

    def delete_node(bst: nil, value: nil)
      return 0 if bst.empty?
      return 0 if value.nil?

      # a reference to the parent does not exist on the delete node,
      # we have to find the parent explicitly.
      parent, node = find_parent_and_child(bst: bst, value: value)

      # node not found in tree
      return 0 if node.nil?

      # delete root node
      return dereference_root_node(bst: bst) if parent.nil?

      del_node = select_child_node(node: parent, value: value)

      # delete leaf nodes
      return prune_leaf(parent: parent, node: del_node) if del_node.leaf?

      # delete all other nodes in tree
      consolidate_children(node: del_node)
      dereference_node(parent: parent, node: del_node)
    end

    def find_parent_and_child(bst: nil, value: nil)
      parent = find_parent(bst: bst, value: value)
      node = find(bst: bst, value: value)
      [parent, node]
    end

    def find(bst: nil, value: nil)
      return nil if bst.empty?

      bfs(start_node: bst.root) { |node| return node if node.value == value }
      nil
    end

    def find_parent(bst: nil, value: nil)
      return nil if bst.empty?

      bfs(start_node: bst.root) do |node|
        return node if !node.lcld.nil? && node.lcld.value == value
        return node if !node.rcld.nil? && node.rcld.value == value
      end

      nil
    end

    def dereference_root_node(bst: nil)
      consolidate_children(node: bst.root)

      bst.root = nil if bst.root.leaf?
      bst.root = bst.root.rcld.nil? ? bst.root.lcld : bst.root.rcld unless bst.root.nil?

      1
    end

    def prune_leaf(parent: nil, node: nil)
      parent.lcld = nil if parent.lcld == node
      parent.rcld = nil if parent.rcld == node

      1
    end

    def select_child_node(node: nil, value: nil)
      return node.lcld if node.rcld.nil?
      return node.rcld if node.lcld.nil?

      node.lcld.value == value ? node.lcld : node.rcld
    end

    def dereference_node(parent: nil, node: nil)
      if parent.lcld == node
        parent.lcld = node.lcld if node.rcld.nil?
        parent.lcld = node.rcld if node.lcld.nil?
      else
        parent.rcld = node.lcld if node.rcld.nil?
        parent.rcld = node.rcld if node.lcld.nil?
      end

      1
    end

    def consolidate_children(node: nil)
      return nil unless node.child_count == 2

      # move_node(start_node: node.rcld, new_node: node.lcld)
      # node.lcld = nil

      cur_location = node.rcld
      target_node = node.lcld

      inserted = false
      until inserted
        if target_node.value < cur_location.value
          if cur_location.lcld.nil?
            cur_location.lcld = target_node
            inserted = true
          end
          cur_location = cur_location.lcld unless cur_location.lcld.nil?
        elsif target_node.value > cur_location.value
          if cur_location.rcld.nil?
            cur_location.rcld = target_node
            inserted = true
          end
          cur_location = cur_location.rcld unless cur_location.rcld.nil?
        else
          inserted = true
        end
      end
      node.lcld = nil
    end
  end
end
