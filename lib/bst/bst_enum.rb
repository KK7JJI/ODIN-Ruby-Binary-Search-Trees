# frozen_string_literal: true

# project namespace
module BST
  # methods for traversing BST tree
  module BSTEnum
    def bfs(start_node: nil, &block)
      return enum_for(:bfs, start_node: start_node) unless block

      queue = Queue.new

      queue.enqueue(start_node)
      until queue.empty?
        node = queue.dequeue
        queue.enqueue(node.lcld) unless node.lcld.nil?
        queue.enqueue(node.rcld) unless node.rcld.nil?
        yield(node)
      end

      self
    end

    def dfs(start_node: nil, order: :preorder, &block)
      dfs_handler[order].call(start_node: start_node, &block)
    end

    def dfs_handler
      { preorder: method(:dfs_preorder),
        postorder: method(:dfs_postorder),
        inorder: method(:dfs_inorder) }
    end

    def dfs_preorder(start_node: nil, &block)
      return enum_for(:dfs_preorder, start_node: start_node, &block) unless block

      stack = []
      start_node.depth = 0
      stack.push(start_node)
      until stack.empty?
        node = stack.pop
        # increment child node depths and save them to stack
        new_depth = node.depth + 1
        node.rcld.depth = new_depth unless node.rcld.nil?
        node.lcld.depth = new_depth unless node.lcld.nil?
        stack.push(node.rcld) unless node.rcld.nil?
        stack.push(node.lcld) unless node.lcld.nil?
        yield(node, node.depth)
      end
    end

    def dfs_postorder(start_node: nil, &block)
      return enum_for(:dfs_postorder, start_node: start_node, &block) unless block

      stack = []
      postorder = []

      start_node.depth = 0
      stack.push(start_node)
      until stack.empty?
        node = stack.pop
        postorder << node
        # increment child node depths and save them to stack
        node.lcld.depth = node.depth + 1 unless node.lcld.nil?
        node.rcld.depth = node.depth + 1 unless node.rcld.nil?
        stack.push(node.lcld) unless node.lcld.nil?
        stack.push(node.rcld) unless node.rcld.nil?
      end

      until postorder.empty?
        node = postorder.pop
        yield(node, node.depth)
      end
    end

    def dfs_inorder(start_node: nil, &block)
      return enum_for(:dfs_inorder, start_node: start_node, &block) unless block

      stack = []
      node = start_node
      node.depth = 0

      until stack.empty? && node.nil?
        until node.nil?
          node.lcld.depth = node.depth + 1 unless node.lcld.nil?
          stack.push(node)
          node = node.lcld
        end
        node = stack.pop
        yield(node, node.depth)
        node.rcld.depth = node.depth + 1 unless node.rcld.nil?
        node = node.rcld
      end
    end
  end
end
