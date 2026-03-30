# frozen_string_literal: true

# binary search tree namespace
module BST
  # binary search tree node
  class Node
    include BSTEnum

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
      dfs(start_node: self).to_a.map { |_node, level| height = level if level > height }
      height
    end

    def node_depth(ref_node: nil)
      depth = nil # remains nil if value not found.
      dfs(start_node: ref_node) { |node, level| return level if node == self }
      depth
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
