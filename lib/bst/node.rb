# frozen_string_literal: true

# binary search tree namespace
module BST
  # binary search tree node
  class Node
    attr_accessor :value, :lcld, :rcld, :queue, :depth

    def initialize(value: nil, lcld: nil, rcld: nil)
      @depth = nil
      @value = value
      @lcld = lcld
      @rcld = rcld
    end

    def leaf?
      return false if lcld
      return false if rcld

      true
    end

    def child_count
      return 0 if leaf?
      return 1 if lcld.nil? || rcld.nil?

      2
    end

    def node_height
      height = 0
      dfs.to_a.map { |_node, level| height = level if level > height }
      height
    end

    def node_depth(ref_node: nil)
      depth = nil # remains nil if value not found.
      ref_node.dfs { |node, level| return level if node == self }
      depth
    end

    def bfs(&block)
      return enum_for(:bfs) unless block

      queue = Queue.new

      queue.enqueue(self)
      until queue.empty?
        node = queue.dequeue
        queue.enqueue(node.lcld) unless node.lcld.nil?
        queue.enqueue(node.rcld) unless node.rcld.nil?
        yield(node)
      end

      self
    end

    def dfs(order: :preorder, &block)
      return enum_for(:dfs, order: order) unless block

      dfs_handler[order].call(&block)
    end

    def dfs_handler
      { preorder: method(:dfs_preorder),
        postorder: method(:dfs_postorder),
        inorder: method(:dfs_inorder) }
    end

    def dfs_preorder(&block)
      return enum_for(:dfs) unless block

      stack = []
      self.depth = 0
      stack.push(self)
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

    def dfs_postorder(&block)
      return enum_for(:dfs) unless block

      stack = []
      postorder = []

      self.depth = 0
      stack.push(self)
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

    def dfs_inorder(&block)
      return enum_for(:dfs) unless block

      stack = []
      node = self
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

    def pp(category: :right, prefix: '')
      # use by bst pretty_print
      lcld&.pp(prefix: ch_prefix(category, prefix, ' ', '│'),
               category: :left)

      puts node_msg(category, prefix)

      rcld&.pp(prefix: ch_prefix(category, prefix, '│', ' '),
               category: :right)
    end

    def ch_prefix(category, prefix, lcld, rcld)
      # use by bst pretty_print
      msg = {
        left: ->(prefix) { "#{prefix}#{lcld}   " },
        right: ->(prefix) { "#{prefix}#{rcld}   " }
      }
      msg[category].call(prefix)
    end

    def node_msg(category, prefix)
      # use by bst pretty_print
      msg = {
        left: ->(prefix) { "#{prefix}┌── #{value}" },
        right: ->(prefix) { "#{prefix}└── #{value}" }
      }
      msg[category].call(prefix)
    end
  end
end
