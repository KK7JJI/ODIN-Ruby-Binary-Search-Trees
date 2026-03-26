# frozen_string_literal: true

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
