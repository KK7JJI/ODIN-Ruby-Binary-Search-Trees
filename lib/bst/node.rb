# frozen_string_literal: true

# binary search tree namespace
module BST
  # binary search tree node
  class Node
    attr_accessor :value, :lcld, :rcld, :queue

    def initialize(value: nil, lcld: nil, rcld: nil)
      @value = value
      @lcld = lcld
      @rcld = rcld
    end

    def leaf?
      return false if lcld
      return false if rcld

      true
    end

    def insert_node(node: nil)
      if node.value < value
        result = lcld&.insert_node(node: node)
        result = 1 if lcld.nil?
        self.lcld = node if lcld.nil?
      elsif node.value > value
        result = rcld&.insert_node(node: node)
        result = 1 if rcld.nil?
        self.rcld = node if rcld.nil?
      else
        result = 0
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
      insert_node(node: temp)
      nil
    end

    def rotate_left
      return nil if rcld.nil?

      temp = Node.new(value: value, rcld: nil, lcld: lcld)
      copy_node(source: rcld)
      insert_node(node: temp)
      nil
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

    def pp(category: :right, prefix: '', level: nil)
      # use by bst pretty_print
      level += 1 unless level.nil?
      level = 0 if level.nil?

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
