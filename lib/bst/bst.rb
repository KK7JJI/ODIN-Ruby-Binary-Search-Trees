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
    end

    def insert(value: nil)
      insert_node(node: root, value: value) unless root.nil?
      self.root = Node.new(value: value) if root.nil?
    end

    def pretty_print
      puts "\n********* BST **********"
      arr = []
      pp_tree(node: root, level: 0, msg: 'R', arr: arr)

      arr1 = []
      arr.each do |level, value, msg|
        arr1 << "(#{msg}:#{level}:#{value})" if level.zero?
        arr1 << "#{' ' * level}#{'  ' * (level - 1)}└─(#{msg}:#{level}:#{value})" unless level.zero?
      end
      puts arr1.join("\n")
    end

    def include?(value)
      return false if empty?

      root.bfs { |node| return true if node.value == value }
      false
    end

    def delete(value)
    end

    def level_order
      return nil if empty?

      root.bfs.to_a.map { |node| node.value }
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

      cur_node = nil
      root.dfs { |node| cur_node = node if node.value == value }
      return nil if cur_node.nil?

      height = 0
      cur_node.dfs.to_a.map { |_node, level| height = level if level > height }
      height
    end

    def depth(value: nil)
      return nil if empty?
      return nil if value.nil?

      depth = nil
      root.dfs { |node, level| depth = level if node.value == value }
      return nil if depth.nil?

      depth
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

    def pp_tree(node: nil, level: 0, msg: '', arr: [])
      return if node.nil?

      arr << [level, node.value, msg]
      level += 1
      pp_tree(node: node.lc, level: level, arr: arr, msg: 'LC')
      pp_tree(node: node.rc, level: level, arr: arr, msg: 'RC')
    end
  end

  # binary search tree node
  class Node
    attr_accessor :value, :lc, :rc, :queue

    def initialize(value: nil, lc: nil, rc: nil)
      @value = value
      @lc = lc
      @rc = rc
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
    end
  end

  # queue for use in bfs traversal
  class Queue
    attr_accessor :length, :contents

    def initialize
      @contents = []
      @length = 0
    end

    def enqueue(value)
      contents.push(value)
      self.length += 1
    end

    def dequeue
      return nil if empty?

      self.length -= 1
      contents.shift
    end

    def empty?
      contents.empty?
    end
  end
end
