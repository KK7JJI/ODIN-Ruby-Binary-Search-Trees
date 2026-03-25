require_relative '../lib/bst'

describe BST::BST do
  subject(:bst) { BST::BST.new }
  describe '#to_a' do
    unloaders = {
      to_a: ->(obj) { obj.to_a },
      inorder: ->(obj) { obj.to_a(order: :inorder) },
      preorder: ->(obj) { obj.to_a(order: :preorder) },
      postorder: ->(obj) { obj.to_a(order: :postorder) }
    }

    unloaders.each_pair do |name, unloader|
      context "load with #build_tree, view #{name}" do
        it 'load values - first value' do
          bst.build_tree(arr: [0])
          result = unloader.call(bst)
          expect(result).to eql([0])
        end

        it 'load values - level 1' do
          bst.build_tree(arr: [10, 5, 15])
          result = unloader.call(bst)
          arr = [5, 10, 15] if %i[to_a inorder].include?(name)
          arr = [10, 5, 15] if name == :preorder
          arr = [5, 15, 10] if name == :postorder
          expect(result).to eql(arr)
        end

        it 'load values - level 2' do
          bst.build_tree(arr: [10, 5, 15, 2, 6, 12, 16])
          result = unloader.call(bst)
          arr = [2, 5, 6, 10, 12, 15, 16] if %i[to_a inorder].include?(name)
          arr = [10, 5, 2, 6, 15, 12, 16] if name == :preorder
          arr = [2, 6, 5, 12, 16, 15, 10] if name == :postorder
          expect(result).to eql(arr)
        end

        let(:arr_load) { Array.new(100) { rand(100) } }
        it 'load 100 random values' do
          bst.build_tree(arr: arr_load)
          result = unloader.call(bst)

          arr = arr_load
          arr = arr_load.sort if %i[to_a inorder].include?(name)

          expect(result).to eql(arr.sort) if %i[to_a inorder].include?(name)
          expect(result.all? { |item| arr.include?(item) }).to eql(true)
          expect(arr.all? { |item| result.include?(item) }).to eql(true)
        end
      end

      context "load with #insert, view #{name}" do
        it 'load values - first value' do
          bst.insert(value: 0)
          result = unloader.call(bst)
          expect(result).to eql([0])
        end
        it 'load values - level 1' do
          [10, 5, 15].each do |i|
            bst.insert(value: i)
          end
          result = unloader.call(bst)
          arr = [5, 10, 15] if %i[to_a inorder].include?(name)
          arr = [10, 5, 15] if name == :preorder
          arr = [5, 15, 10] if name == :postorder
          expect(result).to eql(arr)
        end
        it 'load values - level 2' do
          [10, 5, 15, 2, 6, 12, 16].each do |i|
            bst.insert(value: i)
          end
          result = unloader.call(bst)
          arr = [2, 5, 6, 10, 12, 15, 16] if %i[to_a inorder].include?(name)
          arr = [10, 5, 2, 6, 15, 12, 16] if name == :preorder
          arr = [2, 6, 5, 12, 16, 15, 10] if name == :postorder
          expect(result).to eql(arr)
        end

        let(:arr_load) { Array.new(100) { rand(100) } }
        it 'load 100 random values' do
          arr_load.each do |i|
            bst.insert(value: i)
          end
          result = unloader.call(bst)

          arr = arr_load
          arr = arr_load.sort if %i[to_a inorder].include?(name)

          expect(result).to eql(arr.sort) if %i[to_a inorder].include?(name)
          expect(result.all? { |item| arr.include?(item) }).to eql(true)
          expect(arr.all? { |item| result.include?(item) }).to eql(true)
        end
      end
    end
  end
end
