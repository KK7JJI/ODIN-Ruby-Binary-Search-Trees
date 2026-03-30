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

    # def insert_node(node: nil)
    #   if node.value < value
    #     result = lcld&.insert_node(node: node)
    #     result = 1 if lcld.nil?
    #     self.lcld = node if lcld.nil?
    #   elsif node.value > value
    #     result = rcld&.insert_node(node: node)
    #     result = 1 if rcld.nil?
    #     self.rcld = node if rcld.nil?
    #   else
    #     result = 0
    #   end
    #   result
    # end

    def node_insert(new_node: nil)
      cur_location = self
      inserted = false

      until inserted
        if new_node.value < cur_location.value
          if cur_location.lcld.nil?
            cur_location.lcld = new_node
            result = 1
            inserted = true
          end
          cur_location = cur_location.lcld unless cur_location.lcld.nil?
        elsif new_node.value > cur_location.value
          if cur_location.rcld.nil?
            cur_location.rcld = new_node
            result = 1
            inserted = true
          end
          cur_location = cur_location.rcld unless cur_location.rcld.nil?
        else
          result = 0
          inserted = true
        end
      end
      result
    end

    def child_count
      return 0 if leaf?
      return 1 if lcld.nil? || rcld.nil?

      2
    end

    def copy_node(source: nil)
      self.value = source.value
      self.rcld = source.rcld
      self.lcld = source.lcld
    end

    def promote_left?
      return false if lcld.nil?
      return true if rcld.nil?
      return true if lcld.node_height > rcld.node_height

      false
    end

    def promote_right?
      return false if rcld.nil?
      return true if lcld.nil?
      return true if rcld.node_height >= lcld.node_height

      false
    end

    def rotate_right
      return nil if lcld.nil?

      temp = Node.new(value: value, rcld: rcld, lcld: nil)
      copy_node(source: lcld)
      # insert_node(node: temp)
      node_insert(new_node: temp)
      nil
    end

    def rotate_left
      return nil if rcld.nil?

      temp = Node.new(value: value, rcld: nil, lcld: lcld)
      copy_node(source: rcld)
      # insert_node(node: temp)
      node_insert(new_node: temp)
      nil
    end

    def node_height
      height = 0
      dfs2.to_a.map { |_node, level| height = level if level > height }
      height
    end

    def node_depth(ref_node: nil)
      depth = nil # remains nil if value not found.
      ref_node.dfs2 { |node, level| return level if node == self }
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

    def dfs2(order: :preorder, &block)
      return enum_for(:dfs2, order: order) unless block

      if order == :preorder
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

      if order == :postorder
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

      if order == :inorder
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
      self
    end

    def dfs(order: :inorder, level: nil, &block)
      return enum_for(:dfs, order: order, level: level) unless block

      level += 1 unless level.nil?
      level = 0 if level.nil?

      yield(self, level) if order == :preorder
      lcld&.dfs(order: order, level: level, &block)
      yield(self, level) if order == :inorder
      rcld&.dfs(order: order, level: level, &block)
      yield(self, level) if order == :postorder

      self
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
