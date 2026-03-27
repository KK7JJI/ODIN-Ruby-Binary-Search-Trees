# frozen_string_literal: true

# binary search tree node
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
    # return Node.new(value: set_value)

    if node.value < value
      lc&.insert_node(node: node)
      self.lc = node if lc.nil?
    elsif node.value > value
      rc&.insert_node(node: node)
      self.rc = node if rc.nil?
    end

    # duplicate values are not permitted in this BST.
    nil
  end

  def node_delete(root: nil)
    save_node = Node.new(value: value, lc: lc, rc: rc)

    if promote_left?
      self.value = lc.value
      left = lc.lc
      right = lc.rc
      self.lc = left
      self.rc = right
      root.insert_node(node: save_node.rc) unless save_node.rc.nil?
    elsif promote_right?
      self.value = rc.value
      left = rc.lc
      right = rc.rc
      self.lc = left
      self.rc = right
      root.insert_node(node: save_node.lc) unless save_node.lc.nil?
    end
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
    level += 1 unless level.nil?
    level = 0 if level.nil?

    lc&.pp(prefix: ch_prefix(category, prefix, ' ', '│'),
           category: :left)

    puts node_msg(category, prefix)

    rc&.pp(prefix: ch_prefix(category, prefix, '│', ' '),
           category: :right)
  end

  def ch_prefix(category, prefix, lch, rch)
    msg = {
      left: ->(prefix) { "#{prefix}#{lch}    " },
      right: ->(prefix) { "#{prefix}#{rch}   " }
    }
    msg[category].call(prefix)
  end

  def node_msg(category, prefix)
    msg = {
      left: ->(prefix) { "#{prefix}┌── #{value}" },
      right: ->(prefix) { "#{prefix}└── #{value}" }
    }
    msg[category].call(prefix)
  end
end
