# frozen_string_literal: true

# binary search tree node
module BST
  class Node
    attr_accessor :value, :lc, :rc, :queue

    def initialize(value: nil, lc: nil, rc: nil)
      @value = value
      @lc = lc
      @rc = rc
    end

    def leaf?
      return false if lc
      return false if rc

      true
    end

    def insert_node(node: nil)
      if node.value < value
        result = lc&.insert_node(node: node)
        result = 1 if lc.nil?
        self.lc = node if lc.nil?
      elsif node.value > value
        result = rc&.insert_node(node: node)
        result = 1 if rc.nil?
        self.rc = node if rc.nil?
      else
        result = 0
      end
      result
    end

    def child_count
      return 0 if leaf?
      return 1 if lc.nil? || rc.nil?

      2
    end

    def copy_node(source: nil)
      self.value = source.value
      self.rc = source.rc
      self.lc = source.lc
    end

    def promote_left?
      return false if lc.nil?
      return true if rc.nil?
      return true if lc.node_height > rc.node_height

      false
    end

    def promote_right?
      return false if rc.nil?
      return true if lc.nil?
      return true if rc.node_height >= lc.node_height

      false
    end

    def rotate_right
      return nil if lc.nil?

      temp = Node.new(value: value, rc: rc, lc: nil)
      copy_node(source: lc)
      insert_node(node: temp)
      nil
    end

    def rotate_left
      return nil if rc.nil?

      temp = Node.new(value: value, rc: nil, lc: lc)
      copy_node(source: rc)
      # rc = rc.nil? ? temp : rc.insert_node(node: temp)
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
        queue.enqueue(node.lc) unless node.lc.nil?
        queue.enqueue(node.rc) unless node.rc.nil?
        yield(node)
      end

      self
    end

    def dfs(order: :inorder, level: nil, &block)
      return enum_for(:dfs, order: order, level: level) unless block

      level += 1 unless level.nil?
      level = 0 if level.nil?

      yield(self, level) if order == :preorder
      lc&.dfs(order: order, level: level, &block)
      yield(self, level) if order == :inorder
      rc&.dfs(order: order, level: level, &block)
      yield(self, level) if order == :postorder

      self
    end

    def pp(category: :right, prefix: '', level: nil)
      # use by bst pretty_print
      level += 1 unless level.nil?
      level = 0 if level.nil?

      lc&.pp(prefix: ch_prefix(category, prefix, ' ', '│'),
             category: :left)

      puts node_msg(category, prefix)

      rc&.pp(prefix: ch_prefix(category, prefix, '│', ' '),
             category: :right)
    end

    def ch_prefix(category, prefix, lch, rch)
      # use by bst pretty_print
      msg = {
        left: ->(prefix) { "#{prefix}#{lch}   " },
        right: ->(prefix) { "#{prefix}#{rch}   " }
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
