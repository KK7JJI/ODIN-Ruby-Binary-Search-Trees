# frozen_string_literal: true

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
