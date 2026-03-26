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

  def delete_node
    if promote_left?
      value = lc.value
      lc = nil if lc.leaf?
      delete_node(lc) if lc
    end

    return unless promote_right?

    value = rc.value
    rc = nil if rc.leaf?
    delete_node(rc) if rc
  end

  def promote_right?
    return false if rc.nil?
    return false if promote_left?

    true
  end

  def promote_left?
    return false if lc.nil?
    return false if node_height(lc) < node_height(rc)

    true
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
