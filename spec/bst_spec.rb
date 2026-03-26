require_relative '../lib/bst'

describe BST::BST do
  subject(:bst) { BST::BST.new }
  describe 'build and traverse tree' do
    it '#build_tree returns root node' do
      expect(bst.build_tree(arr: [0]).value).to eql(bst.preorder[0])
    end
    it '#build_tree returns root node' do
      expect(bst.build_tree(arr: [15, 5, 10]).value).to eql(bst.preorder[0])
    end
    unloaders = {
      inorder: ->(obj) { obj.inorder },
      preorder: ->(obj) { obj.preorder },
      postorder: ->(obj) { obj.postorder },
      levelorder: ->(obj) { obj.level_order }
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
          arr = [5, 10, 15] if name == :inorder
          arr = [10, 5, 15] if name == :preorder
          arr = [5, 15, 10] if name == :postorder
          arr = [10, 5, 15] if name == :levelorder
          expect(result).to eql(arr)
        end

        it 'load values - level 2' do
          bst.build_tree(arr: [10, 5, 15, 2, 6, 12, 16])
          result = unloader.call(bst)
          arr = [2, 5, 6, 10, 12, 15, 16] if name == :inorder
          arr = [10, 5, 2, 6, 15, 12, 16] if name == :preorder
          arr = [2, 6, 5, 12, 16, 15, 10] if name == :postorder
          arr = [10, 5, 15, 2, 6, 12, 16] if name == :levelorder
          expect(result).to eql(arr)
        end

        let(:arr_load) do
          [40, 12, 29, 13, 47, 70, 56,
           38, 44, 13, 98, 79, 0, 97,
           46, 57, 35, 47, 92, 97]
        end
        let(:arr_inorder) do
          [0, 12, 13, 29, 35, 38, 40,
           44, 46, 47, 56, 57, 70, 79,
           92, 97, 98]
        end
        let(:arr_preorder) do
          [40, 12, 0, 29, 13, 38, 35,
           47, 44, 46, 70, 56, 57, 98,
           79, 97, 92]
        end
        let(:arr_postorder) do
          [0, 13, 35, 38, 29, 12, 46,
           44, 57, 56, 92, 97, 79, 98,
           70, 47, 40]
        end
        let(:arr_levelorder) do
          [40, 12, 47, 0, 29, 44, 70,
           13, 38, 46, 56, 98, 35, 57,
           79, 97, 92]
        end
        it 'load 20 random values' do
          bst.build_tree(arr: arr_load)
          result = unloader.call(bst)

          expect(result).to eql(arr_inorder) if name == :inorder
          expect(result).to eql(arr_preorder) if name == :preorder
          expect(result).to eql(arr_postorder) if name == :postorder
          expect(result).to eql(arr_levelorder) if name == :levelorder
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
          arr = [5, 10, 15] if name == :inorder
          arr = [10, 5, 15] if name == :preorder
          arr = [5, 15, 10] if name == :postorder
          arr = [10, 5, 15] if name == :levelorder
          expect(result).to eql(arr)
        end
        it 'load values - level 2' do
          [10, 5, 15, 2, 6, 12, 16].each do |i|
            bst.insert(value: i)
          end
          result = unloader.call(bst)
          arr = [2, 5, 6, 10, 12, 15, 16] if name == :inorder
          arr = [10, 5, 2, 6, 15, 12, 16] if name == :preorder
          arr = [2, 6, 5, 12, 16, 15, 10] if name == :postorder
          arr = [10, 5, 15, 2, 6, 12, 16] if name == :levelorder
          expect(result).to eql(arr)
        end

        let(:arr_load) do
          [40, 12, 29, 13, 47, 70, 56,
           38, 44, 13, 98, 79, 0, 97,
           46, 57, 35, 47, 92, 97]
        end
        let(:arr_inorder) do
          [0, 12, 13, 29, 35, 38, 40,
           44, 46, 47, 56, 57, 70, 79,
           92, 97, 98]
        end
        let(:arr_preorder) do
          [40, 12, 0, 29, 13, 38, 35,
           47, 44, 46, 70, 56, 57, 98,
           79, 97, 92]
        end
        let(:arr_postorder) do
          [0, 13, 35, 38, 29, 12, 46,
           44, 57, 56, 92, 97, 79, 98,
           70, 47, 40]
        end
        let(:arr_levelorder) do
          [40, 12, 47, 0, 29, 44, 70,
           13, 38, 46, 56, 98, 35, 57,
           79, 97, 92]
        end
        it 'load 20 random values' do
          arr_load.each do |i|
            bst.insert(value: i)
          end
          result = unloader.call(bst)

          arr = arr_load
          arr = arr_load.sort if %i[to_a inorder].include?(name)

          expect(result).to eql(arr_inorder) if name == :inorder
          expect(result).to eql(arr_preorder) if name == :preorder
          expect(result).to eql(arr_postorder) if name == :postorder
          expect(result).to eql(arr_levelorder) if name == :levelorder
        end
      end
    end
  end
  describe '#height' do
    it 'empty tree returns nil' do
      expect(bst.height(value: 0)).to be_nil
    end
    it 'single node, value not found' do
      bst.insert(value: 1)
      expect(bst.height(value: 0)).to be_nil
    end
    it 'single node, height = 0' do
      bst.insert(value: 0)
      expect(bst.height(value: 0)).to eql(0)
    end
    it 'first level, root = 1, leaves = 0' do
      bst.build_tree(arr: [10, 5, 15])
      expect(bst.height(value: 0)).to be_nil
      expect(bst.height(value: 10)).to eql(1)
      expect(bst.height(value: 5)).to eql(0)
      expect(bst.height(value: 15)).to eql(0)
    end
    it 'root height = 3, leaf = 0' do
      bst.build_tree(arr: [10, 5, 15, 12, 14])
      expect(bst.height(value: 0)).to be_nil
      expect(bst.height(value: 10)).to eql(3)
      expect(bst.height(value: 14)).to eql(0)
    end
  end
  describe '#depth' do
    it 'empty tree returns nil' do
      expect(bst.depth(value: 0)).to be_nil
    end
    it 'single node, value not found' do
      bst.insert(value: 1)
      expect(bst.depth(value: 0)).to be_nil
    end
    it 'single node, height = 0' do
      bst.insert(value: 0)
      expect(bst.depth(value: 0)).to eql(0)
    end
    it 'first level, root = 0, leaves = 1' do
      bst.build_tree(arr: [10, 5, 15])
      expect(bst.depth(value: 0)).to be_nil
      expect(bst.depth(value: 10)).to eql(0)
      expect(bst.depth(value: 5)).to eql(1)
      expect(bst.depth(value: 15)).to eql(1)
    end
    it 'root depth = 0, leaf = 3' do
      bst.build_tree(arr: [10, 5, 15, 12, 14])
      expect(bst.depth(value: 0)).to be_nil
      expect(bst.depth(value: 10)).to eql(0)
      expect(bst.depth(value: 14)).to eql(3)
    end
  end
  describe '#include?' do
    it 'return false on empty tree' do
      expect(bst.include?(0)).to eql(false)
    end
    it 'return true when value is in tree' do
      bst.build_tree(arr: [10, 5, 15, 12, 14])
      expect(bst.include?(10)).to eql(true)
      expect(bst.include?(5)).to eql(true)
      expect(bst.include?(15)).to eql(true)
      expect(bst.include?(12)).to eql(true)
      expect(bst.include?(14)).to eql(true)
    end
    it 'return false when value is not in tree' do
      bst.build_tree(arr: [10, 5, 15, 12, 14])
      expect(bst.include?(9)).to eql(false)
    end
  end
end
