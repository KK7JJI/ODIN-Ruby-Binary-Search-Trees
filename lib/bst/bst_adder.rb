# frozen_string_literal: true

# project namespace
module BST
  # binary search tree insert methods
  class BSTAdder
    def insert(bst, arg)
      insert_count = build_tree(bst: bst, arr: arg) if arg.is_a?(Array)
      insert_count = insert_value(bst: bst, value: arg) unless arg.is_a?(Array)
      insert_count
    end

    def build_tree(bst: nil, arr: nil)
      insert_count = 0
      arr.each do |value|
        insert_count += insert_value(bst: bst, value: value)
      end

      insert_count
    end

    # self.size
    # bst.root

    def insert_value(bst: nil, value: nil)
      new_node = Node.new(value: value)
      insert_count = 0
      if bst.root.nil?
        bst.root = new_node
        insert_count += 1
      else
        # self.size += root&.insert_node(node: new_node)
        insert_count += insert_node(start_node: bst.root, new_node: new_node)
      end
      insert_count
    end

    def insert_node(start_node: nil, new_node: nil)
      cur_location = start_node
      inserted = false
      insert_count = 0
      until inserted
        if new_node.value < cur_location.value
          if cur_location.lcld.nil?
            cur_location.lcld = new_node
            insert_count += 1
            inserted = true
          end
          cur_location = cur_location.lcld unless cur_location.lcld.nil?
        elsif new_node.value > cur_location.value
          if cur_location.rcld.nil?
            cur_location.rcld = new_node
            insert_count += 1
            inserted = true
          end
          cur_location = cur_location.rcld unless cur_location.rcld.nil?
        else
          inserted = true
        end
      end
      insert_count
    end
  end
end
